//
//  ANYCacheHandle.h
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/24.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANYCacheHandle : NSObject
- (instancetype)initWithFileLength:(NSUInteger)fileLength NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)writeTempFileData:(NSData *)date offset:(NSUInteger)offset;
- (NSData *)readTempFileDataWithRange:(NSRange)fileRange;

- (void)cacheTempFileWithFileName:(NSString *)fileName;
- (void)cacheTempFileWithURL:(NSURL *)URL;

+ (NSString *)cacheFileExistsWithURL:(NSURL *)URL;

- (BOOL)clearTempFile;
+ (BOOL)clearAllCacheFile;
+ (BOOL)clearAllTempFile;
@end
