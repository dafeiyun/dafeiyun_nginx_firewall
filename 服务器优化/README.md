# 优化服务器TCP连接数和NGINX性能

echo "* soft nofile 1000000" >> /etc/security/limits.conf

echo "* hard nofile 1000000" >> /etc/security/limits.conf

echo "ulimit -SHn 1000000">>/etc/profile

先清空原有sysctl.conf规则 > /etc/sysctl.conf

echo "fs.file-max = 1000000" >> /etc/sysctl.conf

echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf

echo "net.ipv4.tcp_max_tw_buckets = 2000">>/etc/sysctl.conf

echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf

echo "net.ipv4.tcp_fin_timeout = 30">>/etc/sysctl.conf

然后执行sysctl -p命令生效，然后reboot重启服务器.




