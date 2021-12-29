# Installation and Getting Started

## Installation
Obviously you need both Julia and LabVIEW(TM). The LabVIEW part of the package was tested on Windows only. The Julia part was tested on a Mac as well, and should actually work on all supported platforms.

Julia is FOSS and can be downloaded from https://julialang.org/downloads/ . The most current version is higly recommended, but 1.6 (LTS) would also work.

[LabVIEW](https://www.ni.com/en-ie/shop/labview.html) is commercial, but there exists a free [Community Edition](https://www.ni.com/en-ie/shop/labview/select-edition/labview-community-edition.html). This package was developed using LV2018. The minimal required LV version is 2017: If you want to use this software with LV2017, please contact [me](https://github.com/Eben60). If you have a version higher than 2018, you will need to save the LV libraries of this package for your LV version.

You also need to download [ZMQ for LabVIEW](https://sourceforge.net/projects/labview-zmq/) and install it using [NI Package Manager](https://www.ni.com/en-ie/support/downloads/software-products/download.package-manager.html).

This package is then installed under Julia in the [standard julian way](https://docs.julialang.org/en/v1/stdlib/Pkg/): type `add Labview2Jl` in the  Pkg REPL. The LabVIEW project will be installed as a part of this package. ZMQ for Julia will also be installed as a dependence.

## Getting Started

First, locate the LabVIEW folder within the installed package. You can get it from Julia REPL:  
`using Labview2Jl`  
`lv_dir();`
