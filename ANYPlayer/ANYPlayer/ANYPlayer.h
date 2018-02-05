//
//  ANYPlayer.h
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/22.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANYPlayerControlDelegate.h"


@interface ANYPlayer : UIView
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUrl:(NSString *)urlString;
+ (ANYPlayer *)playerWithUrl:(NSString *)urlString;


@property (nonatomic, assign) NSUInteger repeatCount;
@property (nonatomic, assign, readonly) NSUInteger currentRepeatCount;
@property (nonatomic, assign) BOOL automaticallyPlay;
@property (nonatomic, strong) UIView<ANYPlayerControlDelegate> *controlView;

- (void)play;
- (void)pause;
@end
