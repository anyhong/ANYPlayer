//
//  ANYPlayerControlView.h
//  ANYPlayer
//
//  Created by Anyhong on 2018/2/2.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANYPlayerControlDelegate.h"

@class ANYPlayerControlView;
@protocol ANYPlayerControlViewDelegate <NSObject>
@optional
- (void)controlViewStartPlay:(ANYPlayerControlView *)controlView;
- (void)controlViewStartPause:(ANYPlayerControlView *)controlView;
@end

@interface ANYPlayerControlView : UIView <ANYPlayerControlDelegate>
@property (nonatomic, weak) id<ANYPlayerControlViewDelegate> delegate;
@end
