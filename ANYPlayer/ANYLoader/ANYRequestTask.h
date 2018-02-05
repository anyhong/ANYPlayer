//
//  ANYRequestTask.h
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/23.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANYCacheHandle.h"
#import <AVFoundation/AVFoundation.h>

@class ANYRequestTask;
@protocol ANYRequestTaskDelegate <NSObject>

@optional
- (void)requestTask:(ANYRequestTask *)task didReceiveResponse:(NSURLResponse *)response;
- (void)requestTask:(ANYRequestTask *)task didCompleteWithError:(NSError *)error;
- (void)requestTask:(ANYRequestTask *)task didReceiveData:(NSData *)data;
@end





@interface ANYRequestTask : NSObject
- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, assign) id<ANYRequestTaskDelegate> delegate;
@property (nonatomic, strong, readonly) NSURL *requestURL;
@property (nonatomic, assign) NSUInteger contentLength;
@property (nonatomic, strong) ANYCacheHandle *cacheHandle;
- (void)startTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;
- (void)cancleTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;
- (void)cancle;
@end
