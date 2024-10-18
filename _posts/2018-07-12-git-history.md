---
title: Git仓库迁移保留提交记录
date: 2018-07-22 12:00:00 +0800
tags: [Git, 杂谈]
categories: Git
---

> 最近需要迁移Git仓库，有如下需求

* 保留原有仓库的分支
* 保留原有仓库的提交记录

通过查找资料，最后发现一种最优Git仓库迁移方案。

<!--more-->

1. 先 `clone` 原有仓库的镜像

    `git clone --mirror old.git`  (`old.git`为原有仓库Git地址)

2. 进入原有仓库目录

    `cd old.git`

3. 修改原有仓库地址为新仓库地址

    `git remote set-url --push origin new.git`(`new.git` 为新项目的Git地址)

4. 推送镜像到远程

    `git push --mirror` 需要输入新仓库的账号密码


> Git是目前世界上最先进的分布式版本控制系统（没有之一）

最后推荐一下廖雪峰老师的Git教程，受益颇多，感谢。
[Git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/001373962845513aefd77a99f4145f0a2c7a7ca057e7570000)


