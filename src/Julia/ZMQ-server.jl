include("./ZMQ_utils.jl")
include("./test_functions.jl")
# include("./user_functions.jl")

"""
    server_0mq4lv(fns=(;); initOK=false)

`server_0mq4lv` (meaning zero MQ for LabView) is the top-level function of the package.
User functions must be supplied as a NamedTuple or Dict. Start ZMQ socket, listen to
requests, parse them, execute the requested user function, send response. Repeat.
# Arguments
- `initOK`: set it to `true` to skip check of the user script
# Examples
```julia-repl

julia> server_0mq4lv((;foo=foo, bar, baz))
```
"""
function server_0mq4lv(fns=(;); initOK=false)

    context = Context()
    socket = Socket(context, REP)
    ZMQ.bind(socket, "tcp://*:5555")
    version = string(PkgVersion.Version(LabView0mqJl))
    if isempty(fns)
        fnlist = "built-in test functions only"
    else
        fnlist = join(["built-in test functions", keys(fns)...], ", ")
    end

    external_fns() = (;ext_fns=keys(fns))

    # println(external_fns())
    # println(external_fns)
    # println(eval(:external_fns))

    global scriptexists
    global scriptOK

    if ! initOK
        if isempty(fns)
            initOK = true # package-internal functions only
        else
            initOK = scriptexists && scriptOK
        end
    end

    if initOK
        println("starting ZMQ server, Julia for LabVIEW: LabView0mqJl v=$version")
        println("available functions:")
        println(fnlist)
    else
        println("server initialisation failed")
        @show scriptexists scriptOK
    end

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
                    err = build_err_info(;
                        err = true,
                        errcode = 5235817,
                        source = @__FILE__,
                        stack_trace = err_stack_trace,
                        excep = excep,
                    )
                catch
                    err = build_err_info(;
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
                    if fn == :external_fns
                        f = external_fns
                    elseif haskey(fns, fn)
                        f = fns[fn]
                    else
                        f = eval(fn)
                    end
                    y = f(; pr.args...)
                    response = puttogether(; y = y)
                catch excep
                    err_stack_trace = stacktrace(catch_backtrace())
                    # # https://docs.julialang.org/en/v1/manual/stacktraces/#Error-handling-1
                    err = build_err_info(;
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
