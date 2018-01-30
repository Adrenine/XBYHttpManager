//
//  XBYHttpManager.h
//  TransportPlatform
//
//  Created by xiebangyao on 16/5/13.
//  Copyright © 2016年 xby. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#ifdef DEBUG
#define TimeoutInterval 180
#define XBYLog(FORMAT, ...) fprintf(stderr,"文件%s:第%d行输出\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define TimeoutInterval 30
#define XBYLog(FORMAT, ...) nil;
#endif

#define XBYREQUEST [XBYHttpManager sharedClient]
#define XBYTASK NSURLSessionDataTask

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

@end

