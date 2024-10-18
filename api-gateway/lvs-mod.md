# LVS 工作模式

默认的LVS版本有3种工作模式，DR、NAT、Tunnel。不过一些开源的LVS也提供了FullNAT模式，FullNAT并没有合进到内核主线版本，需要安装使用 https://github.com/alibaba/lvs。

## DR

DR(Direct Routing)是直接路由模式。

DR 模式逻辑比较简单，数据包通过直接路由方式转发给后端服务器，而且响应数据包是由 RS 服务器直接发送给客户端，不经过LVS。通常请求数据包会比较小，响应报文较大，经过 LVS 的数据包基本上都是小包，所以这也是 DR 模式性能较强的主要原因。

## NAT

NAT模式双向流量都经过LVS，因此 NAT 模式性能会存在一定的瓶颈。不过与其它模式区别的是，NAT 支持端口映射，且能够支持 Windows 操作系统。

## Tunnel

LVS 中的 Tunnel模式类似DR，也是一种单臂的模式，只有请求数据会经过DS，响应数据直接从后端服务器发送给客户端，性能也很强大，同时支持跨机房。

不过 RS 的响应数据包的源 IP 为 VIP，VIP 与后端服务器有可能存在跨运营商的情况，很有可能被运营商的策略封掉

## FullNAT

LVS 当前应用主要采用 DR 和 NAT 模式，但这两种模式要求 RS 和 LVS 在同一个 vlan中，导致部署成本过高。TUNNEL 模式虽然可以跨 vlan，但 RS 上需要部署 ipip 模块等，网络拓扑上需要连通外网，较复杂，不易运维。

为了解决上述问题， LVS 上添加了一种新的转发模式：FULLNAT。

该模式和 NAT 模式的区别是：Packet IN 时，除了做 DNAT，还做 SNAT（用户 ip->内 网 ip），从而实现 LVS-RealServer 间可以跨 vlan 通讯，RS 只需要连接到内网。

FullNAT一个最大的问题是：RS无法获得用户IP，为了解决这个问题，又提出了TOA的概念，主要原理是：将cip放到了TCP Option里面带给后端RS，RS上通过toa内核模块hack了getname函数，给用户态返回TCP Option中的cid。