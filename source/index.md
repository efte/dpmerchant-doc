---
title: dpmerchant - 点评管家jsBridge

language_tabs:
  - javascript

toc_footers:
  - <a href='https://github.com/efte/dpmerchant-doc'>项目地址</a>
  - <a href='https://github.com/efte/dpmerchant-doc/issues'>Issue</a>

includes:
  - migration

search: true
---

# 概述

dpmerchant是用于点评管家的jsbridge接入层，为web页面提供调用native功能的能力。dpmerchant是基于[dpapp](http://efte.github.io/dpapp/)的核心部分扩展而成，与dpapp功能大部分一致，少量功能因平台特性不同而不同。

# 引入

> cortex方式

```javascript
var DPMer = require('dpmerchant');
```

dpapp模块仅支持通过Cortex通过CommonJS标准的方式引入。

# 基本用法

## 配置

在开始之前，你可以选择配置dpmerchant

```javascript
  DPMer.config({
    debug:true,
    bizname:"your-bizname"
  })
```

参数说明：
debug: 是否开启调试模式。开启后会以alert的方式打印调试信息。默认为关闭。
bizname: 调用`publish``store``retrieve`接口前需要该配置

## 调用协议

```javascript
// 示例：调出分享界面
DPMer.ready(function(){
  DPMer.share({
    title:"分享标题",
    desc:"分享描述",
    image:"http://www.dpfile.com/toevent/img/aasd.png",
    url:"http://m.dianping.com",
    success: function(){
      alert('分享成功');
    },
    fail: function(e){
      alert(e.errMsg);
    }
  });
});
```

dpmerchant默认开启校验，目前的校验规则基于域名，即只有在点评的域名下才可以使用jsbridge，包含 alpha.dp、 51ping.com、 dpfile.com、 dianping.com。可以在测试版的debug控制台中关闭校验。

所有若非特别说明，方法接受一个javascript对象作为参数，其中success，fail分别为成功与失败后的回调。
同时对于延时反馈的场景（如监听广播事件，按钮被点击的回调等），可以传入handle回调函数来处理。
回调函数接受一个json对象作为参数。对象中的字段含义如下：

- status: 代表业务执行结果，其值为 success（成功），fail（失败），action（被动回调）或 cancel（主动取消）
- result: 回调函数的执行结果，其值为 next（需要多次回调，执行后不销毁方法），error（执行错误），complete（执行成功）
- errMsg: 业务执行为fail时的错误信息

<aside class="notice">所有方法调用之前，需要使用DPMer.ready确保native已就绪。</aside>

## 错误处理

错误处理分几个层级，首先可以在api调用的fail回调中，处理对应的错误。
也可以配置`DPMer.onerror = handler`来接收未使用fail回调处理的错误。
如果`DPMer.onerror`未定义，则会抛出`DPAppError`
所有抛到window上的错误都会被记录到cat平台的js报错收集中

## 版本比对
```javascript
DPMer.Semver.gt(versionA,versionB); // 是否大于
DPMer.Semver.gte(versionA,versionB); // 是否大于等于
DPMer.Semver.lt(versionA,versionB); // 是否小于
DPMer.Semver.lte(versionA,versionB); // 是否小于等于
DPMer.Semver.eq(versionA,versionB); // 是否相同
```
使用字符串比对并不严谨，比如 "6.2.1" < "6.10.1" 会返回 false。
虽然通常app版本号第二位不会上两位数，不过推荐使用该api来比对版本。

## 判断是否支持某方法

```javascript
DPMer.isSupport(funcName); // 返回true|false
```

## 获取query参数
```javascript
DPMer.getQuery(); // 返回JSONObject
```

#测试

手机连上内网wifi，前往http://app.dp/ 下载对应的app（需v3.6.0及以上）

扫描以下二维码进入测试页面:

<p style="text-align:center">
<img src="http://j1.s1.51ping.com/mod/f2e-tool-pages/0.1.0-beta/src/img/dpmerchant-demo.qr_dpmer_new.png" alt="二维码"><br>
<input id="test-url" readonly style="width:300px;padding:5px" value="http://j1.s1.51ping.com/mod/dpmerchant/0.4.2-beta/demo/demo.html" />
</p>

<p id="test-canvas" style="text-align:center"></p>



如果使用模拟器调试，也可以通过进入`dpmer://web?url=<your-test-url>`来测试webview

# 获取信息

## 获取用户信息
<aside class="success">all version</aside>

```javascript
DPMer.getUserInfo({
  success: function(i){
    alert(i.dpid); // 用户的dpid
    alert(i.userId); // 用户id
    alert(i.edper); // edper
    alert(i.shopId); // 商户id
    alert(i.shopAccountId); // shopAccountId
  }
});
```

## 获取客户端环境信息
<aside class="success">all version</aside>

```javascript
// 同步调用
var ua = DPMer.getUA();
alert(ua);
// 异步调用（若需支持7.0之前的版本需要通过异步方法来得到ua）
DPMer.getUA({
  success: function(ua){
    alert(ua);
  }
});
```

值 | 描述
--- | ----
ua.platform | 平台 dpapp
ua.appName | app名称 点评管家内值为dpmerchant，否则为web
ua.appVersion | app版本号，如：7.0.1
ua.osName | 设备系统名 android, iphone
ua.osVersion | 设备系统版本号 4.4.2, 8.0.2

## 获取网络状态
<aside class="success">3.6.0+</aside>

```javascript
DPMer.getNetworkType({
  success: function(e){
    alert(e.networkType); // 2g, 3g, 4g, wifi, none
  }
});
```

# 功能模块

## openScheme
<aside class="success">all version</aside>
<aside class="warning">如果urlScheme是web，extra.url中如有特殊字符需要编码</aside>

```javascript
DPMer.openScheme({
  url: "dpmer://web",
  extra: {
    "url": "http://e.dianping.com/test?shopName=" + encodeURIComponent('大众点评')
  }
});
```

打开scheme


## jumpToScheme
<aside class="success">3.6.0+</aside>
<aside class="warning">如果urlScheme是web，extra.url中如有特殊字符需要编码</aside>

```javascript
DPMer.jumpToScheme({
  url: "dpmer://web",
  extra: {
    "url": "http://e.dianping.com/test?shopName=" + encodeURIComponent('大众点评')
  }
});
```

打开scheme，并关闭原窗口。

## store
<aside class="success">all version</aside>

```javascript
DPMer.store({
  key: "key",
  value: "value"
  success: function(){
    // 存值成功
  }
});
```

向native本地空间存值

<aside class="notice">使用前需要先使用`DPMer.config({bizname:"your-biz-name"});`进行配置</aside>

## retrieve
<aside class="success">all version</aside>

```javascript
DPMer.retrieve({
  key: "key",
  success: function(result){
    // 获取值成功
    // result.value
  }
});
```

向native本地空间取值

<aside class="notice">使用前需要先使用`DPMer.config({bizname:"your-biz-name"});`进行配置</aside>

## del
<aside class="success">all version</aside>

```javascript
DPMer.del({
  key: "key",
  success: function(){
    // 删除成功
  }
});
```

删除本地存储的值

<aside class="notice">使用前需要先使用`DPMer.config({bizname:"your-biz-name"});`进行配置</aside>


## Ajax请求
<aside class="success">all version</aside>

```javascript
DPMer.ajax({
  url: "http://m.api.dianping.com/indextabicon.bin?cityid=1&version=7.0.1",
  method: "get",
  keys:[
    "List",
    "HotName",
    "Id",
    "Icon",
    "Title",
    "Url",
    "Type"
  ], // 字段映射表
  success: function(data){
    alert(data.Deal.ID);
    alert(data.Deal.Price);
  }
});
```

对于DPObject的请求，由于后端返回的内容中，字段的key使用算法进行了非对称加密。

调用方需要与后端确认这些key，作为参数传入，使得方法可以映射出可读的字段。

在web中，业务方需要自行通过后端开放CORS等方式解决跨域问题。


## 上传图片
<aside class="success">3.6.0+</aside>

```javascript
DPMer.uploadImage({
  uploadUrl: 'http://api.e.51ping.com/merchant/common/uploadcommonpic.mp', // 上传图片调用的mapi接口的url
  compressFactor: 1024, // 上传图片压缩到多少尺寸以下，单位为K
  maxNum: 1, // 选择图片数
  extra: { // 业务参数
    referid: 101,// 必填
    shopaccountid: 102,// 必填
    title: 'pic',// 必填
    height: 90,// 可选
    width: 120,// 可选
    visitmode: 'x'// 可选，图片裁剪模式（”o“:填充，”c“:中心裁剪，”x“:等比缩放）
  }
  handle: function(result){
    alert(e.totalNum); // 图片上传张数
    alert(e.image); // 服务器返回的数据结果
    alert(e.progess); // start 开始上传, uploading 上传中, end 上传结束
  }
});
```

请求参数，以<a href="http://m.dper.com/mobile/api/apiDetail?id=1782" target="_blank;">API文档</a>为准

extra字段 | 描述
--- | ----
type | 图片是否绑定商家、审核
title | 图片标题（默认“pic”）
referid | 图片相关业务ID(例如：商户图片，传shopId)
shopaccountid | 商家账号
height | 求图片长度（需要上传图片路径时必填，宽和高都有定值，请咨询@王涛）
width  | 请求图片宽度（需要上传图片路径时必填）
visitmode|图片裁剪模式（”o“:填充，”c“:中心裁剪，”x“:等比缩放）（需要上传图片路径时必填）

返回值，以<a href="http://m.dper.com/mobile/model/detailModel?id=4187" target="_blank">API文档</a>为准：

result字段 | 描述
--- | ----
totalNum | 图片上传张数
progess | start 开始上传, uploading 上传中, end 上传结束
image |  示例：{"image":"http://i2.s2.51ping.com/pc/2b6f5b12eaeeaccdbfca52e6c2dde112(640x1024)/thumb.jpg","picId":97198820,"url":"/pc/2b6f5b12eaeeaccdbfca52e6c2dde112"}


## 下载图片
<aside class="success">3.6.0+</aside>

```javascript
DPMer.downloadImage({
  'imageUrl':'http://i1.dpfile.com/s/img/uc/default-avatar48c48.png',
  'imageFormat':'png', //jpg,png
  'quality':70,        // 0-100
  'maxWidth':700,
  'maxHeight':700,
  'type':0,   //0:返回base64; 1:保存到相册
  success: function(res){
    alert("下载成功");
    alert(res.imageData); // 图片base64数据，type为0时返回
  }
});
```

下载完成后，图片会出现在用户设备的资源库中。

## 查找打印机
<aside class="success">3.6.0+</aside>

```javascript
DPMer.getPrintDevice({({
  success: function(e) {
	if (e && e.deviceName) {
	  alert(e.deviceName);// 未连接打印机返回''
	}
  }
});
```

## 调用打印机
<aside class="success">3.6.0+</aside>

```javascript
DPMer.print({
  content: {},// 和具体业务相关的数据结构
  action: 'com.dianping.dpmerchant.action.push.DISHPRINT', // 广播名称
  success: function(e) {
	// 发送打印广播成功
  }
});
```
调用native发送广播，具体的打印方法由业务方实现。

## 关闭webview
<aside class="success">3.6.0+</aside>

```javascript
DPMer.closeWindow();
```

## 分享
<aside class="success">all version</aside>

```javascript
DPMer.share({
  title:"分享标题",
  desc:"分享描述",
  content:"分享内容",
  image:"http://www.dpfile.com/toevent/img/16d05c85a71b135edc39d197273746d6.png",
  url:"http://m.dianping.com",
  feed: [DPMer.Share.WECHAT_FRIENDS, DPMer.Share.WECHAT_TIMELINE],
  success: function(){
    alert('分享成功');
  }
});
```

参数 | 说明
---- | ----
title | 标题
desc | 分享描述
content | 分享内容，覆盖 title 和 desc 拼接逻辑
feed | 分享到的渠道，目前只支持微信和朋友圈(见示例)；默认为所有渠道

有些分享渠道包含标题和内容，有些只有内容。
对于只有内容的渠道，默认会拼接 title 和 desc 参数。
当设定了 content 参数时，则会直接使用该参数的取值。

# 收发消息

## 订阅消息
<aside class="success">3.6.0+</aside>

```javascript
DPMer.subscribe({
  action: 'appear',
  success: function(e){
    alert("订阅成功");
  },
  handle: function(e){
    alert("事件触发");
  }
});
```

默认广播类型如下：

名称 | 说明
----+-----
background | 应用切换到后台
foreground | 应用切换回前台
resize | 视图大小变化，键盘出现时会触发该事件，参数 `{from:{width:Number,height:Number},to:{width:Number,height:Number}}`
appear | 视图展示
disappear | 视图被隐藏



## 取消订阅
<aside class="success">3.6.0+</aside>

```javascript
DPMer.unsubscribe({
  action: 'loginSuccess',
  handle: func, // 取消特定订阅回调，不传则取消所有回调
  success: function(e){
    alert("取消绑定")
  }
});
```

## 向native发布消息
<aside class="success">3.6.0+</aside>

```javascript
DPMer.config({
  bizname:"your-biz-name"
});

DPMer.publish({
  action: 'myMessage',
  data: {
    'info': 'detail'
  },
  success: function(){
    alert("发送成功");
  }
});
```

注意，在web上因为没有native的参与，
所有方法实际行为都在web一端发生。
与传统的javascript sub/pub模式无异。

为了避免命名冲突，使用前需要先使用`DPMer.config({bizname:"your-biz-name"});`进行配置

发布的事件名为 your-biz-name:myMessage 这样。
预留的事件名之前不会加上bizname

## 弱消息
<aside class="success">all version</aside>
<aside class="warning">弱消息可能存在消息丢失等问题，仅用于兼容从efte迁移的项目，不推荐在新项目中使用。建议使用appear事件结合store/retrieve实现类似需求。</aside>
> 使用前，需先指定bizname

```javascript
DPMer.config({
  bizname:"your-biz-name"
});
```

### 订阅消息
`DPMer.weakSubscribe`

```javascript
DPMer.weakSubscribe({
  action: 'custom-event',
  success: function(e){
    alert("订阅成功");
  },
  handle: function(e){
    alert("事件触发");
  }
});
```

### 发布消息
`DPMer.weakPublish`

```javascript
DPMer.weakPublish({
  action: 'custom-event',
  data: {
    'info': 'detail'
  },
  success: function(){
    alert("发送成功");
  }
});
```

# UI界面

## 设置标题
<aside class="success">all version</aside>

```javascript
DPMer.setTitle({
  title: "标题",
  subtitle: "副标题",
  success: function(){}
});
```

<aside class="notice">3.5.x及之前只支持设置标题，不支持设置副标题。</aside>

## 下拉刷新
<aside class="success">3.6.0+</aside>

```javascript
DPMer.ready(function(){
  // 设置下拉刷新
  DPMer.setPullDown({
    success: function(){
      console.log("设置成功");
    },
    fail: function(){
      console.log("设置失败");
    },
    handle: function(){
      $.ajax({
        // ... 
        success: function(){
          // 停止下拉刷新
          DPMer.stopPullDown({
            success: function(){
              console.log("设置成功");
            },
            fail: function(){
              console.log("设置失败");
            }
          });
        }
      });
    }
  });
});
```



## 设置导航栏按钮
<aside class="success">3.6.0+</aside>

```javascript
DPMer.setLLButton({
  text: "文字",
  icon: "H5_Search", // 同时定义icon和text时，将只有icon生效
  success: function(){
    alert("设置成功");
  },
  handle: function(){
    alert("按钮被点击");
  }
});
```

包含一组共4个方法。

方法名 | 说明
------+-------
setLLButton | 左上角第一个按钮
setLRButton | 左上角第二个按钮
setRLButton | 右上角第一个按钮
setRRButton | 右上角第二个按钮


文字按钮或者图片按钮。
icon属性定义了本地资源的名称。
支持的icon类型如下：

名称 | 说明
-----+------
H5_Search | 代表搜索的放大镜按钮
H5_Back | 代表返回的向左箭头
H5_Custom_Back | 向左箭头及“返回”文字
H5_Share | 代表分享的方框及箭头

<aside class="notice">
在iOS上，如果定义了RL按钮而没有定义RR按钮，RL按钮将不显示。
</aside>

## 提示对话框
<aside class="success">3.6.0+</aside>

弹出原生的提示对话框（类似于window.alert）。

```javascript
DPMer.alert({
    title: 'title', // 标题文字
    message: 'message', // 内容文字
    button: 'button', // 按钮文字
    success: function(){
        // 用户点击确认
    }
});
```

## 确认对话框
<aside class="success">3.6.0+</aside>

弹出原生的确认对话框（类似于window.confirm），允许用户确认或取消。

```javascript
DPMer.confirm({
    title: 'title', // 标题文字
    message: 'message', // 内容文字
    okButton: 'OK', // 确认按钮文字
    cancelButton: 'Cancel', // 取消按钮文字
    success: function(e) {
        // 用户点击确认或取消
        if (e.ret) {} // true: 确认 false: 取消
    }
});
```

## 输入对话框
<aside class="success">3.6.0+</aside>

弹出原生的输入对话框（类似于window.prompt），允许用户输入一段文字，确认或取消。

```javascript
DPMer.prompt({
    title: 'title', // 标题文字
    message: 'message', // 内容文字
    placeholder: 'placeholder', // 输入框默认文字
    okButton: 'btnconfirm', // 确认按钮文字，可选，默认值『确定』
    cancelButton: 'btncancel', // 取消按钮文字，可选，默认值『取消』
    success: function(e) {
        // 用户点击确认或取消
        if (e.ret) {
            // true: 确认 false: 取消
            alert(e.text); // 用户输入的文字
        }
    }
});
```

## 浮层提示(toast)
<aside class="success">3.6.0+</aside>

弹出一段简短的信息，一定时间后消失。

```javascript
DPMer.toast({
    title: 'title', // 文字
    timeout: 2000 // 持续时间
});
```

<aside class="notice">
安卓设备上toast显示持续时间受到系统限制，只有2秒和3.5秒两个选项。调用本接口时，如果`timeout`大于2000，则按3.5秒展示；否则按2秒展示。
</aside>

## 操作列表
<aside class="success">3.7.0+</aside>
<aside class="warning">该功能尚未上线</aside>

弹出一个有多个按钮的列表。

```javascript
DPMer.actionSheet({
    title: '',
    selections: ['分享图片', '删除图片'], // 按钮文案列表
    cancelButton: '取消', // 取消按钮的文案，默认为“取消”
    success: function(res) {
        alert(res.selectedIndex); // 用户点选的按钮
    }
});
```

## 扫描二维码
<aside class="success">3.7.0+</aside>
<aside class="warning">该功能尚未上线</aside>

调用App的扫描二维码功能，并返回结果。

```javascript
DPMer.scanQRCode({
    success: function(res) {
        alert(res.value); // 扫描结果
    }
});
```

<aside class="info">
用户主动关闭扫描界面时，并不会触发dpmerchant的回调。
</aside>
