include("./ZMQ_utils.jl")
# include("./user_functions.jl")

using ZMQ
using .UserFns

"""
    ZMQ_server()

The top-level function of the package. Start ZMQ socket, listen to requests, parse them,
execute the requested user function, send response. Repeat.
"""
function ZMQ_server()

    context = Context()
    socket = Socket(context, REP)
    ZMQ.bind(socket, "tcp://*:5555")
    initOK = false
    version = ""
    global scriptexists
    global scriptOK
    try
        # in case the server started with a user script
        # from command line via LabVIEW
        # otherwise if "using LV_ZMQ_Jl" manually
        # init these two global variables manually, too
        initOK = scriptexists && scriptOK
        version = string(PkgVersion.Version(LV_ZMQ_Jl))
        # println(initOK, " try OK")
    catch err
        if isa(err, UndefVarError)
            # this file was probably executed as standalone for development purposes
            # you know what you do, so OK
            initOK = true
            version = "unknown"
            # println(initOK, "try bad")
        end
    end
    if !initOK
        println("server initialisation failed")
        # else
        #    @show scriptexists, scriptOK, initOK
    end

    println("starting ZMQ server: Julia for LabVIEW, v=$version")
    try
        while true
            # Wait for next request from client

            bytesreceived = ZMQ.recv(socket)

            cmnd = parse_cmnd(bytesreceived)
            # @show cmnd
            response = UInt8[]
            if cmnd.command == :stop
                response = UInt8.([1, PROTOC_V])
            elseif !initOK
                if !isnothing(scriptexcep)
                    excep, stack_trace = scriptexcep
                else
                    stack_trace = []
                    excep = "Julia error on initialisation script"
                end
                err = nothing
                try
                    err = err_dict(;
                        err = true,
                        errcode = 5235817,
                        source = @__FILE__,
                        stack_trace = err_stack_trace,
                        excep = excep,
                    )
                catch
                    err = err_dict(;
                        err = true,
                        errcode = 5235817,
                        source = @__FILE__,
                        excep = "Julia error on initialisation script",
                    )
                end
                response = puttogether(; err = err, returncode = 3)
            elseif cmnd.command == :ping
                response = UInt8.([2, PROTOC_V])
            elseif cmnd.command == :callfun
                try
                    pr = parse_REQ(bytesreceived)
                    f = eval(pr.fun2call)
                    y = f(; pr.args...)
                    response = puttogether(; y = y)
                catch excep
                    err_stack_trace = stacktrace(catch_backtrace())
                    # # https://docs.julialang.org/en/v1/manual/stacktraces/#Error-handling-1
                    err = err_dict(;
                        err = true,
                        errcode = 5235805,
                        source = @__FILE__,
                        stack_trace = err_stack_trace,
                        excep = excep,
                    )
                    response = puttogether(; err = err, returncode = 3)
                end
            else
                response = UInt8.([255, PROTOC_V])
            end

            # Send reply back to client
            ZMQ.send(socket, response)

            cmnd.command == :stop && break
        end

    finally
        # clean up
        ZMQ.close(socket)
        ZMQ.close(context)
    end # try



end

# ZMQ_server()
