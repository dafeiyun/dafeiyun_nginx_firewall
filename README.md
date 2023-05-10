# dafeiyun_nginx_firewall 2.0版本(2023-5-10更新)

说明:大飞云nginx驱动防火墙 可以实现对每个nginx上网站实现第七层CC防御 并且由我们魔改版的nginx可以自动检测cc攻击并且可以调用iptables ipset命令在网络层屏蔽ip访问

实测物理服务器E3-1230V2  100M下行宽带可以实现无视CC效果！

Telegram群:@dfy888   网站dafeiyun.com    作者Telegram:@dafeiyun 

支持操作系统Centos7.X和Debian10+

ipv4是驱动防火墙白名单文件

nginx是编译好魔改nginx二进制文件

# Centos7.X

1，第一步 先更换系统内核，安装我们提供的3个内核，然后将ipv4上传到home目录里

2，安装必要的依赖项yum install -y net-tools和yum -y install iptables和yum -y install ipset

3，进入宝塔目录/www/server/nginx/sbin/替换我们的魔改nginx二进制文件，并且把在nginx.conf配置文件中把nginx改为root启动 将ip白名单规则dafeiyun_waf_whitelist "/home/ipv4";插入nginx.conf配置文件中的http字段里面

4，把下面4条规则加入到开机启动

echo "systemctl stop firewalld.service && systemctl disable firewalld.service">>/etc/rc.d/rc.local

echo "iptables -F">>/etc/rc.d/rc.local

这里3600代表屏蔽ip时间3600秒是1小时  ，可以自己改也可以3600

echo "ipset create dafeiyun hash:ip timeout 3600 maxelem 1000000">>/etc/rc.d/rc.local

echo "iptables -I INPUT -m set --match-set dafeiyun src -j DROP">>/etc/rc.d/rc.local

echo "insmod /home/dafeiyun_fw.ko">>/etc/rc.d/rc.local

chmod +x /etc/rc.d/rc.local

然后重启服务器检查上面这4条规则是否开机启动了

# Debian10+

1，第一步 debian无需更换内核，然后将ipv4上传到home目录里

2，安装必要的依赖项apt-get install iptables和apt-get install ipset和apt-get install net-tools

3，进入宝塔目录/www/server/nginx/sbin/替换我们的魔改nginx二进制文件，并且把在nginx.conf配置文件中把nginx改为root启动 将ip白名单规则dafeiyun_waf_whitelist "/home/ipv4";插入nginx.conf配置文件中的http字段里面

4，把下面4条规则加入到开机启动

创建一个/etc/rc.local文件，把下面4句写到rc.local文件里

ufw disable
ipset create dafeiyun hash:ip timeout 3600 maxelem 1000000
iptables -I INPUT -m set --match-set dafeiyun src -j DROP
exit 0

5，然后赋予权限chmod +x /etc/rc.local   接着启动rc-local服务systemctl enable --now rc-local

然后重启服务器检查上面这4条规则是否开机启动了



# 防火墙参数设置

dafeiyun_waf on;   这里on是开关  on代表开启cc   off是关闭

dafeiyun_waf_model 2;  这里有3个模式 ，1是无感 ，2是点击验证 3是验证码

dafeiyun_waf_only_get on;  这里on是访问js验证只允许get访问  其他访问直接iptables封ip

dafeiyun_waf_max 5;  这里5是代表如果访问5次还解不开js验证 直接iptables封ip
  
dafeiyun_waf_concurrency 500; 这个500是代表除了白名单以外的ip，所有访问者(包括通过了js验证的)每分钟请求超过500就直接iptables封ip

# 通过ipset命令查询封禁ip名单

查看ipset的屏蔽ip列表 ipset list dafeiyun

删除ipset的单个屏蔽ip列表ipset del dafeiyun 1.1.1.1

删除ipset的所有屏蔽ip列表ipset flush dafeiyun

还有很多规则 ，比如指定目录不开启cc防御 不拦截api等支付接口方法 一时间讲不完那，可以来Telegram群:@dfy888来交流 
