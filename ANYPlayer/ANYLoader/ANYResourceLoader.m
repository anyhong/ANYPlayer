//
//  ANYResourceLoader.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/22.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYResourceLoader.h"
#import "ANYRequestTask.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ANYResourceLoader ()<ANYRequestTaskDelegate>
@property (nonatomic, strong) ANYRequestTask *requestTask;
@property (nonatomic, strong) NSMutableArray<AVAssetResourceLoadingRequest *> *mArrRequest;
@end


@implementation ANYResourceLoader

#pragma mark - getter

- (NSMutableArray<AVAssetResourceLoadingRequest *> *)mArrRequest {
    if (!_mArrRequest) {
        _mArrRequest = [NSMutableArray array];
    }
    return _mArrRequest;
}


#pragma mark - life circle

- (void)dealloc {
    [self.mArrRequest removeAllObjects];
    self.requestTask.delegate = nil;
}


#pragma mark - tool

- (void)appendLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    if (!loadingRequest) return;
    [self.mArrRequest addObject:loadingRequest];
}

- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    if (!loadingRequest) return;
    [self.mArrRequest removeObject:loadingRequest];
}


#pragma mark - AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
    shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    if (!self.requestTask) {
        self.requestTask = [[ANYRequestTask alloc] initWithURL:loadingRequest.request.URL];
        self.requestTask.delegate = self;
    }
    
    [self appendLoadingRequest:loadingRequest];
    [self.requestTask startTaskWithLoadingRequest:loadingRequest];
    
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
    didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self removeLoadingRequest:loadingRequest];
    [self.requestTask cancleTaskWithLoadingRequest:loadingRequest];
}
@end
