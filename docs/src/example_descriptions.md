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
* Demonstrates slightly different way to get data encoded
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
