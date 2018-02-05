//
//  NSString+ANYAdd.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/31.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "NSString+ANYAdd.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ANYAdd)
- (NSString *)any_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr,(CC_LONG)strlen(cStr),result);
    NSString* md5str=[[NSString stringWithFormat:
                       @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                       result[0], result[1], result[2], result[3],
                       result[4], result[5], result[6], result[7],
                       result[8], result[9], result[10], result[11],
                       result[12], result[13], result[14], result[15]] lowercaseString];
    
    return md5str;
}
@end
