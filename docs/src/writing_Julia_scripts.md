## API for Julia scripts for use with LabVIEW

return named tuple with keys as names of user provided functions and these functions as values

### Script example

```
function foo(;x, y)
    f = bar(x, y)
    return (; f=f)
end

function rnd8(;n)
    r = rand(UInt8, n)
    return (; bigarrs=(; r))
end

(; foo=foo, rnd8)
```
