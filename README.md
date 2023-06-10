# dafeiyun_nginx_firewall 3.0版本(2023-6-11更新)

说明:大飞云nginx驱动防火墙 可以实现对每个nginx上网站实现第七层CC防御(https和http) 
并且由我们魔改版的nginx可以自动检测cc攻击并且可以调用我们的驱动防火墙从网卡接口处拉黑IP丢弃流量，让cc攻击带来的宽带和cpu消耗变成0 ，给系统带来0损耗不消耗任何宽带和CPU.

由我们魔改nginx核心源代码重组版的nginx有许多普通nginx没有的特殊功能加成:比如可以防御慢速web端口攻击，防御ssl握手攻击，防御异型web包攻击，防御400异型包攻击等

实测物理服务器E3-1230V2  100M宽带可以实现无视CC效果！

Telegram群:@dfy888   网站dafeiyun.com    作者Telegram:@dafeiyun 

支持操作系统Centos7.X和Debian11+


# Centos7.X

1，第一步 先更换系统内核，安装我们提供的3个内核，然后将centos_3.0版本里所有文件上传到home目录里并给与root权限chmod +x /home/*

2，进入宝塔目录/www/server/nginx/sbin/替换我们的魔改nginx二进制文件，并且把在nginx.conf配置文件中把nginx改为root启动 将ip白名单规则dafeiyun_waf_whitelist "/home/ipv4";和nginx特殊加成功能dafeiyun_nginx_patch on;插入nginx.conf配置文件中的http字段里面

3，把下面4条规则加入到开机启动

echo "bpffs  /sys/fs/bpf  bpf  nosuid,nodev,noexec,relatime,mode=700  0 0">>/etc/fstab    这个是把驱动挂载到开机自动加载

echo "/home/dafeiyun_driver_loading -d 服务器公网UP接口名">>/etc/rc.d/rc.local   这个是把驱动挂载到开机自动加载

echo "/home/api.sh">>/etc/rc.d/rc.local  这个是一个计时器 可以每小时自动清理驱动防火墙拉黑的ip ，也添加到开机启动

chmod +x /etc/rc.d/rc.local

然后重启服务器检查上面这4条规则是否开机启动了

# Debian11+

1，第一步执行apt install linux-image-5.19.0-0.deb11.2-amd64和apt install linux-headers-5.19.0-0.deb11.2-amd64升级内核至5.19，然后执行新内核启动/usr/sbin/update-grub，然后reboot重启服务器

2，然后将debian_3.0版本里所有文件上传到home目录里并给与root权限chmod +x /home/*

3，进入宝塔目录/www/server/nginx/sbin/替换我们的魔改nginx二进制文件，并且把在nginx.conf配置文件中把nginx改为root启动 将ip白名单规则dafeiyun_waf_whitelist "/home/ipv4";插入nginx.conf配置文件中的http字段里面

4，把下面4条规则加入到开机启动

创建一个/etc/rc.local文件，把下面4句写到rc.local文件里

/home/dafeiyun_driver_loading -d 服务器公网UP接口名

/home/api.sh

exit 0

5，然后赋予权限chmod +x /etc/rc.local   接着启动rc-local服务systemctl enable --now rc-local

然后重启服务器检查上面这3条规则是否开机启动了



# 防火墙参数设置

dafeiyun_waf on;   这里on是开关  on代表开启cc   off是关闭

dafeiyun_waf_auto_model 5 300 1 600;  这是自动CC防御js验证模式 5代表每秒50X状态码出现的次数，300代表网站每秒访问300，1是自动跳转js验证，2是点击验证，3是验证码验证，600是600秒。合起来意思是网站每秒50X状态超过5次或者网站每秒访问超过300次自动开启cc防御模式1的600秒钟

dafeiyun_waf_only_model 1;   这是永久CC防御js验证模式 ，1是自动跳转js验证，2是点击验证，3是验证码验证

dafeiyun_waf_only_get on;  这里on是访问js验证只允许get访问  其他访问直接iptables封ip

dafeiyun_waf_max 5;  这里5是代表如果访问5次还解不开js验证 直接iptables封ip

dafeiyun_waf_block_444 3600;  驱动防火墙拉黑ip的同时对攻击者ip返回444 3600秒
  
dafeiyun_waf_concurrency 500; 这个500是代表除了白名单以外的ip，所有访问者(包括通过了js验证的)每分钟请求超过500就直接iptables封ip

自动CC防御js验证模式和永久CC防御js验证模式只能二选一

把这5条规则添加到nginx.conf的http字段里就是全局开启cc防御，也可以单独针对某个网站开启cc防御 只需添加到单个网站的配置文件里

每次修改完都需要重启nginx生效 ，注意:重启nginx让规则生效不能直接重启nginx，需要先停止nginx 然后在启动nginx，因为直接重启nginx可能会失败 因为nginx写到内存中的数据来不及释放，这里宝塔有个bug就是有时候nginx会不能停止和重启 ，需要执行pkill nginx命令强制杀掉nginx进程然后在启动就ok了

服务器别开http2 对cc防御有影响 ，关闭http2方法如下，把listen 443 ssl http2;里的http2删除 ，然后保存，然后停止nginx 在开启就可以了，只有配置了ssl证书和开启了https的才有

# 白名单功能
home目录里有个ipv4白名单文件，可以自行添加白名单到里面，默认白名单文件 包含了所有搜索引擎白名单ip和cf节点白名单ip 以实现cc防御不会影响网站收录和蜘蛛抓取

这是UA头白名单配置  ， dafeiyun_waf off;是一个常量 代表关闭cc防御意思 ，可以自己用正则去匹配
location / {
        if ($http_user_agent =~ "Hello,World") {
            dafeiyun_waf off;
        }

这是网站根目录一个api的文件夹白名单 不开启js验证
location = /api/ {
        dafeiyun_waf off;
    }

# 查询驱动防火墙拉黑ip名单

命令是 /home/dafeiyun_fw -l

默认驱动防火墙拉黑ip是拉黑60分钟自动释放

还有很多规则 ，比如指定目录不开启cc防御 不拦截api等支付接口方法 一时间讲不完那，可以来Telegram群:@dfy888来交流 
