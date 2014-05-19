tilepower
=========

Powershell tool for powering up or down tiles in a VMmark benchmark environment  
Requires the VMware Powershell tool vSphere PowerCLI to be installed

The program will turn on or off all the VMs within a vSphere folder titled Tile[n] \("Tile" is case-sensitive for now\) where n is the tile number.  
The tile number can be given as:
* single number
* comma separated list of tile numbers
* range of tile numbers

The default behavior is to turn VMs on

Usage

```Tilepower.ps1 -vc <vCenter Server> -u <Username> -p <Password> -t <Tile number(s)> (-h)```

```-vc```	vCenter Server	Hostname or IP address of the vCenter server where the tiles are located  
```-u```	Username	Username of an administrator account on the vCenter server, typically "root"  
```-p```	Password	Password of the administrator account  
```-t```	Tiles		Accepts single tile, Comma separated list, or range of tiles. Lists must be enclosed in quotes.  
```-h```	Shutdown	Including this flag will shutdown or power off VMs rather than turning them on by default

Examples:

Turn off VMs in Tiles 3 through 5  
```tilepower.ps1 -vc vcenter-test -u root -p p@ssword -t '3-5' -h```

Turn on VMs in Tile 0,2,4  
```tilepower.ps1 -vc vcenter-test -u root -p p@ssword -t '0,2,4'```

Turn on just Tile 1  
```tilepower.ps1 -vc vcenter-test -u root -p p@ssword -t 1```
