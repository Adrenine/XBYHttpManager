//
//  AFHTTPSessionManager+Parameters.m
//  JuYouQu
//
//  Created by Normal on 16/1/6.
//  Copyright © 2016年 Bo Wang. All rights reserved.
//

#import "AFHTTPSessionManager+Parameters.h"

@implementation AFHTTPSessionManager (Parameters)
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:( NSDictionary *)parameters
                      success:( AFRequestSuccess)success
                      failure:( AFRequestFailure)failure
       presetParameterEnabled:(BOOL)enabled
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (enabled) {
        [dict addEntriesFromDictionary:[self presetParameters]];
    }
    
    NSURLSessionDataTask *task = [self GET:URLString parameters:dict progress:nil success:success failure:failure];
    NSLog(@"GET:%@",task.currentRequest.URL.absoluteString);
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:( NSDictionary *)parameters
                       success:( AFRequestSuccess)success
                       failure:( AFRequestFailure)failure
        presetParameterEnabled:(BOOL)enabled
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (enabled) {
        [dict addEntriesFromDictionary:[self presetParameters]];
    }
    
    NSURLSessionDataTask *task = [self POST:URLString parameters:dict progress:nil success:success failure:failure];
    NSLog(@"POST:%@",task.currentRequest.URL.absoluteString);
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:( NSDictionary *)parameters
                      bodyData:( NSDictionary *)body
                       success:( AFRequestSuccess)success
                       failure:( AFRequestFailure)failure
        presetParameterEnabled:(BOOL)enabled
{
    if (body) {
        self.requestSerializer.timeoutInterval = 120.f;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
        if (enabled) {
            [dict addEntriesFromDictionary:[self presetParameters]];
        }
        
        NSURLSessionDataTask *task = [self POST:URLString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSString *key in body) {
//                [formData appendPartWithFormData:body[key] name:key];
                [formData appendPartWithFileData:body[key] name:key fileName:key mimeType:@"image/jpeg"];
            }
        } progress:nil success:success failure:failure];
        NSLog(@"POSTDATA:%@",task.currentRequest.URL.absoluteString);
        return task;
    }else{
        return [self POST:URLString parameters:parameters success:success failure:failure presetParameterEnabled:enabled];
    }
}

- (NSDictionary *)presetParameters
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    NSString *accessToken = [User me].accessToken;
//    
//    [dict setValue:accessToken forKey:@"accessToken"];
//    
//    NSString *deviceInfo = [Config device];
//    if (deviceInfo) {
//        [dict setObject:deviceInfo forKey:@"device"];
//    }
//    [dict setObject:[Config platform] forKey:@"platform"];
//    [dict setObject:[Config appVersion] forKey:@"appVersion"];
//    [dict setObject:[Config systemVersion] forKey:@"systemVersion"];
//    [dict setObject:[Config channel] forKey:@"channel"];
//    [dict setObject:[Config preferredLang] forKey:@"lang"];
//    if (self.reachabilityManager.reachableViaWWAN) {
//        [dict setObject:@"Cellular" forKey:@"network"];
//    } else if (self.reachabilityManager.reachableViaWiFi) {
//        [dict setObject:@"WiFi" forKey:@"network"];
//    }
    return dict;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (id)taskDelegate:(NSURLSessionTask *)task
{
    // AFURLSessionManager.m line 592.
    // - (AFURLSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task;
    SEL delegateForTask = @selector(delegateForTask:);
    if ([self respondsToSelector:delegateForTask]){
        id delegate = [self performSelector:delegateForTask withObject:task];
        return delegate;
    }
    return nil;
}

- (void)setUploadProgressBlock:(void (^)(NSProgress *))progress forTask:(NSURLSessionTask *)task
{
    id delegate = [self taskDelegate:task];
    
    // AFURLSessionManager.m line 123.
    // @property (nonatomic, copy) AFURLSessionTaskProgressBlock uploadProgressBlock;
    SEL progressSetter = @selector(setUploadProgressBlock:);
    if ([delegate respondsToSelector:progressSetter]) {
        [delegate performSelector:progressSetter withObject:progress];
    }
}

- (void)setDownloadProgressBlock:(void (^)(NSProgress *))progress forTask:(NSURLSessionTask *)task
{
    id delegate = [self taskDelegate:task];
    
    // AFURLSessionManager.m line 123.
    // @property (nonatomic, copy) AFURLSessionTaskProgressBlock downloadProgressBlock;
    SEL progressSetter = @selector(setDownloadProgressBlock:);
    if ([delegate respondsToSelector:progressSetter]) {
        [delegate performSelector:progressSetter withObject:progress];
    }
}
#pragma clang diagnostic pop

@end

@implementation NSObject (Helper)

- (BOOL)isNSURLSesstionTask
{
    return [self isKindOfClass:[NSURLSessionTask class]];
}

- (BOOL)task_isRunning
{
    if ([self isNSURLSesstionTask]) {
        NSURLSessionTask *task = (NSURLSessionTask *)self;
        return task.state == NSURLSessionTaskStateRunning;
    }
    return NO;
}

- (BOOL)task_isCanceled
{
    if ([self isNSURLSesstionTask]) {
        NSURLSessionTask *task = (NSURLSessionTask *)self;
        return task.state == NSURLSessionTaskStateCanceling;
    }
    return NO;
}

- (BOOL)task_isFinished
{
    if ([self isNSURLSesstionTask]) {
        NSURLSessionTask *task = (NSURLSessionTask *)self;
        return task.state == NSURLSessionTaskStateCompleted;
    }
    return NO;
}

@end