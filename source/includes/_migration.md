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

    判断版本，在3.6.0及以上版本使用`uploadImage`代替
  
* `setTopRightProgress`

    新版本不支持，需改用其他交互方式