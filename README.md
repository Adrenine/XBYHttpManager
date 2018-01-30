# XBYHttpManager
基于AFNetworking再封装的一个轻量级网络请求框架

## Requirements 要求
* iOS 8+
* Xcode 8+

## Installation 安装
### 手动安装:
下载DEMO后，将子文件夹XBYHttpManager拖入到项目中, 导入头文件XBYHttpManager.h开始使用, 注意: 项目中需要有AFNetworking 3.x等第三方库，若要运行，请先切换到工程根目录，运行pod install命令，若不知道使用Cocoapods，请参考[iOS开发之CocoaPods](https://www.jianshu.com/p/1183466aeb28)。</br>
**注意：使用前需要手动进行一些设置：**
* 1、网络超时设置，在XBYHttpManager.h中设置宏TimeoutInterval；
* 2、是否需要设置网络返回成功code，一般网络请求成功code为200，若不需要设置，可以跳过这个，若需要设置网络请求成功code，需要先在XBYHttpManager.m中设置宏NEEDRESULTCODE为YES同时设置宏RESULTCODE为自己服务器返回成功的code，同时参照`BOOL judgeResultState(id responseObject,BOOL showError)`方法中的#warning进行修改设置；
* 3、设置服务器域名，在XBYHttpManager.m中将宏设置DOMAINURI为自家服务器域名。

## Usage 使用方法
`fullHttpUrl()`方法用于拼接域名与uri，例如链接为：www.baidu.com/news，需要在XBYHttpManager.m中设置`DOMAINURI=@"www.baidu.com"`设置自家服务器域名，只需要拼接链接：`fullHttpUrl(@"/news")`，此时`fullHttpUrl(@"/news") = @"www.baidu.com/news"`，或者直接在此处写完整链接，不使用`fullHttpUrl()`拼接，param设置参数。
```objc
//GET方法
XBYGET(fullHttpUrl(<#uri#>), <#param#>, ^(NSURLSessionDataTask *task, id responseObject, BOOL suc) {
if (suc) {
//返回成功
} else {
//服务器返回失败
}
}, ^(NSURLSessionDataTask *task, NSError *error) {
//网络问题造成的失败
});

//POST方法
XBYPOST(fullHttpUrl(<#uri#>), <#param#>, ^(NSURLSessionDataTask *task, id responseObject, BOOL suc) {

}, ^(NSURLSessionDataTask *task, NSError *error) {

});
```
## 其他
见下面头文件描述：

```objc
/**
服务器有响应时的回调

@param task <#task description#>
@param responseObject 响应体
@param suc 是否成功，由于在下一层AF的success回调会被截取，当响应体里result字段不为0时，suc为NO，result为0时，suc为YES
*/
typedef void(^XBYRequestSuccess)(XBYTASK *task,id responseObject,BOOL suc);

/**
服务器访问失败时的回调

@param task <#task description#>
@param error AF生成的error
*/
typedef void(^XBYRequestFailure)(XBYTASK *task,NSError *error);

//域名与地址uri拼接方法，域名在上面宏DOMAINURI设置一次即可，后面跟随uri最好用一个文件单独存放，用时拼接即可
NSString *fullHttpUrl(NSString *uri);

/**
POST方法

@param url <#url description#>
@param param <#param description#>
@param success <#success description#>
@param failure <#failure description#>
@return <#return value description#>
*/
XBYTASK *
XBYPOST(NSString *url,
id param,
XBYRequestSuccess success,
XBYRequestFailure failure);

/**
后台运行

@param url <#url description#>
@param param <#param description#>
@param success <#success description#>
@param failure <#failure description#>
@param showError <#showError description#>
@return <#return value description#>
*/
XBYTASK *
XBYPOSTBACKGROUND(NSString *url,
id param,
XBYRequestSuccess success,
XBYRequestFailure failure, BOOL showError);

/**
<#Description#>

@param url <#url description#>
@param param <#param description#>
@param bodyData <#bodyData description#>
@param success <#success description#>
@param failure <#failure description#>
@return <#return value description#>
*/
XBYTASK *
XBYPOSTDATA(NSString *url,
id param,
NSDictionary * bodyData,
XBYRequestSuccess success,
XBYRequestFailure failure);

/**
GET方法

@param url <#url description#>
@param param <#param description#>
@param success <#success description#>
@param failure <#failure description#>
@return <#return value description#>
*/
XBYTASK *
XBYGET(NSString *url,
id param,
XBYRequestSuccess success,
XBYRequestFailure failure);

@interface XBYHttpManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

//网络状况
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

+ (instancetype)sharedClient;

//向请求头中添加参数
+ (void)addCustomParamsofRequestHeader:(NSDictionary * )dic;

```

## 联系方式
* [掘金 - Adrenine](https://juejin.im/user/57c39bfb79bc440063e5ad44)
* [简书 - Adrenine](https://www.jianshu.com/u/b20be2dcb0c3)
* [Blog - Adrenine](https://adrenine.github.io/)

## 许可证
XBYTableView 使用 MIT 许可证，详情见 LICENSE 文件。

