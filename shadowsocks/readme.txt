http://wuchong.me/blog/2015/02/02/shadowsocks-install-and-optimize/

1. ����˰�װ
�ٷ��Ƽ� Ubuntu 14.04 LTS ��Ϊ�������Ա�ʹ�� TCP Fast Open���������˵İ�װ�ǳ��򵥡�

Debian / Ubuntu:

apt-get install python-pip
pip install shadowsocks
CentOS:

yum install python-setuptools && easy_install pip
pip install shadowsocks
Ȼ��ֱ���ں�̨���У�

ssserver -p 8000 -k password -m rc4-md5 -d start
��ȻҲ����ʹ�������ļ��������ã���������/etc/shadowsocks.json�ļ��������������ݣ�

{
    "server":"my_server_ip",
    "server_port":8000,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"mypassword",
    "timeout":300,
    "method":"rc4-md5"
}
Ȼ��ʹ�������ļ��ں�̨���У�

ssserver -c /etc/shadowsocks.json -d start
���Ҫֹͣ���У��������е�start�ĳ�stop��

TIPS: ���ܷ�ʽ�Ƽ�ʹ��rc4-md5����Ϊ RC4 �� AES �ٶȿ�ü������������·�����ϻ�������������������ɵ� RC4 ����֮���Բ���ȫ����Ϊ Shadowsocks ��ÿ���������ظ�ʹ�� key��û��ʹ�� IV�������Ѿ�������ȷʵ�֣����Է���ʹ�á�������Կ� issue��

2. �ͻ��˰�װ
�ͻ��˰�װ�Ƚ����ţ�����Ͳ�˵�ˣ����Բο���ƪ���¡�

3. �����Ż�
������ܼ��ּ򵥵��Ż�������Ҳ�ǱȽ��Ƽ��ļ��֣��ܹ��õ����ͼ�Ӱ��Ч������Ȼ����һЩ�ڿƼ���û�ᵽ�����д���·����Ҳ������ָ����

3.1 �ں˲����Ż�

���ȣ��� Linux �ں������� 3.5 �����ϡ�

��һ��������ϵͳ�ļ����������������

�༭�ļ� limits.conf

vi /etc/security/limits.conf
������������

* soft nofile 51200
* hard nofile 51200
����shadowsocks������֮ǰ���������²���

ulimit -n 51200
�ڶ����������ں˲���
�޸������ļ� /etc/sysctl.conf

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
�޸ĺ�ִ�� sysctl -p ʹ������Ч


�����ϸ�дһ����ΰ�װshadowsocks���ҿ���chacha20���ܵķ���

�ϸߵ����л���

centos6 + python2.6
I. ��װ

shadowsocks

yum install m2crypto
pip install shadowsocks
libsodium

wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar zxf LATEST.tar.gz
cd libsodium*
./configure
make && make install

# �޸�����
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
II. ����

/usr/bin/ssserver -p 9000 -k www.phpgao.com -m chacha20 --user nobody
III. ��������

���ǽ��ղŵ�����д�뿪���ű��С�

echo '/usr/bin/ssserver -p 9000 -k www.phpgao.com -m chacha20 --user nobody' >> /etc/rc.local