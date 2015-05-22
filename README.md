PHP SNMP Module for Zend-Server
===================
Zend Server provides a bunch of PHP modules. The SNMP package is however not provided, which is pretty annoying if you'd like to use it with the Zend Server PHP Stack.

This repo deals with that limitation and builds the module and a tidy DEB package for easy installation.

**Please note this is still a *Work In Progress*. Generated packages may or may not work. YMMV & contributions are welcome!**

Requirements
-------------

 1. Ubuntu 14.04 (tested on amd64)
 2. An installed package of `php-*-source-zend-server` where `*` can be one of these: `5.3 5.4 5.5 5.6`
 3. Diskspace to build
 4. A clone of this repo (obviously)
 5. A fairly clean system to build from (Vagrant recommended)
 6. A lot of dependencies which will be installed by the `prepare.sh` script

Usage
-------------

 1. Copy `vars.sh.dist` to `vars.sh` (`cp vars.sh.dist vars.sh`)
 2. Fill in the variables in `vars.sh`
 3. Prepare the system for building: `./prepare.sh`
 4. Compile all packages: `./compile.sh`

The `packages` folder will contain all the DEB files required to install Zend-Server-SNMP. The nicest way is to add it to your own APT Mirror.

If you'd like to set one up I can highly recommend [Freight](https://github.com/rcrowley/freight) to setup and manage your own repo.

Good luck!
