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

##### 提供一个简单的配置文件/data/conf/keepalived.conf ：
```
! Configuration File for keepalived
global_defs {

   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
   vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    state MASTER
    interface enp0s8
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.12.222
    }
}

virtual_server 192.168.12.222 16001 {
    delay_loop 6
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 192.168.12.3 16001 {
        weight 1
        TCP_CHECK {
            connect_timeout 3
            delay_before_retry 3
        }
    }
    real_server 192.168.12.4 16001 {
        weight 1
        TCP_CHECK {
            connect_timeout 3
            delay_before_retry 3
        }
    }
}
```
