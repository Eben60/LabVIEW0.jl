# Request message structure

Bytes | format | description | values
------------ | ------------- | ------------- | -------------
**1** | Byte | Command | "p": ping, "s": stop server, "c": call function
**1** | UInt8 | Prot. version | 0x1
**4** | UInt32 | Opt. header length | m
**4** | UInt32 | Binary data length | n
**m** | Vector{UInt8} | Optional header | ..
**n** | Vector{UInt8} | Binary data | ..
**p** | Vector{UInt8} | JSON | see below

## Optional header
A message containing an optional header will be processed as correct, however the content of the optional header ignored. In future versions of protocoll an optional header could be used e.g. for a message ID.

## JSON structure

Field | format | required? | decription
------------ | ------------- | ------------- | -------------
fun2call | string | required | Name of the Julia function
kwargs | any | optional | Keyword args to be passed to that function
