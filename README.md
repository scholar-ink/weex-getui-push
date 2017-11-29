# getui-push
getui-push是一个weex插件，可以通过weexpack快速集成，可以丰富weex功能

支持的WeexSDK版本： >= 0.16.0

# 功能

# 快速使用
- 通过weexpack初始化一个测试工程 weextest
   ```
   weex create weextest
   ```
- 添加ios平台
  ```
  weex platform add ios
  ```
- 添加android平台
  ```
  weex platform add android
  ```
- 添加插件
  ```
  weex plugin add getui-push
  ```
  
## API
### `initPush(options)`

初始化个推SDK

#### 参数

- `options {Object}`：初始化个推时设置的参数
    - `appId {string}`：appId
    - `appKey {string}`：appKey
    - `appSecret {string}`：appSecret
    
### `onRegisterClient(options)`

获取clientId

#### 参数

- `callback {function (clientId)}`：获取到clientId的回调函数。
  - `clientId {string}`：sdk登入成功后返回clientId

### `onReceivePayloadData(payloadData)`
SDK接收个推推送的透传消息

#### 参数

- `callback {function (payloadData)}`：获取到clientId的回调函数。
  - `payloadData {json Object}`：接收到的透传数据。

### android需要在打包配置个推应用参数
	
	在app/build.gradle文件中的android.defaultConfig下添加manifestPlaceholders，配置个推相关的应用参数
	
		android {
		  ...
		  defaultConfig {
		    ...
		    manifestPlaceholders = [
			    GETUI_APP_ID : "APP_ID",
			    GETUI_APP_KEY : "APP_KEY",
			    GETUI_APP_SECRET : "APP_SECRET"
			]
		  }
		}

# 项目地址
[github](https://github.com/scholar-ink/weex-plugin-getui-push)

# 已有工程集成
## iOS集成插件GetuiPush
- 命令行集成
  ```
  weex plugin add getui-push
  ```
- 手动集成
  在podfile 中添加
  ```
  pod 'GetuiPush'
  ```

## 安卓集成插件getuipush
- 命令行集成
  ```
  weexpack plugin add getui-push
  ```
- 手动集成
  在相应工程的build.gradle文件的dependencies中添加
  ```
  compile '${groupId}:getuipush:{$version}'
  ``` 
  注意：您需要自行指定插件的groupId和version并将构建产物发布到相应的依赖管理仓库内去（例如maven）, 您也可以对插件的name进行自定义，默认将使用插件工程的名称作为name
