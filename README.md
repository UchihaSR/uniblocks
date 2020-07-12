# Uniblocks: Universal updatable status bar modules generator

![](preview.gif)

![Uniblocks](https://cloud.disroot.org/s/fjQCarxJZNJj5Wz/preview)

## Features

-  Can be used with any status bar application
-  Periodic & Event based update
-  Extensible & Customizable
-  Runs as fast as it gets! (hint: POSIX compliant shellscript)

## Installation

```sh
git clone https://github.com/salman-abedin/uniblocks.git && cd uniblocks && sudo make install
```

## Usage

-  Create a **~/.config/uniblocksrc** file for configuring the modules.
   Here is an [examples](https://github.com/salman-abedin/uniblocks/blob/master/example_config)

-  run `uniblocks --server` to launch the server (preferably on startup)

-  run `uniblocks --client` to generate the status string

   -  Modules are ordered according to the order in the **config**

-  run `uniblocks --client <TAG>` to generate individual modules

   -  This will be useful in order to integrate your updatable modules with any status bar applications

-  run `uniblocks --update <TAG>` to update individual modules

## Uninstallation

```sh
sudo make uninstall
```
