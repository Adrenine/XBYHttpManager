//
//  XBYHttpManager.m
//  TransportPlatform
//
//  Created by xiebangyao on 16/5/13.
//  Copyright © 2016年 xby. All rights reserved.
//

#import "XBYHttpManager.h"
#import "AFHTTPSessionManager+Parameters.h"

//结果集成功代码，根据服务器返回成功码来设置
#define NEEDRESULTCODE NO   //当为YES时，下面这个宏必须优质
#define RESULTCODE @"200"
//设置域名
#define DOMAINURI @"https://api-m.mtime.cn/PageSubArea/HotPlayMovies.api?locationId=290"

/**
 判定返回结果集与设定是否匹配来判定返回结果成功还是失败

 @param responseObject <#responseObject description#>
 @param showError <#showError description#>
 @return <#return value description#>
 */
BOOL
judgeResultState(id responseObject,BOOL showError){
    BOOL success = NO;
    if (!NEEDRESULTCODE) {  //如果不需要设置返回成功代码
        return YES;
    } else {
        if (RESULTCODE.length<1) {
            NSException *e = [NSException exceptionWithName:@"成功code未设置"
                                                     reason:@"服务器返回成功的code未设置"
                                                   userInfo:nil];
            @throw e;
        }
    }
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
#warning 结果集成功代码要根据自家服务器设定来，下面state若不为state，需要根据服务器返回来获得
        NSString *state = responseObject[@"state"];
        if ([state isEqualToString:RESULTCODE]) {
            success = YES;
        } else if (showError){
            NSString *stateDescribe = [responseObject objectForKey:@"stateDescribe"];
            if (!stateDescribe.length) {
                stateDescribe = [responseObject objectForKey:@"describe"];
            }
            if ([stateDescribe isKindOfClass:[NSString class]] && stateDescribe.length) {
                XBYLog(@"%@",stateDescribe);
            }
        }
    }
    return success;
}

/**
 获取错误信息，在查询网络状态中有使用
 
 @param error <#error description#>
 @param title <#title description#>
 @param message <#message description#>
 @return <#return value description#>
 */
static NSString * AFGetAlertViewTitleAndMessageFromError(NSError *error, NSString * __autoreleasing *title, NSString * __autoreleasing *message) {
    if (error.localizedDescription && (error.localizedRecoverySuggestion || error.localizedFailureReason)) {
        *title = error.localizedDescription;
        
        if (error.localizedRecoverySuggestion) {
            *message = error.localizedRecoverySuggestion;
        } else {
            *message = error.localizedFailureReason;
        }
        return *title;
    } else if (error.localizedDescription) {
        *title = NSLocalizedStringFromTable(@"Error", @"AFNetworking", @"Fallback Error Description");
        *message = error.localizedDescription;
        return *message;
    } else {
        *title = NSLocalizedStringFromTable(@"Error", @"AFNetworking", @"Fallback Error Description");
        *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ Error: %ld", @"AFNetworking", @"Fallback Error Failure Reason Format"), error.domain, (long)error.code];
        return *message;
    }
}

/**
 查看网络状态
 
 @param error <#error description#>
 */
void
checkNetWorkAvailable(NSError *error) {
    if (!(XBYREQUEST.reachabilityManager.reachable)) {
        XBYLog(@"网络异常，请检查您的网络");
    } else {
        NSInteger code = error.code;
        NSString *title,*message;
        switch (code) {
            case 404:   //根据自己服务器配置自行设置
                message = @"Not Found";
                break;
            default:
                message = AFGetAlertViewTitleAndMessageFromError(error, &title, &message);
                break;
        }
        XBYLog(@"网络错误：%@",message);
    }
}

NSString *fullHttpUrl(NSString *uri) {
    if (DOMAINURI.length<1) {
        NSException *e = [NSException exceptionWithName:@"网络请求域名为空"
                                                 reason:@"域名宏定义DOMAINURI未设置"
                                               userInfo:nil];
        @throw e;
    }
    
    return [DOMAINURI stringByAppendingPathComponent:uri];
}

XBYTASK *
XBYPOST(NSString *url,
        id param,
        XBYRequestSuccess success,
        XBYRequestFailure failure){
    return XBYPOSTBACKGROUND(url, param, success, failure, YES);
}

//不会提示错误信息
XBYTASK *
XBYPOSTBACKGROUND(NSString *url,
                  id param,
                  XBYRequestSuccess success,
                  XBYRequestFailure failure, BOOL showError){
    XBYLog(@"log:URL:%@\n 入参:%@",url,param);
    return [XBYREQUEST.manager POST:url parameters:param success:^(XBYTASK *task, id responseObject) {
        XBYLog(@"出参:\n%@",responseObject);
        
        if ([task task_isCanceled]) return;
        success?success(task,responseObject,judgeResultState(responseObject,showError)):1;
    } failure:^(XBYTASK *task, NSError *error) {
        if ([task task_isCanceled]) return;
        if (showError) {
            checkNetWorkAvailable(error);
        }
        failure?failure(task,error):1;
    } presetParameterEnabled:YES];
}

XBYTASK *
XBYPOSTDATA(NSString *url,
            id param,
            NSDictionary * bodyData,
            XBYRequestSuccess success,
            XBYRequestFailure failure){
    XBYLog(@"log:URL:%@\n 入参:%@",url,param);
    return [XBYREQUEST.manager POST:url parameters:param bodyData:bodyData success:^(XBYTASK *task, id responseObject) {
        if ([task task_isCanceled]) return;
        success?success(task,responseObject,judgeResultState(responseObject,YES)):1;
    } failure:^(XBYTASK *task, NSError *error) {
        if ([task task_isCanceled]) return;
        checkNetWorkAvailable(error);
        failure?failure(task,error):1;
    } presetParameterEnabled:YES];
}

XBYTASK *
XBYGET(NSString *url,
       id param,
       XBYRequestSuccess success,
       XBYRequestFailure failure){
    return [XBYREQUEST.manager GET:url parameters:param success:^(XBYTASK *task, id responseObject) {
        if ([task task_isCanceled]) return;
        success?success(task,responseObject,judgeResultState(responseObject,YES)):1;
    } failure:^(XBYTASK *task, NSError *error) {
        if ([task task_isCanceled]) return;
        checkNetWorkAvailable(error);
        failure?failure(task,error):1;
    } presetParameterEnabled:YES];
}


@implementation XBYHttpManager

+ (instancetype)sharedClient {
    static XBYHttpManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XBYHttpManager alloc]init];
        //        _sharedClient.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:XBYHttpsBaseUrl]];
        _sharedClient.manager = [[AFHTTPSessionManager alloc] init];
        
        //过滤NSNull
        ((AFJSONResponseSerializer *)_sharedClient.manager.responseSerializer).removesKeysWithNullValues = YES;
        
        _sharedClient.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.manager.securityPolicy.allowInvalidCertificates = YES;
        _sharedClient.manager.securityPolicy.validatesDomainName = NO;
        _sharedClient.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        _sharedClient.manager.requestSerializer.timeoutInterval = TimeoutInterval;
        
        [_sharedClient.manager.requestSerializer setValue:@"artemisToken_isvalid" forHTTPHeaderField:@"artemisToken"];
        //        [_sharedClient.manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        _sharedClient.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", @"multipart/form-data", @"application/x-www-form-urlencoded",nil];
        //过滤NSNull
        //        ((AFJSONResponseSerializer *)_sharedClient.manager.responseSerializer).removesKeysWithNullValues = YES;
        //        _sharedClient.manager.responseSerializer.acceptableStatusCodes
        
        _sharedClient.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:DOMAINURI];
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"network did change to %@",AFStringFromNetworkReachabilityStatus(status));
            NSLog(@"%d",_sharedClient.reachabilityManager.reachable);
        }];
        [_sharedClient.reachabilityManager startMonitoring];
        
    });
    return _sharedClient;
}

+ (void)addCustomParamsofRequestHeader:(NSDictionary *)dic{
    NSArray *keys  =[dic allKeys];
    if (keys.count<1) {
        XBYLog(@"参数为空");
        return;
    }
    
    for (NSString * key in keys) {
        [[XBYHttpManager sharedClient].manager.requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
    
}

@end


