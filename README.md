# LabVIEW0.jl
Calling Julia functions from LabVIEW (TM) using [ZeroMQ](https://zeromq.org/).

Two ways of data exchange between LV client and Julia server are supported:

## JSON
In LV, clusters get flattened to JSON. Some other data, e.g. the name of the Julia function to be called, added to JSON, too. In Julia, JSON is converted to Dict. Parts of the Dict passed as kwargs to a user provided function. Results are flattened to JSON, and, back on LV, converted to cluster(s). Any data types which are supported by both LV clusters and JSON standard can be transferred back and forth. JSON is however less efficient for big numeric arrays and doesn't directly support e.g. *Inf* or complex numbers.

## Binary

Data get flattened to a byte array. Data description is sent separately using JSON.

Currently 1D, 2D & 3D arrays of most numeric formats (integers, floats, and complex of different size as well as boolean), and RGB images are supported in both directions.

For details of usage, see the [Julia Scripts Advice](docs/src/writing_Julia_scripts.md) page as well  [Examples](docs/src/example_descriptions.md) page. See also [Installation Advice](docs/src/installation_advice.md).

Currently, LV part of the package has been tested on Windows only. For other plattforms, some minor changes could be necessary. Julia part (mostly separated into [LVServer](https://github.com/Eben60/LVServer.jl)), should work equally on all plattforms.
