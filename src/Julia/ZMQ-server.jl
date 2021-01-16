include("./ZMQ_utils.jl")
include("./test_functions.jl")
# include("./user_functions.jl")

using ZMQ

"""
    server_0mq4lv(fns=(;))

The top-level function of the package. User functions must be supplied as a NamedTuple
or Dict. Start ZMQ socket, listen to requests, parse them, execute the requested user
function, send response. Repeat.

# Examples
```julia-repl

julia> server_0mq4lv((;foo=foo, bar, baz))

"""
function server_0mq4lv(fns=(;))

    context = Context()
    socket = Socket(context, REP)
    ZMQ.bind(socket, "tcp://*:5555")
    initOK = false
    version = ""
    global scriptexists
    global scriptOK

    if isempty(fns)
        initOK = true # package-internal functions only
    else
        try
            # in case the server started with a user script
            # from command line via LabVIEW
            # otherwise if "using LV_ZMQ_Jl" manually
            # init these two global variables manually, too
            initOK = scriptexists && scriptOK
            version = string(PkgVersion.Version(LV_ZMQ_Jl))
            println(initOK, " try OK")
        catch err
            if isa(err, UndefVarError)
                # this file was probably executed as standalone for development purposes
                # you know what you do, so OK
                initOK = true
                version = "unknown"
            end
        end
        if !initOK
            println("server initialisation failed")
        end
    end

    println("starting ZMQ server: Julia for LabVIEW, v=$version")
    try
        while true
            # Wait for next request from client

            bytesreceived = ZMQ.recv(socket)

            cmnd = parse_cmnd(bytesreceived)
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
                    fn = pr.fun2call
                    if haskey(fns, fn)
                        f = fns[fn]
                    else
                        f = eval(fn)
                    end
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

# server_0mq4lv()
