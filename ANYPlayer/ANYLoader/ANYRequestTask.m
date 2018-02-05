//
//  ANYRequestTask.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/23.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYRequestTask.h"
#import "NSURL+ANYAdd.h"
#import "ANYCacheHandle.h"
#import "ANYRequestDataTask.h"
#import <MobileCoreServices/MobileCoreServices.h>



typedef struct _ANYRange {
    NSUInteger startOffset;
    NSUInteger endOffset;
    NSUInteger length;
} ANYRange;


NS_INLINE ANYRange ANYMakeRange(NSUInteger startOffset, NSUInteger endOffset) {
    ANYRange range;
    range.startOffset = startOffset;
    range.endOffset = endOffset;
    range.length = endOffset - startOffset;
    return range;
}

NS_INLINE ANYRange ANYRangeFromTask(ANYRequestDataTask *dataTask) {
    return ANYMakeRange(dataTask.requestOffset, dataTask.currentOffset);
}

NS_INLINE BOOL ANYIntersectionRange(ANYRange range1, ANYRange range2) {
    if (range2.startOffset > range1.endOffset || range2.startOffset > range1.endOffset) {
        return NO;
    }
    return YES;
}






@interface ANYRequestTask () <NSURLSessionTaskDelegate>
@property (nonatomic, strong, readwrite) NSURL *requestURL;
@property (nonatomic, strong) NSMutableArray<ANYRequestDataTask *> *mArrDataTask;
@end


@implementation ANYRequestTask

#pragma mark - getter

- (NSMutableArray<ANYRequestDataTask *> *)mArrDataTask {
    if (!_mArrDataTask) {
        _mArrDataTask = [NSMutableArray array];
    }
    return _mArrDataTask;
}


#pragma mark - init

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        self.requestURL = URL;
    }
    return self;
}


#pragma mark - action

- (void)startTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    ANYRequestDataTask *dataTask = [[ANYRequestDataTask alloc] initWithURL:self.requestURL
                                                            loadingRequest:loadingRequest];
    [self.mArrDataTask addObject:dataTask];
    
    [dataTask taskDidReceiveResponse:^(NSURLResponse *response, NSUInteger contentLength) {
        self.contentLength = contentLength;
        
        [self fillContentInformationRequest:dataTask.loadingRequest.contentInformationRequest];
        
        if (!self.cacheHandle) {
            self.cacheHandle = [[ANYCacheHandle alloc] initWithFileLength:self.contentLength];
        }
    } didReceiveData:^(NSData *data) {
        if (dataTask.respondOffset >= dataTask.requestOffset + dataTask.requestLength /* 填充数据越界 */ ||
            dataTask.loadingRequest.isFinished /* 请求完成了 */ ||
            dataTask.loadingRequest.isCancelled /* 请求取消了 */) {
            return;
        }
        
        @autoreleasepool {
            NSUInteger queuingLength =
            dataTask.requestOffset + dataTask.requestLength - dataTask.respondOffset;
            
            NSUInteger availableLength = MIN(queuingLength, data.length);
            NSData *availableData = [data subdataWithRange:NSMakeRange(0, availableLength)];
            
            // 这里给 loadingRequest.dataRequest 填充数据，并且将数据进行缓存
            // 排除极端情况，这里填充的数据和缓存到磁盘的数据应该是保持一致的
            [dataTask.loadingRequest.dataRequest respondWithData:availableData];
            dataTask.respondOffset += availableData.length;
            
            [self.cacheHandle writeTempFileData:availableData offset:dataTask.cachingOffset];
            dataTask.cachingOffset += availableData.length;
            
            if (availableLength >= queuingLength) {
                [dataTask.loadingRequest finishLoading];
                [dataTask cancle];
            }
        }
    } didCompleteWithError:^(NSError *error) {
        NSError *resultError = error;
        if (error.code == NSURLErrorCancelled) {
            resultError = nil;
        }
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(requestTask:didCompleteWithError:)]) {
            [self.delegate requestTask:self didCompleteWithError:error];
        }
        
        [self checkCache];
    }];

    
    [dataTask start];
}

- (void)cancleTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    ANYRequestDataTask *targetTask = nil;
    for (ANYRequestDataTask *dataTask in self.mArrDataTask) {
        if (dataTask.loadingRequest == loadingRequest) {
            targetTask = dataTask;
            break;
        }
    }
    
    if (targetTask)
        [targetTask cancle];
}

- (void)cancle {
    for (ANYRequestDataTask *dataTask in self.mArrDataTask) {
        [dataTask cancle];
    }
}


#pragma mark - tool

- (void)checkCache {
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"requestOffset" ascending:YES];
    NSSortDescriptor *sorter1 = [NSSortDescriptor sortDescriptorWithKey:@"cachingOffset" ascending:YES];
    [self.mArrDataTask sortUsingDescriptors:@[sorter, sorter1]];
    
    ANYRequestDataTask *tempTask = self.mArrDataTask.firstObject;
    ANYRange unionRange = ANYRangeFromTask(tempTask);
    for (ANYRequestDataTask *task in self.mArrDataTask) {
        ANYRange range = ANYRangeFromTask(task);
        if (ANYIntersectionRange(unionRange, range)) {
            unionRange = ANYMakeRange(MIN(unionRange.startOffset, range.startOffset),
                                      MAX(unionRange.endOffset, range.endOffset));
        }
    }
    
    if (unionRange.endOffset == self.contentLength) {
        [self.cacheHandle cacheTempFileWithURL:[self.requestURL any_originalSchemeURL]];
        [self.cacheHandle clearTempFile];
    }
}

- (void)fillContentInformationRequest:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest  {
    NSString *strContentType = @"video/mp4";
    CFStringRef inTag = (__bridge CFStringRef)(strContentType);
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, inTag, NULL);
    contentInformationRequest.contentType = CFBridgingRelease(contentType);
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentLength = self.contentLength;
}
@end
