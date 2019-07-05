![](/Assets/Calatrava.png)

<p align="center">
  <img src="https://img.shields.io/badge/Build-Passing-brightgreen.svg?style=flat">
  <img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat">
  <img src="https://img.shields.io/badge/Perfect-2.x-orange.svg?style=flat">
  <img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat">
  <img src="https://img.shields.io/badge/License-AGPL--3.0-lightgrey.svg?style=flat">
  <a href="https://twitter.com/zzzhyq"><img src="https://img.shields.io/badge/twitter-@zzzhyq-blue.svg?style=flat"></a>
  <a href="http://weibo.com/trmbhs"><img src="https://img.shields.io/badge/weibo-@trmbhs-red.svg?style=flat"></a>
  <img src="https://img.shields.io/badge/made%20with-%3C3-orange.svg">
</p>

基于 [Pjango](https://github.com/enums/pjango) 的主题博客。使用 `Swift4.x` 开发，运行在 `macOS` 和 `Linux` 上。使用 Pjango，可以快速搭建你的网站。只需集成你需要的组件，而无需关心服务器和数据库具体的实现细节。

Calatrava 则是对其的高度集成，它是已经完成的博客系统。使用 Calatrava，你可以迅速在你的云服务器上运行起你的博客，直接开始写作。

## 更新

注意：个人博客最新的更新已转为私有仓库，不再开源，该仓库不再维护。

## 组分

项目包含：

- 前端样式和网页模板。
- 基于 Pjango 的博客服务器程序。
- 基于 Pjango 的可扩展插件集成。

## 安装

- 克隆此仓库。
- 修改 `AppDelegate.swift` 中的 `PJANGO_WORKSPACE` 路径。
- 若遇到无法写入日志的错误，请手动新建日志的目录，路径同样位于 `AppDelegate.swift` 中。
- 按照下文中 `准备工作` 一节中修改 `hosts` 添加本地解析。
- macOS：使用下面的命令生成 Xcode 工程进行编译：

```bash
$ swift package generate-xcodeproj
```

- Linux: 使用 `Swift Package Manager` 编译：

```bash
$ swift build
```

- macOS 中请使用 root 用户执行，否则无法使用 80 端口。
- 打开浏览器，输入 `calatravatest.com` 进入博客。

## 效果预览

参考: [我的博客](http://enumsblog.com)

如果你喜欢这个效果，可以以 Star 的方式支持我。

## 使用引导

基于 [Pjango](https://github.com/enums/Pjango) 实现，Model 和 View 分离，具体请参考 Pjango 的文档。

默认的设计下，Model 都有一分钟的内存缓存，可以修改各 Model 的 `cacheTime` 参数。

更多设置可以直接看源码后修改对应的属性。

### 1. WorkSpace 结构

默认的 WorkSpace 包含以下目录：

- static：静态资源目录，发布后可通过 url 直接访问到静态资源。
- templates：网页模板目录，包含未渲染的网页模板以及博文内容。
- runtime：运行时目录，默认情况目录下仅产生日志文件。
- filedb：文件数据驱动，默认情况下博客不关联任何数据库，数据以 json 文件方式存放在该目录下。

### 2. 准备工作

修改 hosts，添加本地解析以方便调试。

```
127.0.0.1       www.calatravatest.com
127.0.0.1       calatravatest.com
127.0.0.1       posts.calatravatest.com
127.0.0.1       project.calatravatest.com
```

`Global.swift` 和 `AppDelegate.swift` 有部分参数需要根据实际情况修改，如路径和域名等。

### 3. 修改博客参数

在默认使用文件数据驱动的情况下，在 `Workspace/filedb/default/LocalConfig.json` 修改对应参数即可。

### 4. 发布博文

以下为 macOS 平台下使用 MacDown 编写博文的步骤：

#### 4.1 编写博文内容

使用 [MacDown](http://macdown.uranusjr.com) 编写内容并导出成 HTML。

#### 4.2 转换成可用的 HTML

克隆 [这个](https://github.com/enums/Calatrava-MacDown-Html-Transformation) 仓库，编译后二进制程序可自行保存。

运行这个程序，参数为输入文件和输出文件路径，剔除导出的 HTML 中的样式部分。

#### 4.3 推送模板和配图到对应目录

将博文 HTML 推送至 `Workspace/templates/posts` 目录下。

将配图等静态资源推送至 `Workspace/static` 目录下。

编写时请注意静态资源的路径。本地编写时推荐将 `.md` 文稿临时放在 `static`目录下，以配合写作时的静态资源路径和发布以后的 url 访问地址一直。

#### 4.4 在数据库中插入博文记录

在默认使用文件数据驱动的情况下，在 `Workspace/filedb/default/posts.json` 文件中加入相应记录即可。

博文模型：

```swift
var pid = PCDataBaseField.init(name: "PID", type: .int)
var title = PCDataBaseField.init(name: "TITLE", type: .string, length: 64)
var date = PCDataBaseField.init(name: "DATE", type: .string, length: 16)
var read = PCDataBaseField.init(name: "READ", type: .int)
var love = PCDataBaseField.init(name: "LOVE", type: .int)
var tag = PCDataBaseField.init(name: "TAG", type: .string, length: 64)
```

因此，按照模型的结构，json 结构：

```json
{
  "objs" : [
    [
      "id，记录的额外字段，任意整数，不可重复",
      "PID，博文id，整数，和博文 HTML 文件名一直。如PID = 17001，对应 HTML 文件为 17001.html",
      "TITLE，博文标题",
      "DATE，博文发布日期，YYYY-MM-dd HH:mm:ss",
      "READ，阅读数量",
      "LOVE，点赞数量",
      "TAG，标签列表，以|分隔",
    ]
  ]
}
```

### 5. 添加标签、项目和建设历史等

根据上面提到的规则，根据各自的模型代码直接修改对应的 json 文件记录即可。

如果改用[Pjango-MySQL](https://github.com/enums/Pjango-MySQL)组件，直接改数据库记录即可。

### 6. 修改网页

部分页面内容是直接渲染静态网页的，如 `about.html` 中的关于内容。因此这部分内容可以直接修改 HTML。

## 联系我

发邮件给我: [enum@enumsblog.com](mailto:enum@enumsblog.com)

## 协议

![](https://www.gnu.org/graphics/agplv3-155x51.png)

Calatrava 基于 AGPL-3.0 协议进行分发和使用，更多信息参见协议文件。
