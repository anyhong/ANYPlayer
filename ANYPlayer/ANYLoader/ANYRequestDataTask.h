//
//  ANYRequestDataTask.h
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/26.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef void(^ResponseHandler)(NSURLResponse *response, NSUInteger contentLength);
typedef void(^ReceivedHandler)(NSData *data);
typedef void(^CompleteHandler)(NSError *error);


@interface ANYRequestDataTask : NSObject

- (instancetype)initWithURL:(NSURL *)URL
             loadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) NSURL *requestURL;
@property (nonatomic, strong, readonly) AVAssetResourceLoadingRequest *loadingRequest;
@property (nonatomic, assign, readonly) NSUInteger requestOffset;
@property (nonatomic, assign, readonly) NSUInteger requestLength;

@property (nonatomic, assign) NSUInteger currentOffset; ///< 当前下载偏移量
@property (nonatomic, assign) NSUInteger cachingOffset; ///< 当前缓存偏移量
@property (nonatomic, assign) NSUInteger respondOffset; ///< 当前填充偏移量


- (void)taskDidReceiveResponse:(ResponseHandler)responseHandler
                didReceiveData:(ReceivedHandler)receivedHandler
          didCompleteWithError:(CompleteHandler)completeHandler;

- (void)start;
- (void)cancle;
@end
