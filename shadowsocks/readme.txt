http://wuchong.me/blog/2015/02/02/shadowsocks-install-and-optimize/

1. 服务端安装
官方推荐 Ubuntu 14.04 LTS 作为服务器以便使用 TCP Fast Open。服务器端的安装非常简单。

Debian / Ubuntu:

apt-get install python-pip
pip install shadowsocks
CentOS:

yum install python-setuptools && easy_install pip
pip install shadowsocks
然后直接在后台运行：

ssserver -p 8000 -k password -m rc4-md5 -d start
当然也可以使用配置文件进行配置，方法创建/etc/shadowsocks.json文件，填入如下内容：

{
    "server":"my_server_ip",
    "server_port":8000,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"mypassword",
    "timeout":300,
    "method":"rc4-md5"
}
然后使用配置文件在后台运行：

ssserver -c /etc/shadowsocks.json -d start
如果要停止运行，将命令中的start改成stop。

TIPS: 加密方式推荐使用rc4-md5，因为 RC4 比 AES 速度快好几倍，如果用在路由器上会带来显著性能提升。旧的 RC4 加密之所以不安全是因为 Shadowsocks 在每个连接上重复使用 key，没有使用 IV。现在已经重新正确实现，可以放心使用。更多可以看 issue。

2. 客户端安装
客户端安装比较入门，这里就不说了，可以参考这篇文章。

3. 加速优化
下面介绍几种简单的优化方法，也是比较推荐的几种，能够得到立竿见影的效果。当然还有一些黑科技我没提到，如有大神路过，也可留言指出。

3.1 内核参数优化

首先，将 Linux 内核升级到 3.5 或以上。

第一步，增加系统文件描述符的最大限数

编辑文件 limits.conf

vi /etc/security/limits.conf
增加以下两行

* soft nofile 51200
* hard nofile 51200
启动shadowsocks服务器之前，设置以下参数

ulimit -n 51200
第二步，调整内核参数
修改配置文件 /etc/sysctl.conf

fs.file-max = 51200

net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = hybla
修改后执行 sysctl -p 使配置生效


下面老高写一个如何安装shadowsocks并且开启chacha20加密的方法

老高的运行环境

centos6 + python2.6
I. 安装

shadowsocks

yum install m2crypto
pip install shadowsocks
libsodium

wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar zxf LATEST.tar.gz
cd libsodium*
./configure
make && make install

# 修复关联
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
II. 运行

/usr/bin/ssserver -p 9000 -k www.phpgao.com -m chacha20 --user nobody
III. 开机启动

我们将刚才的命令写入开机脚本中。

echo '/usr/bin/ssserver -p 9000 -k www.phpgao.com -m chacha20 --user nobody' >> /etc/rc.local