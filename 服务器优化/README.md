# 优化服务器TCP连接数和NGINX性能

echo "* soft nofile 1000000" >> /etc/security/limits.conf

echo "* hard nofile 1000000" >> /etc/security/limits.conf

echo "ulimit -SHn 1000000">>/etc/profile

然后将sysctl.conf里面的内容复制粘贴到你的/etc/sysctl.conf里，然后执行sysctl -p命令生效，然后reboot重启服务器

nginx.conf是优化过的nginx配置文件，可以让nginx发挥最大性能，可以直接复制粘贴替换宝塔的nginx配置文件，同样也适用于普通nginx 不过里面的路径要做相应的更改.




