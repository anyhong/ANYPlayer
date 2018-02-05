//
//  ANYRequestDataTask.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/26.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYRequestDataTask.h"
#import "NSURL+ANYAdd.h"

@interface ANYRequestDataTask () <NSURLSessionTaskDelegate>
@property (nonatomic, strong, readwrite) NSURL *requestURL;
@property (nonatomic, assign, readwrite) NSUInteger requestOffset;
@property (nonatomic, assign, readwrite) NSUInteger requestLength;
@property (nonatomic, strong, readwrite) AVAssetResourceLoadingRequest *loadingRequest;

@property (nonatomic, assign) BOOL taskCancled;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, copy) ResponseHandler responseHandler;
@property (nonatomic, copy) ReceivedHandler receivedHandler;
@property (nonatomic, copy) CompleteHandler completeHandler;
@end

@implementation ANYRequestDataTask

- (instancetype)initWithURL:(NSURL *)URL loadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    self = [super init];
    if (self) {
        self.requestURL = URL;
        self.loadingRequest = loadingRequest;
        self.requestOffset = loadingRequest.dataRequest.requestedOffset;
        self.requestLength = loadingRequest.dataRequest.requestedLength;
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (void)taskDidReceiveResponse:(ResponseHandler)responseHandler
                didReceiveData:(ReceivedHandler)receivedHandler
          didCompleteWithError:(CompleteHandler)completeHandler {
    self.responseHandler = responseHandler;
    self.receivedHandler = receivedHandler;
    self.completeHandler = completeHandler;
}

- (void)start {
    NSMutableURLRequest *mRequest =
    [NSMutableURLRequest requestWithURL:[self.requestURL any_originalSchemeURL]
                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                        timeoutInterval:20];
    
    if (self.requestOffset > 0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%ld-", self.requestOffset];
        [mRequest addValue:range forHTTPHeaderField:@"Range"];
    }
    
    self.currentOffset = self.requestOffset;
    self.cachingOffset = self.requestOffset;
    self.respondOffset = self.requestOffset;
    
    self.dataTask = [self.session dataTaskWithRequest:mRequest];
    [self.dataTask resume];
}

- (void)cancle {
    self.taskCancled = YES;
    [self.dataTask cancel];
    [self.session invalidateAndCancel];
}


#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(nonnull NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response
 completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    completionHandler(NSURLSessionResponseAllow);
    
    NSUInteger contentLength = ({
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *allHeaderFields = httpResponse.allHeaderFields;
        NSString *contentRange = [allHeaderFields objectForKey:@"Content-Range"];
        NSArray *arrContent = [contentRange componentsSeparatedByString:@"/"];
        NSString *content = arrContent.lastObject;
        NSUInteger contentLength = content.integerValue > 0 ?
        content.integerValue : response.expectedContentLength;
        contentLength;
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.responseHandler)
            self.responseHandler(response, contentLength);
    });
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(nonnull NSURLSessionDataTask *)dataTask
    didReceiveData:(nonnull NSData *)data {
    
    if (self.taskCancled /* 任务取消了 */ ||
        self.currentOffset >= self.respondOffset + self.requestLength /* 数据越界了 */) {
        return;
    }
    
    self.currentOffset += data.length;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.receivedHandler)
            self.receivedHandler(data);
    });
    
    
    
    /* 这里可以做一个数据保护, 会增加一点开销
    @autoreleasepool {
        NSUInteger queuingLength =
        self.requestOffset + self.requestLength - self.respondOffset;
        NSUInteger availableLength = MIN(queuingLength, data.length);
        NSData *availableData = [data subdataWithRange:NSMakeRange(0, availableLength)];
        self.currentOffset += availableData.length;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.receivedHandler)
                self.receivedHandler(availableData.length);
        });
    }
     */
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completeHandler)
            self.completeHandler(error);
    });
}
@end
