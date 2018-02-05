//
//  ANYPlayerControlDelegate.h
//  ANYPlayer
//
//  Created by Anyhong on 2018/2/2.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ANYPlayer;
@protocol ANYPlayerControlDelegate <NSObject>
@optional

- (void)playerReadyToPlay:(ANYPlayer *)player;
- (void)player:(ANYPlayer *)player didUpdatePlayingStatus:(BOOL)isPlaying;
- (void)player:(ANYPlayer *)player didUpdateBuferringStatus:(BOOL)isBuffering;
- (void)player:(ANYPlayer *)player didFinishedWithError:(NSError *)error;
@end
