```
docker pull w303972870/keepalived
```

#### 配置文件路径
```
/data/conf/keepalived.conf
```

#### 启动命令示例
#### 必须要加 --net host，否则找不到网卡， --privileged也要加上
```
docker run -dit --net host --privileged -v /data/keepalived/:/data/ docker.io/w303972870/keepalived
```

#### 我的/data/keepalived/目录结构
```
keepalived/
└── conf
    └── keepalived.conf
```

### 需要注意的是这个配置文件权限必须是644，否则会报错：Configuration file '/data/conf/keepalived.conf' is not a regular non-executable file

##### 我用了三台主机搭建redis环境，属于三主互备份（双主配置，MASTER-BACKUP和BACKUP-MASTER;如果是多主，比如三主，就是MATER(A主机)-BACKUP(B主机)-BACKUP(C主机)、BACKUP-MASTER-BACKUP和BACKUP-BACKUP-MASTER）
##### !!!各主机的global_defs配置项下的router_id不能相同


##### A主机的配置文件/data/conf/keepalived.conf ：
```
! Configuration File for keepalived
global_defs {

   router_id Redis_Id_1
   vrrp_skip_check_adv_addr
   vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance Redis1 { #定义一个实例
    state MASTER #定义为master
    interface enp0s8
    virtual_router_id 138 # 0-255 在同一个instance 中一致在整个vrrp 中唯一
    priority 200 #优先级，优先级最大的会成为master

    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress { #此实例的浮动IP
        192.168.123.20
    }
}

vrrp_instance Redis2 {
    state BACKUP
    interface enp0s8
    virtual_router_id 139
    priority 180

    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.123.30
    }
}

vrrp_instance Redis3 {
    state BACKUP
    interface enp0s8
    virtual_router_id 140
    priority 160

    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.123.40
    }
}
```
##### B主机的配置文件/data/conf/keepalived.conf ：
```
! Configuration File for keepalived
global_defs {

   router_id Redis_Id_2
   vrrp_skip_check_adv_addr
   vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance Redis1 {
    state BACKUP
    interface enp0s8
    virtual_router_id 138
    priority 160

    authentication {
        auth_type PASS
        auth_pass 1111
    }

    virtual_ipaddress {
        192.168.123.20
    }
}

vrrp_instance Redis2 {
    state MASTER
    interface enp0s8
    virtual_router_id 139
    priority 200

    authentication {
        auth_type PASS
        auth_pass 1111
    }

    virtual_ipaddress {
        192.168.123.30
    }
}

vrrp_instance Redis3 {
    state BACKUP
    interface enp0s8
    virtual_router_id 140
    priority 180

    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.123.40
    }
}
```
##### C主机的配置文件/data/conf/keepalived.conf ：
```
! Configuration File for keepalived
global_defs {

   router_id Redis_Id_3
   vrrp_skip_check_adv_addr
   vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance Redis1 {
    state BACKUP
    interface enp0s8
    virtual_router_id 138
    priority 160

    authentication {
        auth_type PASS
        auth_pass 1111
    }

    virtual_ipaddress {
        192.168.123.20
    }
}

vrrp_instance Redis2 {
    state BACKUP
    interface enp0s8
    virtual_router_id 139
    priority 200

    authentication {
        auth_type PASS
        auth_pass 1111
    }

    virtual_ipaddress {
        192.168.123.30
    }
}

vrrp_instance Redis3 {
    state MASTER
    interface enp0s8
    virtual_router_id 140
    priority 180

    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.123.40
    }
}
```