# FriendlyWrt-M1x
Scripts and toolchain to build and flash FriendlyWrt/OpenWRT image in Apple M1/M1x MacBook Pro

The official source package of Friendlywrt only provides x86 cross-compile tools to build **uboot**, **kernel** and **sd-img**, it means that Friendlywrt can not be compiled in Apple M1x's MacBook Pro. I updated the toolkit according to the official script. Successfully lit the [NanoPi-R4S](https://wiki.friendlyarm.com/wiki/index.php/NanoPi_R4S) with customized firmware SD card by complied, packed and burned with Apple silicon. New scripts and tools are saved here to share to friends with the same demand.

### Usage:
1. Prepare the environment: It is recommended to launch focal instances by [Multipass](https://github.com/canonical/multipass) in MacOS, download: https://multipass.run/download/macos and install .pkg and into terminal:
```
% multipass launch -c 2 -m 2G -d 48G -n fwrt focal
% multipass shell fwrt
#---- in virtual box
$ apt update
$ apt upgrade
#---- Setup Development Environment
$ wget -O - https://raw.githubusercontent.com/friendlyarm/build-env-on-ubuntu-bionic/master/install.sh | bash
```
2. Get source code: the official introduction: [How_to_Build_FriendlyWrt](https://wiki.friendlyarm.com/wiki/index.php/How_to_Build_FriendlyWrt#Get_Source_Code). It is recommended to download the source package in advance to avoid a large amount of abroad traffic in the building process. Source code for NanoPi-R4S : https://dl.friendlyarm.com/nanopir4s
```
$ mkdir r4s && cd r4s
$ tar xvf /path/to/sources/friendlywrt-rk3399-kernel5-20211031.tar ./
$ ./repo/repo sync -l --no-clone-bundle
$ cd pre-download && ./unpack.sh && cd ..
$ ./repo/repo sync -c  --no-clone-bundle
```
3. Before [compile source code](https://wiki.friendlyarm.com/wiki/index.php/How_to_Build_FriendlyWrt#Compile_Source_Code), update toolchain and config file :
```
$ git clone https://github.com/metercai/FriendlyWrt-M1x.git
$ cd FriendlyWrt-M1x && ./tools-patch.sh && ./config-patch.sh && cd ..
```
4. And then, you can build uboot, kernel，friendlywrt and sd-img without pause:

`$ ./build.sh nanopi_r4s.mk`

### Memo:
1. Building uboot and kernel is easy, but friendlywrt is difficult. It was no surprise when errors occur. You can build it repeatly with the following command. The command can view the detailed building information output through another terminal window.

Terminal1:
`$ make V=s 2>&1 | tee build.log | grep -i -E "^make.*(error|[12345]...Entering dir)"`

Terminal2:
`$ tail -f build.log`

2. No matter whether you download the source package in advance or not, you will keep online to abroad because of the code package to be downloaded from github.com in building kernel and Friendlywrt process.


3. It's necessary to configure the external Go language directory:

`$ make menuconfig`

languages->go->configation->external bootstrap go root directroy: "/usr/lib/go"

4. The patch tool can pack image for SD, not for emmc(eflasher).


## 中文:
FriendlyWrt官方编译工具包只提供了x86的交叉编译工具，即不能用新的Apple M1x MacBook Pro来编译FriendlyWrt。我根据官方的编译脚本按图索骥，更新了工具包，成功在M1x的Mac上编译和烧制了FriendlyWrt的OpenWRT定制固件，并写入SD卡点亮了[NanoPi-R4S](https://wiki.friendlyarm.com/wiki/index.php/NanoPi_R4S) 。把新的脚本和工具包留存这里共享给同样需求的朋友。

### 使用方法：

1，环境准备：建议在MacOS里安装Ubuntu虚拟软件[Multipass](https://github.com/canonical/multipass), 启动focal版本的实例。官方下载：https://multipass.run/download/macos 然后安装pkg包，再进入终端窗口启动实例 ：
```
% multipass launch -c 2 -m 2G -d 48G -n fwrt focal
% multipass shell fwrt
#---- in virtual box
$ apt update
$ apt upgrade
#---- Setup Development Environment
$ wget -O - https://raw.githubusercontent.com/friendlyarm/build-env-on-ubuntu-bionic/master/install.sh | bash
```
2，获取源代码：按照FriendlyWrt官方介绍 [如何编译制作FriendlyWrt固件](https://wiki.friendlyarm.com/wiki/index.php/How_to_Build_FriendlyWrt) 获取源码。建议提前下载源码包避免编译过程中大量的海外网络流量。NanoPi-R4S的源码包在百度网盘 : https://dl.friendlyarm.com/nanopir4s
```
$ mkdir r4s && cd r4s
$ tar xvf /path/to/sources/friendlywrt-rk3399-kernel5-20211031.tar ./
$ ./repo/repo sync -l --no-clone-bundle
$ cd pre-download && ./unpack.sh && cd ..
$ ./repo/repo sync -c  --no-clone-bundle
```
3，在 [编译](https://wiki.friendlyarm.com/wiki/index.php/How_to_Build_FriendlyWrt#Compile_Source_Code) 之前，按照下面更新工具包和配置文件：
```
$ git clone https://github.com/metercai/FriendlyWrt-M1x.git
$ cd FriendlyWrt-M1x && ./tools-patch.sh && ./config-patch.sh && cd ..
```
4，然后就可以一次性的编译、构建和烧制SD固件了：（备注的注意事项在patch脚本里面已经处理）

`$ ./build.sh nanopi_r4s.mk`

### 需要提醒：

1，编译 uboot 和 kernel相对比较轻松。而friendlywrt会比较麻烦，出现错误是正常的，可以用下面命令反复多编译几次。这个命令的好处是可以通过另一终端窗口查看详细的编译状态输出。

Terminal1: `$ make V=s 2>&1 | tee build.log | grep -i -E "^make.*(error|[12345]...Entering dir)"`

Terminal2: `$ tail -f build.log`

2，不管是否预先下载了源码包，在编译过程中都需要保持海外网络持续可访问。因为编译过程中需要从GitHub上下载代码，包括kernel和FriendlyWrt两个过程都需要。我这里有一个新的源码包，可以在编译过程中进一步降低下载量，特别在kernel环节已经没有在线下载量了。

3，编译过程中需要修正外部go语言目录的配置：

`$ make menuconfig`

languages->go->configation->external bootstrap go root directroy: "/usr/lib/go"

4，目前新的脚本和工具只适合编译和构建SD固件，不适合生成eMMC固件。


