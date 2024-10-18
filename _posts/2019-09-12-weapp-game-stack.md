---
title: 烧脑！JS+Canvas带你体验「偶消奇不消」的智商挑战
date: 2019-09-12 12:00:00 +0800
tags: [微信小游戏, JavaScript, Canvas]
categories: [代码人生, 小程序]
---

<meta name="referrer" content="no-referrer"/>

> 启逻辑之高妙，因想象而自由

**层叠拼图Plus**是一款需要空间想象力和逻辑推理能力完美结合的微信小游戏，偶消奇不消，在简单的游戏规则下却有着无数种可能性，需要你充分发挥想象力去探索，看似简单却具有极大的挑战性和趣味性，这就是其魅力所在！

<!--more-->

游戏界面预览：

![preview](https://user-gold-cdn.xitu.io/2019/9/6/16d0494a8829d90c?w=500&h=541&f=png&s=94442)

> Talk is cheap. Show me the code

**层叠拼图Plus**微信小游戏采用`js`+`canvas`实现，没有使用任何游戏引擎，对于初学者来说，也比较容易入门。接下来，我将通过以下几个点循序渐进的讲解**层叠拼图Plus**微信小游戏的实现。

- **如何解决Canvas绘图模糊？**
- **如何绘制任意多边形图形？**
- **1 + 1 = 0，「偶消奇不消」的效果如何实现？**
- **如何判断一个点是否在任意多边形内部 ？**
- **如何判断游戏结果是否正确？**
- **排行榜的展示**
- **游戏性能优化**

## 如何解决Canvas绘图模糊？

> canvas 绘图时，会从两个物理像素的中间位置开始绘制并向两边扩散 0.5 个物理像素。当设备像素比为 1 时，一个 1px 的线条实际上占据了两个物理像素（每个像素实际上只占一半），由于不存在 0.5 个像素，所以这两个像素本来不应该被绘制的部分也被绘制了，于是 1 物理像素的线条变成了 2 物理像素，视觉上就造成了模糊

绘图模糊的原因知道了，在微信小游戏里面又该如何解决呢？

```javascript
const ratio = wx.getSystemInfoSync().pixelRatio
let ctx = canvas.getContext('2d')
canvas.width = screenWidth * ratio
canvas.height = screenHeight * ratio

ctx.fillStyle = 'black'
ctx.font = `${18 * ratio}px Arial`
ctx.fillText('我是清晰的文字', x * ratio, y * ratio)

ctx.fillStyle = 'red'
ctx.fillRect(x * ratio, y * ratio, width * ratio, height * ratio)
```

可以看到，我们先通过 `wx.getSystemInfoSync().pixelRatio` 获取设备的像素比`ratio`，然后将在屏 `Canvas` 的宽度和高度按照所获取的像素比`ratio`进行放大，在绘制文字、图片的时候，坐标点 `x`、`y` 和所要绘制图形的 `width`、`height`均需要按照像素比 `ratio` 进行缩放，这样我们就可以清晰的在高清屏中绘制想要的文字、图片。

可参考微信官方 [缩放策略调整](https://developers.weixin.qq.com/community/develop/doc/00040c9903023848e0d7bd6205a401?highLine=canvas%2520%25E6%25A8%25A1%25E7%25B3%258A)

***另外，需要注意的是，这里的 `canvas` 是由 [weapp-adapter](https://developers.weixin.qq.com/minigame/dev/guide/best-practice/adapter.html) 预先调用 `wx.createCanvas()` 创建一个上屏 `Canvas`，并暴露为一个全局变量 `canvas`。***


## 如何绘制任意多边形图形？

> 任意一个多边形图形，是由多个平面坐标点所组成的图形区域。

在游戏画布内，我们以左上角为坐标原点 `{x: 0, y: 0}` ，一个多边形包含多个单位长度的平面坐标点，如：`[{ x: 1, y: 3 }, { x: 5, y: 3 }, { x: 3, y: 5 }]` 表示为一个三角形的区域，需要注意的是，`x`、`y` 并不是真实的平面坐标值，而是通过屏幕宽度计算出来的单位长度，在画布内的真实坐标值则为 `{x: x * itemWidth, y: y * itemWidth}` 。

绘制多边形代码实现如下：

```javascript
/**
 * 绘制多边形
 */
export default class Block {
    constructor() { }
    init(points, itemWidth, ctx) {
        this.points = []
        this.itemWidth = itemWidth // 单位长度
        this.ctx = ctx
        for (let i = 0; i < points.length; i++) {
            let point = points[i]
            this.points.push({
                x: point.x * this.itemWidth,
                y: point.y * this.itemWidth
            })
        }
    }

    draw() {
        this.ctx.globalCompositeOperation = 'xor'
        this.ctx.fillStyle = 'black'
        this.ctx.beginPath()
        this.ctx.moveTo(this.points[0].x, this.points[0].y)
        for (let i = 1; i < this.points.length; i++) {
            let point = this.points[i]
            this.ctx.lineTo(point.x, point.y)
        }
        this.ctx.closePath()
        this.ctx.fill()
    }
}
```

使用：

```javascript
let points = [
    [{ x: 4, y: 5 }, { x: 8, y: 9 }, { x: 4, y: 9 }],
    [{ x: 10, y: 8 }, { x: 10, y: 12 }, { x: 6, y: 12 }],
    [{ x: 7, y: 4 }, { x: 11, y: 4 }, { x: 11, y: 8 }]
]
points.map((sub_points) => {
    let block = new Block()
    block.init(sub_points, this.itemWidth, this.ctx)
    block.draw()
})
```

效果如下图：

![block](https://user-gold-cdn.xitu.io/2019/8/26/16ccb963282cbf04?w=300&h=301&f=png&s=53047)

`CanvasRenderingContext2D`其他使用方法可参考：[CanvasRenderingContext2D API 列表](https://developer.mozilla.org/zh-CN/docs/Web/API/CanvasRenderingContext2D)

## 1 + 1 = 0，「偶消奇不消」的效果如何实现？

> 1 + 1 = 0，是**层叠拼图Plus**小游戏玩法的精髓所在。

![xor](https://user-gold-cdn.xitu.io/2019/8/19/16ca96beb9a40d9f?w=300&h=306&f=png&s=36811)

有经验的同学，也许一眼就发现了，`1 + 1 = 0` 刚好符合通过 `异或运算` 得出的结果。当然，细心的同学也可能已经发现，在 `如何绘制任意多边形图形` 这一章节内，有一句特殊的代码：`this.ctx.globalCompositeOperation = 'xor'`，也正是通过设置 `CanvasContext` 的 `globalCompositeOperation` 属性值为 `xor` 便实现了「偶消奇不消」的神奇效果。

![globalCompositeOperation](https://user-gold-cdn.xitu.io/2019/8/19/16ca94dcda5b68f8?w=1526&h=522&f=png&s=115558)

`globalCompositeOperation` 是指 `在绘制新形状时应用的合成操作的类型`，其他效果可参考：[globalCompositeOperation 示例](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/globalCompositeOperation)

## 如何判断一个点是否在任意多边形内部？

> 当回转数为 0 时，点在闭合曲线外部。

讲到这里，我们已经知道如何在`Canvas`画布内绘制出偶消奇不消效果的层叠图形了，接下来我们来看下玩家如何移动选中的图形。我们发现绘制出的图形对象并没有提供点击事件绑定之类的操作，那又如何判断玩家选中了哪个图形呢？这里我们就需要去实现如何判断玩家触摸事件的`x`，`y`坐标在哪个多边形图形内部区域，从而判断出玩家选中的是哪一个多边形图形。

判断一个点是否在任意多边形内部有多种方法，比如：

- 射线法
- 面积判别法
- 叉乘判别法
- 回转数法
- ...

在**层叠拼图Plus**小游戏内，采用的是 `回转数` 法来判断玩家触摸点是否在多边形内部。`回转数` 是拓扑学中的一个基本概念，具有很重要的性质和用途。当然，展开讨论 `回转数` 的概念并不在该文的讨论范围内，我们仅需了解一个概念：**当回转数为 0 时，点在闭合曲线外部。**

![round](https://user-gold-cdn.xitu.io/2019/8/19/16ca95f23b785c58?w=300&h=244&f=gif&s=252242)

上面面这张图动态演示了回转数的概念：图中红色曲线关于点（人所在位置）的回转数为 `2`。

对于给定的点和多边形，回转数应该怎么计算呢？

- 用线段分别连接点和多边形的全部顶点

![all](https://user-gold-cdn.xitu.io/2019/8/19/16ca96251c22a09b?w=500&h=360&f=png&s=27778)

- 计算所有点与相邻顶点连线的夹角

![line](https://user-gold-cdn.xitu.io/2019/8/19/16ca9627a8a9c710?w=500&h=360&f=png&s=33046)

- 计算所有夹角和。注意每个夹角都是有方向的，所以有可能是负值

![sub](https://user-gold-cdn.xitu.io/2019/8/19/16ca962d5d1f2d07?w=500&h=360&f=png&s=35608)

最后根据角度累加值计算回转数。360°（2π）相当于一次回转。

在使用 `JavaScript` 实现时，需要注意以下问题：

- `JavaScript` 的数只有 `64` 位双精度浮点这一种。对于三角函数产生的无理数，浮点数计算不可避免会造成一些误差，因此在最后计算回转数需要做取整操作。
- 通常情况下，平面直角坐标系内一个角的取值范围是 -π 到 π 这个区间，这也是 `JavaScript` 三角函数 `Math.atan2()` 返回值的范围。但 `JavaScript` 并不能直接计算任意两条线的夹角，我们只能先计算两条线与 `x` 正轴夹角，再取两者差值。这个差值的结果就有可能超出 `-π` 到 `π` 这个区间，因此我们还需要处理差值超出取值区间的情况。

代码实现：

```javascript
/**
 * 判断点是否在多边形内/边上
 */
isPointInPolygon(p, poly) {
    let px = p.x,
        py = p.y,
        sum = 0

    for (let i = 0, l = poly.length, j = l - 1; i < l; j = i, i++) {
        let sx = poly[i].x,
            sy = poly[i].y,
            tx = poly[j].x,
            ty = poly[j].y

        // 点与多边形顶点重合或在多边形的边上
        if ((sx - px) * (px - tx) >= 0 &&
            (sy - py) * (py - ty) >= 0 &&
            (px - sx) * (ty - sy) === (py - sy) * (tx - sx)) {
            return true
        }

        // 点与相邻顶点连线的夹角
        let angle = Math.atan2(sy - py, sx - px) - Math.atan2(ty - py, tx - px)

        // 确保夹角不超出取值范围（-π 到 π）
        if (angle >= Math.PI) {
            angle = angle - Math.PI * 2
        } else if (angle <= -Math.PI) {
            angle = angle + Math.PI * 2
        }
        sum += angle
    }

    // 计算回转数并判断点和多边形的几何关系
    return Math.round(sum / Math.PI) === 0 ? false : true
}
```

*注：该章节内容图片均来自网络，如有侵权，请告知删除。另外有兴趣的同学可以使用其他方法来实现判断一个点是否在任意多边形内部。*

## 如何判断游戏结果是否正确？

> 探索的过程固然精彩，而结果却更令我们期待

通过前面的介绍我们可以知道，判断游戏结果是否正确其实就是比对玩家组合图形的 `xor` 结果与目标图形的 `xor` 结果。那么如何求多个多边形 `xor` 的结果呢？ [polygon-clipping](https://github.com/mfogel/polygon-clipping) 正是为此而生的。它不仅支持 `xor` 操作，还有其他的比如：`union`, `intersection`, `difference` 等操作。
在**层叠拼图Plus**游戏内通过 [polygon-clipping](https://github.com/mfogel/polygon-clipping) 又是怎样实现游戏结果判断的呢？

- 目标图形

![target](https://user-gold-cdn.xitu.io/2019/8/19/16ca99ee27b06341?w=300&h=288&f=png&s=34253)

多边形平面坐标点集合：

```javascript
points = [
    [{ x: 6, y: 6 }, { x: 10, y: 6 }, { x: 10, y: 10 }, { x: 6, y: 10 }],
    [{ x: 8, y: 6 }, { x: 10, y: 8 }, { x: 8, y: 10 }, { x: 6, y: 8 }]
]
```

```javascript
/**
 * 获取 多个多边形 xor 结果
 */
const polygonClipping = require('polygon-clipping')

polygonXor(points) {
    let poly = []
    points.forEach(function (sub_points) {
        let temp = []
        sub_points.forEach(function (point) {
            temp.push([point.x, point.y])
        })
        poly.push([temp])
    })

    let results = polygonClipping.xor(...poly)

    // 找出左上角的点
    let min_x = 100, min_y = 100
    results.forEach(function (sub_results) {
        sub_results.forEach(function (temps) {
            temps.forEach(function (point) {
                if (point[0] < min_x) min_x = point[0]
                if (point[1] < min_y) min_y = point[1]
            })
        })
    })

    // 以左上角为参考点 多边形平移至 原点 {x: 0, y: 0}
    results.forEach(function (sub_results) {
        sub_results.forEach(function (temps) {
            temps.forEach(function (point) {
                point[0] -= min_x
                point[1] -= min_y
            })
        })
    })
}
```

`xor`结果：

```javascript
let result = this.polygonXor(points)
result = [
    [[[0, 0], [2, 0], [0, 2], [0, 0]]],
    [[[0, 2], [2, 4], [0, 4], [0, 2]]],
    [[[2, 0], [4, 0], [4, 2], [2, 0]]],
    [[[2, 4], [4, 2], [4, 4], [2, 4]]]
]
```

同理计算出玩家操作图形的`xor`结果进行比对即可得出答案正确与否。

***需要注意的是，获取玩家的 `xor` 结果并不能直接拿来与目标图形`xor` 结果进行比较，我们需要将`xor` 的结果以左上角为参考点将图形平移至原点内，然后再进行比较，如果结果一致，则代表玩家答案正确。***

## 排行榜的展示

> 有人的地方就有江湖，有江湖的地方就有排行

在看本章节内容之前，建议先浏览一遍排行榜相关的官方文档：[好友排行榜](https://developers.weixin.qq.com/minigame/dev/guide/open-ability/ranklist.html)、[关系链数据](https://developers.weixin.qq.com/minigame/dev/guide/open-ability/open-data.html)，以便对相关内容有个大概的了解。

- 开放数据域

`开放数据域`是一个封闭、独立的 `JavaScript` 作用域。要让代码运行在开放数据域，需要在 `game.json` 中添加配置项 `openDataContext` 指定开放数据域的代码目录。添加该配置项表示小游戏启用了开放数据域，这将会导致一些限制。

```javascript
// game.json
{
  "openDataContext": "src/myOpenDataContext"
}
```

- 在游戏内使用 `wx.setUserCloudStorage(obj)` 对玩家游戏数据进行托管。

- 在开放数据域内使用 `wx.getFriendCloudStorage(obj)`拉取当前用户所有同玩好友的托管数据

- 展示关系链数据

如果想要展示通过关系链 `API` 获取到的用户数据，如绘制排行榜等业务场景，需要将排行榜绘制到 `sharedCanvas` 上，再在主域将 `sharedCanvas` 渲染上屏。

![rank](https://user-gold-cdn.xitu.io/2019/8/20/16cad11323cccf61?w=620&h=460&f=png&s=16321)

```javascript
// src/myOpenDataContext/index.js
let sharedCanvas = wx.getSharedCanvas()

function drawRankList (data) {
  data.forEach((item, index) => {
    // ...
  })
}

wx.getFriendCloudStorage({
  success: res => {
    let data = res.data
    drawRankList(data)
  }
})
```

`sharedCanvas` 是主域和开放数据域都可以访问的一个离屏画布。在开放数据域调用 `wx.getSharedCanvas()` 将返回 `sharedCanvas`。

```javascript
// src/myOpenDataContext/index.js
let sharedCanvas = wx.getSharedCanvas()
let context = sharedCanvas.getContext('2d')
context.fillStyle = 'red'
context.fillRect(0, 0, 100, 100)
```

在主域中可以通过开放数据域实例访问 `sharedCanvas`，通过 `drawImage()` 方法可以将 `sharedCanvas` 绘制到上屏画布。

```javascript
// game.js
let openDataContext = wx.getOpenDataContext()
let sharedCanvas = openDataContext.canvas

let canvas = wx.createCanvas()
let context = canvas.getContext('2d')
context.drawImage(sharedCanvas, 0, 0)
```

`sharedCanvas` 本质上也是一个离屏 `Canvas`，而重设 `Canvas` 的宽高会清空 `Canvas` 上的内容。所以要通知开放数据域去重绘 `sharedCanvas`。

```javascript
// game.js
openDataContext.postMessage({
  command: 'render'
})

// src/myOpenDataContext/index.js
openDataContext.onMessage(data => {
  if (data.command === 'render') {
    // 重绘 sharedCanvas
  }
})
```

***需要注意的是：`sharedCanvas` 的宽高只能在主域设置，不能在开放数据域中设置。***

## 游戏性能优化

> 性能优化，简而言之，就是在不影响系统运行正确性的前提下，使之运行地更快，完成特定功能所需的时间更短。

一款能让人心情愉悦的游戏，性能问题必然不能成为绊脚石。那么可以从哪些方面对游戏进行性能优化呢？

### 离屏 `Canvas`

在**层叠拼图Plus**小游戏内，针对需要大量使用且绘图繁复的静态场景，都是使用离屏 `Canvas`进行绘制的，如首页网格背景、关卡列表、排名列表等。在微信内 `wx.createCanvas()` 首次调用创建的是显示在屏幕上的画布，之后调用创建的都是离屏画布。初始化时将静态场景绘制完备，需要时直接拷贝离屏`Canvas`的图像即可。`Canvas` 绘制本身就是不断的更新帧从而达到动画的效果，通过使用离屏 `Canvas`，就大大减少了一些静态内容在上屏`Canvas`的绘制，从而提升了绘制性能。

```javascript
this.offScreenCanvas = wx.createCanvas()
this.offScreenCanvas.width = this.width * ratio
this.offScreenCanvas.height = this.height * ratio

this.ctx.drawImage(this.offScreenCanvas, x * ratio, y * ratio, this.offScreenCanvas.width, this.offScreenCanvas.height)
```

### 内存优化

玩家在游戏过程中拖动方块的移动其实就是不断更新多边形图形的坐标信息，然后不断的清空画布再重新绘制，可以想象，这个绘制是非常频繁的，按照普通的做法就需要不断去创建多个新的 `Block` 对象。针对游戏中需要频繁更新的对象，我们可以通过使用`对象池`的方法进行优化，对象池维护一个装着空闲对象的池子，如果需要对象的时候，不是直接`new`，而是从对象池中取出，如果对象池中没有空闲对象，则新建一个空闲对象，**层叠拼图Plus**小游戏内使用的是官方`demo`内已经实现的`对象池`类，实现如下：

```javascript
const __ = {
  poolDic: Symbol('poolDic')
}

/**
 * 简易的对象池实现
 * 用于对象的存贮和重复使用
 * 可以有效减少对象创建开销和避免频繁的垃圾回收
 * 提高游戏性能
 */
export default class Pool {
  constructor() {
    this[__.poolDic] = {}
  }

  /**
   * 根据对象标识符
   * 获取对应的对象池
   */
  getPoolBySign(name) {
    return this[__.poolDic][name] || ( this[__.poolDic][name] = [] )
  }

  /**
   * 根据传入的对象标识符，查询对象池
   * 对象池为空创建新的类，否则从对象池中取
   */
  getItemByClass(name, className) {
    let pool = this.getPoolBySign(name)

    let result = (  pool.length
                  ? pool.shift()
                  : new className()  )

    return result
  }

  /**
   * 将对象回收到对象池
   * 方便后续继续使用
   */
  recover(name, instance) {
    this.getPoolBySign(name).push(instance)
  }
}
```

### 垃圾回收

小游戏中，`JavaScript` 中的每一个 `Canvas` 或 `Image` 对象都会有一个客户端层的实际纹理储存，实际纹理储存中存放着 `Canvas`、`Image` 的真实纹理，通常会占用相当一部分内存。

每个客户端实际纹理储存的回收时机依赖于 `JavaScript` 中的 `Canvas`、`Image` 对象回收。在 `JavaScript` 的 `Canvas`、`Image` 对象被回收之前，客户端对应的实际纹理储存不会被回收。通过调用 `wx.triggerGC()` 方法，可以加快触发 `JavaScriptCore Garbage Collection`（垃圾回收），从而触发 `JavaScript` 中没有引用的 `Canvas`、`Image` 回收，释放对应的实际纹理储存。

但 `GC` 具体触发时机还要取决于 `JavaScriptCore` 自身机制，并不能保证调用 `wx.triggerGC()` 能马上触发回收，**层叠拼图Plus**小游戏在每局游戏开始或结束都会触发一下，及时回收内存垃圾，以保证最良好的游戏体验。

### 多线程 Worker

对于游戏来说，每帧 `16ms` 是极其宝贵的，如果有一些可以异步处理的任务，可以放置于 `Worker` 中运行，待运行结束后，再把结果返回到主线程。`Worker` 运行于一个单独的全局上下文与线程中，不能直接调用主线程的方法，`Worker` 也不具备渲染的能力。 `Worker`与主线程之间的数据传输，双方使用 `Worker.postMessage()` 来发送数据，`Worker.onMessage()` 来接收数据，传输的数据并不是直接共享，而是被复制的。

```javascript
// game.json
{
  "workers": "workers"
}

// 创建worker线程
let worker = worker = wx.createWorker('workers/request/index.js') // 文件名指定 worker 的入口文件路径，绝对路径

// 主线程向 Worker 发送消息
worker.postMessage({
  msg: 'hello worker'
})

// 主线程监听 Worker 返回消息
worker.onMessage(function (res) {
  console.log(res)
})
```

***需要注意的是：`Worker` 最大并发数量限制为 `1` 个，创建下一个前请用 `Worker.terminate()` 结束当前 `Worker`***

其他 `Worker` 相关的内容请参考微信官方文档：[多线程 Worker](https://developers.weixin.qq.com/minigame/dev/guide/base-ability/worker.html)

## 结语

短短的一篇文章，定不能将**层叠拼图Plus**小游戏的前前后后讲明白讲透彻，加上文笔有限，有描述不当的地方还望多多海涵。其实最让人心累的还是软著的申请过程，由于各种原因前前后后花了将近三个月的时间，本来也想写一下软著申请相关的内容，最后发现篇幅有点长，无奈作罢，争取后面花点时间整理一下我这边的经验，希望可以帮助到需要的童鞋。

由于项目结构以及代码还比较混乱，个人觉得，目前暂时还不适合开源。***好在，小游戏内的所有核心代码以及游戏实现思想均已呈上***，有兴趣的同学如果有相关方面的疑问也可以与我多多交流，大家互相学习，共同进步。

体验游戏：

![code](https://user-gold-cdn.xitu.io/2019/8/19/16ca8b653f22285f?w=258&h=258&f=jpeg&s=42561)

江湖不远，我们游戏里见！
