//
//  ANYCacheHandle.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/24.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYCacheHandle.h"
#import "NSString+ANYAdd.h"

@interface ANYCacheHandle ()
@property (nonatomic, assign) NSUInteger fileLength;
@property (nonatomic, strong) NSString *tempFileName;
@property (nonatomic, strong) NSString *tempFilePath;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *urlString;
@end


@implementation ANYCacheHandle


#pragma mark - getter

- (NSString *)tempFileName {
    if (!_tempFileName) {
        NSInteger timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        _tempFileName = @([@(timeStamp).stringValue hash]).stringValue;
    }
    return _tempFileName;
}

- (NSString *)tempFilePath {
    if (!_tempFilePath) {
        NSString *tempFilePath = [ANYCacheHandle tempFilePath:self.tempFileName];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if ([manager fileExistsAtPath:tempFilePath]) {
            [manager removeItemAtPath:tempFilePath error:nil];
        }
        if ([manager createFileAtPath:tempFilePath contents:nil attributes:nil]) {
            _tempFilePath = tempFilePath;
        }
    }
    return _tempFilePath;
}


#pragma mark - init

- (instancetype)initWithFileLength:(NSUInteger)fileLength {
    self = [super init];
    if (self) {
        self.fileLength = fileLength;
        
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.tempFilePath];
        [handle truncateFileAtOffset:fileLength];
    }
    return self;
}


#pragma mark - action

- (void)writeTempFileData:(NSData *)date offset:(NSUInteger)offset {
    if (!date || date.length == 0) return;
    
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.tempFilePath];
    [handle seekToFileOffset:offset];
    [handle writeData:date];
}

- (NSData *)readTempFileDataWithRange:(NSRange)fileRange {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:self.tempFilePath];
    [handle seekToFileOffset:fileRange.location];
    NSData *data = [handle readDataOfLength:fileRange.length];
    
    return data;
}

- (BOOL)clearTempFile {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL ret = NO;
    if ([manager fileExistsAtPath:_tempFilePath]) {
        ret = [manager removeItemAtPath:_tempFilePath error:nil];
    }
    _tempFileName = nil;
    return ret;
}

- (void)cacheTempFileWithFileName:(NSString *)fileName {
    if (fileName.length == 0) {
        NSAssert(NO, @"参数不能为空");
        return;
    }
    
    self.fileName = fileName;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheFilePath = [ANYCacheHandle cacheFilePath:[NSString stringWithFormat:@"%@.mp4", self.fileName]];
    [fileManager removeItemAtPath:cacheFilePath error:nil];
    BOOL success = [fileManager copyItemAtPath:self.tempFilePath toPath:cacheFilePath error:nil];
    NSLog(@"缓存文件%@ --- %@ ", success ? @"成功" : @"失败", cacheFilePath);
}

- (void)cacheTempFileWithURL:(NSURL *)URL {
    if (URL.absoluteString.length == 0) {
        NSAssert(NO, @"参数不能为空");
        return;
    }
    
    self.fileName = [URL.absoluteString any_md5];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheFilePath = [ANYCacheHandle cacheFilePath:[NSString stringWithFormat:@"%@.mp4", self.fileName]];
    [fileManager removeItemAtPath:cacheFilePath error:nil];
    BOOL success = [fileManager copyItemAtPath:self.tempFilePath toPath:cacheFilePath error:nil];
    NSLog(@"缓存文件%@ --- %@ ", success ? @"成功" : @"失败", cacheFilePath);
}

+ (NSString *)cacheFileExistsWithURL:(NSURL *)URL {
    if (URL.absoluteString.length == 0) {
        NSAssert(NO, @"参数不能为空");
        return nil;
    }
    NSString *fileName = [URL.absoluteString any_md5];
    NSString *cacheFilePath = [ANYCacheHandle cacheFilePath:[NSString stringWithFormat:@"%@.mp4", fileName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
        return cacheFilePath;
    }
    return nil;
}


+ (NSString *)cacheFileDirectory {
    NSArray *arrPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [arrPaths.firstObject stringByAppendingPathComponent:@"ANYVideoCache"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    if (![manager fileExistsAtPath:cacheDirectory]) {
        [manager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return cacheDirectory;
}

+ (NSString *)cacheFilePath:(NSString *)fileName {
    NSString *tempPath = [ANYCacheHandle cacheFileDirectory];
    NSString *fullPath = [tempPath stringByAppendingPathComponent:fileName];
    
    return fullPath;
}


+ (NSString *)tempFileDirectory {
    NSString *tempPath = NSTemporaryDirectory();
    NSString *cacheDirectory = [tempPath stringByAppendingPathComponent:@"ANYVideoTemp"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    if (![manager fileExistsAtPath:cacheDirectory]) {
        [manager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return cacheDirectory;
}

+ (NSString *)tempFilePath:(NSString *)tempFileName {
    
    NSString *tempPath = NSTemporaryDirectory();
    NSString *fullPath = [tempPath stringByAppendingPathComponent:tempFileName];
    
    return fullPath;
}


+ (BOOL)clearAllCacheFile {
    
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result = [manager removeItemAtPath:[ANYCacheHandle cacheFileDirectory] error:&error];
    
    return result;
}

+ (BOOL)clearAllTempFile {
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result = [manager removeItemAtPath:[ANYCacheHandle tempFileDirectory] error:&error];
    
    return result;
}
@end
