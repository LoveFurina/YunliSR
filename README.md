# YunliSR
#### An experimental Honkai: Star Rail 2.3.51 server emulator written in Zig.
![screenshot](https://git.xeondev.com/reversedrooms/YunliSR/raw/branch/master/screenshot.png)

# Who?
Yunli

# Why?
Because I said so.

## Requirements
[Zig 0.13.0](https://ziglang.org/download/)

## Running
### From source

Windows:
```
git clone https://git.xeondev.com/reversedrooms/YunliSR.git
cd YunliSR
start zig build run-dispatch
start zig build run-gameserver
```

Linux:
```
git clone https://git.xeondev.com/reversedrooms/YunliSR.git
cd YunliSR
zig build run-dispatch & zig build run-gameserver
```

### Using Pre-built Binaries
Navigate to the [Releases](https://git.xeondev.com/reversedrooms/YunliSR/releases)
page and download the latest release for your platform.

## Connecting
[Get 2.4 beta client](https://autopatchos.starrails.com/client/Beta/20240614195024_Wa3GBOJIRMB94tXB/StarRail_2.3.51.zip),
replace [mhypbase.dll](https://git.xeondev.com/reversedrooms/YunliSR/raw/branch/master/mhypbase.dll)
file in your game folder, it will redirect game traffic (and disable in-game censorship)

## Functionality (work in progress)
- Login and player spawn
- Test battle via calyx

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss
what you would like to change, and why.

## Bug Reports

If you find a bug, please open an issue with as much detail as possible. If you
can, please include steps to reproduce the bug.

Bad issues such as "This doesn't work" will be closed immediately, be _sure_ to
provide exact detailed steps to reproduce your bug. If it's hard to reproduce, try
to explain it and write a reproducer as best as you can.