---
title: Swift设计模式概览
date: 2020-05-01 12:00:00 +0800
tags: [Swift, iOS, 设计模式]
categories: [代码人生, 设计模式]
pin: true
---

数据结构与算法教你写出高效的代码，设计模式教你写出高质量的代码

<!-- more -->

## 创建型模式

- **[工厂方法模式](/posts/swift-design-patterns-factory-method/)**：在父类中提供一个创建对象的方法，允许子类决定实例化对象的类型。


- **[抽象工厂模式](/posts/swift-design-patterns-abstract-factory/)**：让你能创建一系列相关的对象，而无需指定其具体类。

- **[生成器模式](/posts/swift-design-patterns-builder/)**：使你能够分步骤创建复杂对象。该模式允许你使用相同的创建代码生成不同类型和形式的对象。

- **[原型模式](/posts/swift-design-patterns-prototype/)**：使你能够复制已有对象，而又无需使代码依赖它们所属的类。

- **[单例模式](/posts/swift-design-patterns-singleton/)**：让你能够保证一个类只有一个实例，并提供一个访问该实例的全局节点。

## 结构型模式

- **[适配器模式](/posts/swift-design-patterns-adapter/)**：使接口不兼容的对象能够相互合作。

- **[桥接模式](/posts/swift-design-patterns-bridge/)**：可将一个大类或一系列紧密相关的类拆分为抽象和实现两个独立的层次结构，从而能在开发时分别使用。

- **[组合模式](/posts/swift-design-patterns-composite/)**：可以使用它将对象组合成树状结构，并且能像使用独立对象一样使用它们。

- **[装饰模式](/posts/swift-design-patterns-decorator/)**：允许你通过将对象放入包含行为的特殊封装对象中来为原对象绑定新的行为。

- **[外观模式](/posts/swift-design-patterns-facade/)**：能为程序库、框架或其他复杂类提供一个简单的接口。

- **[享元模式](/posts/swift-design-patterns-flyweight/)**：摒弃了在每个对象中保存所有数据的方式，通过共享多个对象所共有的相同状态， 让你能在有限的内存容量中载入更多对象。

- **[代理模式](/posts/swift-design-patterns-proxy/)**：让你能够提供对象的替代品或其占位符。代理控制着对于原对象的访问，并允许在将请求提交给对象前后进行一些处理。

## 行为模式

- **[责任链模式](/posts/swift-design-patterns-chain-of-responsibility/)**：允许你将请求沿着处理者链进行发送。收到请求后，每个处理者均可对请求进行处理，或将其传递给链上的下个处理者。

- **[命令模式](/posts/swift-design-patterns-command/)**：它可将请求转换为一个包含与请求相关的所有信息的独立对象。该转换让你能根据不同的请求将方法参数化、延迟请求执行或将其放入队列中，且能实现可撤销操作。

- **[迭代器模式](/posts/swift-design-patterns-iterator/)**：让你能在不暴露集合底层表现形式（列表、栈和树等）的情况下遍历集合中所有的元素。

- **[中介者模式](/posts/swift-design-patterns-mediator/)**：让你减少对象之间混乱无序的依赖关系。该模式会限制对象之间的直接交互，迫使它们通过一个中介者对象进行合作。

- **[备忘录模式](/posts/swift-design-patterns-memento/)**：允许在不暴露对象实现细节的情况下保存和恢复对象之前的状态。

- **[观察者模式](/posts/swift-design-patterns-observer/)**：允许你定义一种订阅机制，可在对象事件发生时通知多个 “观察” 该对象的其他对象。

- **[状态模式](/posts/swift-design-patterns-state/)**：让你能在一个对象的内部状态变化时改变其行为，使其看上去就像改变了自身所属的类一样。

- **[策略模式](/posts/swift-design-patterns-strategy/)**：它能让你定义一系列算法，并将每种算法分别放入独立的类中，以使算法的对象能够相互替换。

- **[模板方法模式](/posts/swift-design-patterns-template-method/)**：它在超类中定义了一个算法的框架，允许子类在不修改结构的情况下重写算法的特定步骤。

- **[访问者模式](/posts/swift-design-patterns-visitor/)**：它能将算法与其所作用的对象隔离开来。