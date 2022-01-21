# API for Julia scripts for use with LabVIEW


## Script example

```
# script to be started from LabVIEW

using SomePackages

# doing some work

# defining user functions
function foo(;x, y)
    f = bar(x, y)
    return (; f=f)
end

function rndx(;n)
    r0 = rand(Int64)
    r1 = rand(Float32, n)
    r2 = rand(UInt8, n, n)
    return (; r0, bigarrs=(; r1, r2), )
end

fns = (; foo, rndx)
```

## Explanations and Requirements

* User provided functions must accept (only) keyword arguments
* The returned value is a NamedTuple
* Data to be binary encoded (e.g. numeric arrays) are returned in a NamedTuple element called `bigarrs`, which is a NamedTuple by itself.
* The script assigns the list of functions (again, as a NamedTuple) to be passed to the Julia server to the variable `fns`.

For the case that the Julia server is not started by LV, e.g. if it runs on a different computer, see [this example](../../src/LabVIEW/LV2Julia_examples/jl-scripts/05-multiple_functions.jl).

See also [Examples page](example_descriptions.md).
