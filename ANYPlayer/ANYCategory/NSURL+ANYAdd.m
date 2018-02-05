//
//  NSURL+ANYAdd.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/31.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "NSURL+ANYAdd.h"

@implementation NSURL (ANYAdd)
- (NSURL *)any_customSchemeURL {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

- (NSURL *)any_originalSchemeURL {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}
@end
