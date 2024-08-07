# YunliSR
#### An experimental turn-based animegame server emulator written in Zig.

基于 [Xeon的项目](https://git.xeondev.com/reversedrooms/YunliSR) 和其频道内的Popura大佬的修改微调而来，仅做存档
# 支持CN/OS 54
## JSON如何配置和修改?
- 新方法：https://srtools.pages.dev/ ,网站里数据配置完后点击右上角`config.json`即可下载配置好的文件（不要开网页翻译）
- 原方法：

![image](https://github.com/LoveFurina/YunliSR/blob/master/json_guide.png)



<!-- ## 我想用52或更新版本进游戏，该怎么做？
`dispatch.zig`里有`lua_version` `lua_url` `asset_bundle_url` `ex_resource_url`这几个字段，修改链接为对应的版本即可。`ifix_version` 始终为零

比如，我想用CNBETA2.3.52进游戏，就把这部分改为
```zig
    proto.lua_version = .{ .Const = "7377618" };
    proto.ifix_version = .{ .Const = "0" };
    proto.lua_url = .{ .Const = "https://autopatchcn-ipv6.bhsr.com/lua/BetaLive/output_7377618_3570b40a1a83" };
    proto.asset_bundle_url = .{ .Const = "https://autopatchcn-ipv6.bhsr.com/asb/BetaLive/output_7377410_818d812c7989" };
    proto.ex_resource_url = .{ .Const = "https://autopatchcn-ipv6.bhsr.com/design_data/BetaLive/output_7377410_6413f9e74bf5" };
```
然后重新编译即可 -->

## 编译要求
[Zig 0.13.0](https://ziglang.org/download/)

## 运行

### 使用预构建的二进制文件
导航到 [Actions](https://github.com/LoveFurina/YunliSR/actions)
页面并下载适合您平台的最新版本。可能需要登录账号才能看到。把上方区域的`config.json`文件下载下来并放到EXE同目录下，可以自己修改配置和阵容
### 从源码编译

Windows:
```
git clone https://github.com/LoveFurina/YunliSR
cd YunliSR
start zig build run-dispatch
start zig build run-gameserver
```
<!-- 
Linux:
```
git clone https://github.com/LoveFurina/YunliSR
cd YunliSR
zig build run-dispatch & zig build run-gameserver
``` -->


## 连接

53版本无法再使用Xeon的dll替换，请考虑使用其它代理转向工具，如我的[这个](https://github.com/LoveFurina/SR-Proxy)

## 故障排除
- 发现新版本/账号或密码错误/账号格式错误

    你没有开代理
- 登录异常1001-3

    缺少JSON文件或JSON格式不对(遗器词条、敌人阵容等不正确)

如果遇到其它问题，可以提issue询问或在discord上联系我
## 功能（WIP）
- 登录和玩家生成
- 通过花萼进行战斗测试
- 遗器/光锥可在战斗之外查看

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss
what you would like to change, and why.

## Bug Reports

If you find a bug, please open an issue with as much detail as possible. If you
can, please include steps to reproduce the bug.

Bad issues such as "This doesn't work" will be closed immediately, be _sure_ to
provide exact detailed steps to reproduce your bug. If it's hard to reproduce, try
to explain it and write a reproducer as best as you can.