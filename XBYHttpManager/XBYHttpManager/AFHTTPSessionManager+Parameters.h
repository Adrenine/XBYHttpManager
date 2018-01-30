//
//  AFHTTPSessionManager+Parameters.h
//  JuYouQu
//
//  Created by Normal on 16/1/6.
//  Copyright © 2016年 Bo Wang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 *  AFNetWorking 请求成功回调
 *
 *  @param task      DDTASK
 *  @param object 响应消息体
 */
typedef void(^AFRequestSuccess)(NSURLSessionDataTask *task, id object);

/**
 *  AFNetWorking 请求失败回调
 *
 *  @param task DDTASK
 *  @param error     失败信息
 */
typedef void(^AFRequestFailure)(NSURLSessionDataTask *task, NSError *error);


@interface AFHTTPSessionManager (Parameters)
/**
 *  二次封装 GET 请求
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param success    请求成功时的回调 @see AFRequestSuccess
 *  @param failure    请求失败时的回调 @see AFRequestFailure
 *  @param enabled    是否加入额外参数 @see - (NSDictionary *)presetParameters;
 *
 *  @return DDTASK
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:( NSDictionary *)parameters
                      success:( AFRequestSuccess)success
                      failure:( AFRequestFailure)failure
       presetParameterEnabled:(BOOL)enabled;

/**
 *  二次封装 POST 请求
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param success    请求成功时的回调 @see AFRequestSuccess
 *  @param failure    请求失败时的回调 @see AFRequestFailure
 *  @param enabled    是否加入额外参数 @see - (NSDictionary *)presetParameters;
 *
 *  @return DDTASK
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:( NSDictionary *)parameters
                       success:( AFRequestSuccess)success
                       failure:( AFRequestFailure)failure
        presetParameterEnabled:(BOOL)enabled;

/**
 *  二次封装 POST 请求. 携带二进制data
 *
 *  @param URLString  URL
 *  @param parameters 普通参数
 *  @param body       二进制参数
 *  @param success    请求成功时的回调 @see AFRequestSuccess
 *  @param failure    请求失败时的回调 @see AFRequestFailure
 *  @param enabled    是否加入额外参数 @see - (NSDictionary *)presetParameters;
 *
 *  @return DDTASK
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:( NSDictionary *)parameters
                      bodyData:( NSDictionary *)body
                       success:( AFRequestSuccess)success
                       failure:( AFRequestFailure)failure
        presetParameterEnabled:(BOOL)enabled;

/**
 *  附带的额外参数，包括设备信息、网络信息、登录用户信息
 *
 *  @return 已封装的参数
 */
- (NSDictionary *)presetParameters;

/**
 *
 *  @brief 为task的POST请求添加上传进度回调
 *
 *  @param progress
 *  @param task
 */
- (void)setUploadProgressBlock:(void (^)(NSProgress *))progress forTask:(NSURLSessionTask *)task;

/**
 *
 *  @brief 为task GET请求添加下载进度回调
 *
 *  @param progress
 *  @param task
 */
- (void)setDownloadProgressBlock:(void (^)(NSProgress *))progress forTask:(NSURLSessionTask *)task;

@end

@interface NSObject (Helper)
- (BOOL)task_isRunning;
- (BOOL)task_isCanceled;
- (BOOL)task_isFinished;
@end


