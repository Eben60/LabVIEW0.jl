include("./typedefs.jl")
include("./conversions.jl")

"""
    setglobals(;isOK, extant=scriptexists, excpn = nothing)

Set the globals of the `Labview2Jl` module. By default do not change the value of `scriptexists`.
Use this function from the top-level scripts, e.g. as executing from LabVIEW.

# Examples
```julia-repl

julia> setglobals(;isOK=true, extant=true);

```

"""
function setglobals(; isOK, extant=scriptexists, excpn = nothing)
    global scriptOK = isOK
    global scriptexists = extant
    global scriptexcep = excpn
    return nothing
end

"""
    get_script_path(p)

Accept a Julia script (with user defined functions) as full path for user functions of just
file name for examples delivered with this package. If the file not found, return the path
to the empty file "dummy.jl". If `p` is empty string, return path to "Examples-UserFn.jl",
which in turn includes some example scripts. Set the global `scriptexists` to `true`
if everything OK.

# Examples
```julia-repl

julia> include(get_script_path(raw"C:\\Users\\eben\\Desktop\\Julia\\my_functions.jl"))
julia> server_0mq4lv((;foo=foo, bar, baz))
```
"""
function get_script_path(p="")
    global scriptexists
    srcdir = @__DIR__
    dummy = joinpath(srcdir, "dummy.jl")
    _, suffix = splitext(p)
    if p == ""
        scriptexists = true
        p1 = joinpath(srcdir, "Examples-UserFn.jl")
        return p1
    elseif suffix != ".jl"
        scriptexists = false
        return dummy
    elseif isfile(p)
        scriptexists = true
        return realpath(p)
    end

    p1 = joinpath(srcdir, p) # used for example scripts residing in the package

    if isfile(p1)
        scriptexists = true
        return p1
    else
        scriptexists = false
        return dummy
    end
end

"""
    get_LVlib_path()

A helper function: return path to the LabVIEW library `LV-Julia_ZMQ-Roundtrip_lib.lvlib`

# Examples
```julia-repl

julia> using Labview2Jl
julia> get_LVlib_path()
C:/_LabView_projects/ZMQ/Labview2Jl.jl/src/LabVIEW
```
"""
function get_LVlib_path()
    srcdir = @__DIR__
    return joinpath(dirname(srcdir), "LabVIEW")
end

function StackFrame_to_NamedTuple(fm)
    #= StackFrame, see:
    https://docs.julialang.org/en/v1/base/stacktraces/

    func::Symbol
       The name of the function containing the execution context.
    linfo::Union{Core.MethodInstance, CodeInfo, Nothing}
       The MethodInstance containing the execution context (if it could be found).
    file::Symbol
       The path to the file containing the execution context.
    line::Int
       The line number in the file containing the execution context.
    from_c::Bool
       True if the code is from C.
    inlined::Bool
       True if the code is from an inlined frame.
    pointer::UInt64
    =#
    return (
        frame_summary = string(fm),
        func = fm.func,
        linfo = string(fm.linfo),
        file = fm.file,
        line = fm.line,
        from_c = fm.from_c,
        inlined = fm.inlined,
        pointer = fm.pointer,
    )
end

"""
    build_err_info(;err, errcode, source, stack_trace, excep)

Combine data for LV-style error cluster (the first three arguments), and detailed
exception information.
"""
function build_err_info(;
    err::Bool = false,
    errcode::Int = 0,
    source::String = "",
    stack_trace = [],
    excep = "",
)
    if err
        # default values on error
        if errcode == 0
            errcode = 5235805
        end
    end

    if !isempty(stack_trace)
        stack_trace = [StackFrame_to_NamedTuple(e) for e in stack_trace]
    end

    return (;
        status = err,
        code = errcode,
        source = source,
        detailed_info = (exception_or_info = string(excep), trace = stack_trace),
    )
end

"""
    puttogether(;y, err, opt_header, returncode)

Combine data to be sent to LabVIEW into a byte vector.
# Arguments
- `y`: data returned by the user function. Can be Dict, NamedTuple or other data type
    convertible to pairs with  `key::T where T<: Union{Symbol, AbstractString}`
- other arguments are self-explaining
"""
function puttogether(;
    y = Dict{Symbol,Any}(),
    err = build_err_info(),
    opt_header::ByteArr = UInt8[],
    returncode::Int = 0,
)

    returncode = UInt8(returncode)
    y = Dict{Symbol,Any}(pairs(y)) # y could be Dict or named tuple

    @assert haskey(err, :status) &
            haskey(err, :code) &
            haskey(err, :source) &
            haskey(err, :detailed_info)

    if haskey(y, :bigarrs)
        arrs = pop!(y, :bigarrs)
        bin_data, bindata_descr = nums2bin(arrs)
        push!(y, :bindata_descr => bindata_descr)
    elseif haskey(y, :bin_data)
        bin_data = y[:bin_data]
    else
        bin_data = UInt8[]
    end
    push!(y, :errorinfo => err)
    jsonstring = ByteArr(JSON3.write(y))

    o_h_lng = int2bytar(length(opt_header))
    bin_lng = int2bytar(length(bin_data))
    js_lng = int2bytar(length(jsonstring))

    r = vcat(returncode, PROTOC_V, o_h_lng, bin_lng, opt_header, bin_data, jsonstring)
    return r
end

function parse_cmnd(b)
    c = b[1]
    prot_v = b[2]
    prot_OK = prot_v <= PROTOC_V
    if c == UInt8('p')
        command = :ping
    elseif c == UInt8('s')
        command = :stop
    elseif c == UInt8('c')
        command = :callfun
    else
        command = :undef
    end
    return (; command, prot_OK, prot_v)
end

# # # # # # #
"""
    parse_REQ(b)

Parse data received from LabVIEW, first pass. If there are any binary data, these will be
further parsed downstream.
# Arguments
- `b::UInt8[]`: data received
"""
function parse_REQ(b)
    opt_header = fun2call = json_data = json_dict = args = bin_data = bytearr_lng = nothing
    o_h_lng_start = 3
    bin_lng_start = o_h_lng_start + 4
    o_h_lng = bytar2int(b[o_h_lng_start:3+o_h_lng_start])
    bin_lng = bytar2int(b[bin_lng_start:3+bin_lng_start])

    o_h_start = bin_lng_start + 4
    if o_h_lng > 0
        opt_header = b[o_h_start:o_h_start+o_h_lng-1]
    end

    bin_start = o_h_start + o_h_lng
    if bin_lng > 0
        bin_data = b[bin_start:bin_start+bin_lng-1]
    end

    json_start = bin_start + bin_lng
    json_data = String(b[json_start:end])
    json_dict = Dict(JSON3.read(json_data))
    fun2call = Symbol(pop!(json_dict, :fun2call))
    args = json_dict # the rest
    if haskey(args, :bindata_descr)
        bindata_descr = pop!(args, :bindata_descr)
        numarrs = bin2nums(bin_data = bin_data, bindata_descr = bindata_descr) #TODO add semicolon before kwargs?
        args = merge(args, numarrs)
    elseif !isnothing(bin_data)
        push!(args, :bin_data => bin_data)
    end
    return (; opt_header, fun2call, args)
end

function version_this_pkg()
    v = PkgVersion.Version(Labview2Jl)
    return (; major=v.major, minor=v.minor, patch=v.patch)
end
