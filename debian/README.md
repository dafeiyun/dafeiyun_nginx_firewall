Debian 11+支持

1，第一步 debian11无需更换内核，然后将dafeiyun_fw.ko，ipv4，tcp.sh都上传到home目录里

2，安装必要的依赖项apt-get install iptables和apt-get install ipset和apt-get install net-tools

3，进入宝塔目录/www/server/nginx/sbin/替换我们的魔改nginx二进制文件，并且把在nginx.conf配置文件中把nginx改为root启动 将ip白名单规则dafeiyun_waf_whitelist "/home/ipv4";插入nginx.conf配置文件中的http字段里面

4，把下面4条规则加入到开机启动

cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
ufw disable
ipset create dafeiyun hash:ip timeout 3600 maxelem 1000000
iptables -I INPUT -m set --match-set dafeiyun src -j DROP
exit 0
EOF

5，然后赋予权限chmod +x /etc/rc.local   接着启动rc-local服务systemctl enable --now rc-local

其他规则都和视频里centos7.X一样


