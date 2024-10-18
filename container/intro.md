# 容器技术

容器技术最早的概念出现在40多年前，FreeBSD 系统推出了一种操作系统虚拟化技术 FreeBSD jail，这项技术可以将 FreeBSD 系统分出多个子系统，此时的容器技术只是简单实现了 Namespace 机制，后续经过不断地发展，到 Cgroups 技术被合进 Linux 内核后，Linux 操作系统虚拟化的资源隔离技术才算基本成型。 

容器技术典型的代表是 Docker，在 Docker 之外还有 CoreOS rkt、Mesos、LXC 等容器引擎，但直到 Docker 引擎的出现，创新性地提出容器镜像、仓库以及 build once，run anywhere 的目标，这才真正意义上降低了容器技术复杂性，让容器技术在现代应用中大放异彩。

发展到云原生时代，OCI 已经成为容器技术标准规范，各类容器运行时 runC、Containerd、Kata-containers 也不断涌现。