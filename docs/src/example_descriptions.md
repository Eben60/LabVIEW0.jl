# Examples

This file contains a short information on each example, so that you can get a first impression even without LabVIEW on your computer. 

## 01a_add_two_numbers.vi
* Adding two numbers and getting result back
* Demonstrates all the basict needed: Starting and stopping Julia server and ZMQ communication, encoding, sending, receiving and decoding data using JSON-encoding
* [Wiring diagram](./LV-Screenshots/01a_add_two_numbers/diagramm.png) (screenshot)
* [Front panel](./LV-Screenshots/01a_add_two_numbers/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/01-add_two_numbers.jl)

## 01b_add_two_numbers.vi
* Adding two numbers and getting result back
* Demonstrate slightly different way to get data encoded
* [Wiring diagram](./LV-Screenshots/01b_add_two_numbers/diagramm.png) 
* [Front panel](./LV-Screenshots/01b_add_two_numbers/FP.png)
* Julia script: see 01a

## 02-sqrt_with_error_processing.vi
* Square root
* Demonstrate error processing
* [Wiring diagram](./LV-Screenshots/02-sqrt_with_error_processing/diagramm.png) 
* [Front panel](./LV-Screenshots/02-sqrt_with_error_processing/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/02-sqrt_with_error_processing.jl)

## 03-without_args_and_returned_val.vi
* Printing "Hello World" in the Julia terminal window
* [Wiring diagram](./LV-Screenshots/03-without_args_and_returned_val/diagramm.png) 
* [Front panel](./LV-Screenshots/03-without_args_and_returned_val/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/03-without_args_and_returned_val.jl)

## 04-nested_data_structures.vi
* Somewhat more complex data structures with JSON-encoding
* [Wiring diagram](./LV-Screenshots/04-nested_data_structures/diagramm.png) 
* [Front panel](./LV-Screenshots/04-nested_data_structures/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/04-nested_data_structures.jl)

## 05a-multiple_functions.vi
* Access to different Julia-implemented functions
* [Wiring diagram](./LV-Screenshots/05a-multiple_functions/diagramm.png) 
* [Front panel](./LV-Screenshots/05a-multiple_functions/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/05-multiple_functions.jl)

## 05b-multiple_functions.vi
* The same, but getting the list of available function from the server
* [Wiring diagram](./LV-Screenshots/05b-multiple_functions/diagramm.png) 
* [Front panel](./LV-Screenshots/05b-multiple_functions/FP.png)
* Julia script: see 05a

## 05c-multifunc_external-server.vi
* The same, but Julia server started externally (and can be on a different computer)
* [Wiring diagram](./LV-Screenshots/05c-multifunc_external-server/diagramm.png) 
* [Front panel](./LV-Screenshots/05c-multifunc_external-server/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/05-on_external_server.jl)

## 06a-arrays.vi
* Let Julia solve a system of linear equations, invert a matrix, and compute determinant. For this purpose send and receive a 2D and an 1D array.
* Demonstrate flattening and unflattening of numeric arrays to/from a binary format. JSON-encoded data are sent and received here, too.
* [Wiring diagram](./LV-Screenshots/06a-arrays/diagramm.png) 
* [Front panel](./LV-Screenshots/06a-arrays/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/06-arrays.jl)

## 06b-arrays.vi
* Solving a system of linear equations with random generated arrays of arbitrary (within reasonable) size. Comparing LabVIEW and Julia computation time.
* [Wiring diagram](./LV-Screenshots/06b-arrays/diagramm.png) 
* [Front panel](./LV-Screenshots/06b-arrays/FP.png)
* Julia script: see 06a

## 06c-arrays.vi
* Demonstrate concurrent access to Julia server: Solving a system of equations in one loop, and computing eigenvalues in separate one
* [Wiring diagram](./LV-Screenshots/06c-arrays/diagramm.png) 
* [Front panel](./LV-Screenshots/06c-arrays/FP.png)
* Julia script: see 06a

## 07-get-and_display_image.vi
* Get a test image from Julia 
* Demonstrate sending an image from Julia in binary format and unflattening it on LabVIEW. 
* [Wiring diagram](./LV-Screenshots/07-get-and_display_image.png) 
* [Front panel](./LV-Screenshots/07-get-and_display_image/FP.png)
* Accompanying [Julia script](../../src/LabVIEW/LV2Julia_examples/jl-scripts/07-get-and_display_image.jl)

