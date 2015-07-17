# Efte.js迁移指南

dpmerchant和点评管家内置了对现有功能的支持，对于原使用efte.js的业务，要求在3.6版本期间迁移到dpmerchant。建议迁移方式如下：

| efte.js接口           | 对应dpapp接口                      | 需要分版本调用不同代码 | 说明                                                                                                 | 
|---------------------|--------------------------------|-------------|----------------------------------------------------------------------------------------------------| 
| action.back         | closeWindow                    | 否           | 直接替换                                                                                               | 
| action.dismiss      | closeWindow                    | 否           | 直接替换；页面不能以modal模式打开                                                                                | 
| action.open         | 无                              | 否           | 后续版本不再支持静态包，此方法不再有效                                                                                | 
| action.openUrl      | openScheme                     | 否           | 使用openScheme({url: “dpmer://web”, extra: { url: “http://example.com/some/path” }})使用webview打开对应url | 
| action.reloadPage   | 无                              | 否           | 使用location.reload()代替                                                                              | 
| actionRedirect      | 无                              | 否           | 使用openScheme代替                                                                                     | 
| ajax                | ajax                           | 否           | 直接替换                                                                                             | 
| editPhoto           | editPhoto                      | 否           | 直接替换                                                                                               | 
| gaLog               | 无                              | 否           | 使用hippo打点代替                                                                                        | 
| getEnv              | getUA, getUserInfo, getVersion | 否           | 视情况替换                                                                                              | 
| publish             | publish                        | 否           | 直接替换                                                                                               | 
| setTitle            | setTitle                       | 否           | 直接替换                                                                                               | 
| setTopRightButton   | setRRButton                    | 是           |                                                                                                    | 
| setTopRightProgress | setRRButton                    | 是           |                                                                                                    | 
| setrightbaritem     | setRRButton                    | 是           |                                                                                                    | 
| shareTo             | share                          | 否           | 直接替换                                                                                               | 
| showPhoto           | showPhoto                      | 否           | 直接替换                                                                                               | 
| subscribe           | subscribe                      | 否           | 直接替换                                                                                               | 
| takePhoto           | uploadImage                    | 是           | 需要修改业务上传逻辑                                                                                         | 
| takePhotoByName     | uploadImage                    | 是           | 需要修改业务上传逻辑                                                                                         | 
