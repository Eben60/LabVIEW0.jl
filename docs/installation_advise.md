# Installation and Getting Started

## Installation
Obviously, you need both Julia and LabVIEW(TM). The LabVIEW part of the package has been tested on Windows only. The Julia part has been tested on a Mac as well, and should actually work on all supported platforms.

Julia is FOSS and can be downloaded from https://julialang.org/downloads/ . The most current version is highly recommended, but 1.6 (LTS) would also work.

[LabVIEW](https://www.ni.com/en-ie/shop/labview.html) is commercial, but there exists a free [Community Edition](https://www.ni.com/en-ie/shop/labview/select-edition/labview-community-edition.html). This package has been developed using LV2018. The minimal required LV version is 2017: If you want to use this software with LV2017, please contact [me](https://github.com/Eben60). If you have a version higher than 2018, you will need to save the LV libraries of this package for your LV version.

You also need to download [ZMQ for LabVIEW](https://sourceforge.net/projects/labview-zmq/) and install it using [NI Package Manager](https://www.ni.com/en-ie/support/downloads/software-products/download.package-manager.html).

This package is then installed under Julia in the [standard julian way](https://docs.julialang.org/en/v1/stdlib/Pkg/): type `add Labview2Jl` in the  Pkg REPL. The LabVIEW project will be installed as a part of this package. ZMQ for Julia will also be installed as a dependence.

## Getting Started

First, locate the `LabVIEW` folder within the installed package. You can get it from Julia REPL:  
`using Labview2Jl`  
`lv_dir();`

Second, study the examples from the ´LV2Julia_examples.lvlib´ library within the LabVIEW project ´Labview2Jl.lvproj´: The VIs as well as the corresponding Julia scripts.

Third, include the ´LV2Julia_core.lvlib´ library into your own project and use it in combination with your own scripts.

### Well, maybe not exactly that simple

 * Upon installation of the Julia package, the files (including LV files) are read-only,
 * After a package update, the location of the LV files may change,
 * If you are using a LV version higher that LV2018, you will need to save all LV files to your LV version.

Thus, for LV2019+ you could proceed like following:
 * Copy the whole `LabVIEW` folder from the Julia package folder to somewhere else,
 * Delete the read-only attribute from all files
 * open the copied LV project in the LabVIEW and save all files in place

Now, you can include the ´LV2Julia_core.lvlib´ library into your own project. On update, repeat.
