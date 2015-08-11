# Efte.js迁移指南

dpmerchant和点评管家内置了对现有功能的支持，对于原使用efte.js的业务，要求在3.6版本期间迁移到dpmerchant。

## 能够直接迁移的方法

| efte.js方法          | 对应dpmerchant方法              | 说明                                                                                                 | 
|---------------------|--------------------------------|----------------------------------------------------------------------------------------------------| 
| action.back         | closeWindow                    | 直接替换                                                                                               | 
| action.dismiss      | closeWindow                    | 直接替换；页面不能以modal模式打开                                                                                | 
| action.open         | 无                              | 后续版本不再支持静态包，此方法不再有效                                                                                | 
| action.openUrl      | openScheme                     | 使用openScheme({url: “dpmer://web”, extra: { url: “http://example.com/some/path” }})使用webview打开对应url | 
| action.reloadPage   | 无                              | 使用location.reload()代替                                                                              | 
| actionRedirect      | 无                              | 使用openScheme代替                                                                                     | 
| ajax                | 无                           | 使用js发送（需要跨域的场合需添加CORS头部）                                                                                             | 
| publish             | weakPublish                    | 直接替换                                                                                             | 
| subscribe           | weakSubscribe                  | 直接替换                                                                                             | 
| editPhoto           | editPhoto                      | 直接替换                                                                                               | 
| gaLog               | 无                              | 使用hippo打点代替                                                                                        | 
| getEnv              | getUA, getUserInfo, getVersion | 视情况替换                                                                                              | 
| setTitle            | setTitle                       | 直接替换                                                                                               | 
| setTopRightButton   | setRRButton                    | 直接替换                                                                                            | 
| setrightbaritem     | setRRButton                    | 直接替换                                                                                            | 
| shareTo             | share                          | 直接替换                                                                                               | 
| showPhoto           | showPhoto                      | 直接替换                                                                                               |

## 需要修改业务逻辑的方法

* `takePhoto` `takePhotoByName`

    判断版本，在3.6.0及以上版本使用`uploadImage`代替，如果要兼容efte和dpmerchant，需要写两套业务代码。
    
```javascript
if (ua.appVersion === 'efte_1.0') {
	var Efte = DPMer._efte;	
	// Efte.takePhoto({});
} else {
	// use DPMer.uploadImage({});
}
```
  
* `setTopRightProgress`

    新版本不支持，需改用其他交互方式。

## 关于点评管家web scheme

点评管家`3.6.0`版本新增了scheme：`dpmer://newweb`。这个scheme主要用于从efte到dpmerchant的过渡阶段。过渡阶段的版本内，`dpmer://newweb`对应支持dpmerchant的webview，`dpmer://web`对应支持efte的webview。

对于前端项目，业务在js中使用`openScheme`或`jumpToScheme`时，`dpmer://web`的scheme会被自动替换为`dpmer://newweb`。

如果需要强制打开efte webview，则需要添加一个额外参数。如代码所示。

```javascript
DPMer.openScheme({
	url: 'dpmer://web',
	extra: { url: 'http://m.dianping.com' },
	useEfteWeb: true // 传true表示使用efte webview打开
});
```

<aside class="warning">
未来移除efte后的点评管家中，`dpmer://web`将指向新的webview。因此为了将来版本能够无缝升级，业务不应在代码里直接使用`dpmer://newweb`的scheme。
</aside>