#  Registry

镜像管理主要是给用户提供一个可视化的镜像管理入口，主要提供包括镜像查看、删除、安全扫描和镜像复制等。 虽然 Docker Registry 提供了镜像存储和查询功能，但并不能直接在企业内部直接使用，首先是缺乏多租户管理，Docker Registry  只是提供了认证功能，并没有一套完整的鉴权机制，其次缺乏在开发、测试、生产多个环境中的镜像复制功能。镜像在开发环境打包完成，需要经过测试环境测试后，才可以推送到生产环境部署，并且在镜像部署生产环境前，还要结合业务审批流程就行发布迭代。