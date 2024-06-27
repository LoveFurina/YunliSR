# YunliSR
#### An experimental turn-based animegame server emulator written in Zig.

基于 [Xeon的项目](https://git.xeondev.com/reversedrooms/YunliSR) 微调而来
## JSON如何配置和修改?
![image](https://github.com/LoveFurina/YunliSR/blob/master/json_guide.png)

### 这个功能是你写的吗?
不，我最近没空，这是Discord上一个叫Popura的人写的

## 我想用52或更新版本进游戏，该怎么做？
`dispatch.zig`里有`lua_version` `lua_url` `asset_bundle_url` `ex_resource_url`这几个字段，修改链接为对应的版本即可。`ifix_version` 始终为零

比如，我想用CNBETA2.3.52进游戏，就把这部分改为
```zig
    proto.lua_version = .{ .Const = "7377618" };
    proto.ifix_version = .{ .Const = "0" };
    proto.lua_url = .{ .Const = "https://autopatchcn-ipv6.bhsr.com/lua/BetaLive/output_7377618_3570b40a1a83" };
    proto.asset_bundle_url = .{ .Const = "https://autopatchcn-ipv6.bhsr.com/asb/BetaLive/output_7377410_818d812c7989" };
    proto.ex_resource_url = .{ .Const = "https://autopatchcn-ipv6.bhsr.com/design_data/BetaLive/output_7377410_6413f9e74bf5" };
```
然后重新编译即可

## 要求
[Zig 0.13.0](https://ziglang.org/download/)

## 运行
### 从源码编译

Windows:
```
git clone https://github.com/LoveFurina/YunliSR
cd YunliSR
start zig build run-dispatch
start zig build run-gameserver
```

Linux:
```
git clone https://github.com/LoveFurina/YunliSR
cd YunliSR
zig build run-dispatch & zig build run-gameserver
```

### 使用预构建的二进制文件
导航到 [Actions](https://github.com/LoveFurina/YunliSR/actions)
页面并下载适合您平台的最新版本。可能需要登录账号才能看到。把上方区域的`config.json`文件下载下来并放到EXE同目录下
## 连接

如果使用OS51包，使用...即可

## 功能（WIP）
- 登录和玩家生成
- 通过花萼进行战斗测试

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss
what you would like to change, and why.

## Bug Reports

If you find a bug, please open an issue with as much detail as possible. If you
can, please include steps to reproduce the bug.

Bad issues such as "This doesn't work" will be closed immediately, be _sure_ to
provide exact detailed steps to reproduce your bug. If it's hard to reproduce, try
to explain it and write a reproducer as best as you can.