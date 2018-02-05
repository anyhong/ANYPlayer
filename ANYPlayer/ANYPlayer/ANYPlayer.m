//
//  ANYPlayer.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/22.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "ANYResourceLoader.h"
#import "NSURL+ANYAdd.h"
#import "ANYCacheHandle.h"
#import "ANYPlayerControlDelegate.h"


#pragma mark enum
/**
 item的实时状态

 - ANYPlayerItemStatusDefault: 无
 - ANYPlayerItemStatusUnknown: 未处理
 - ANYPlayerItemStatusReadyToPlay: item已经准备好，可以进行播放了
 - ANYPlayerItemStatusFailed: 播放失败
 - ANYPlayerItemStatusBuffering: 缓冲中
 - ANYPlayerItemStatusBufferReadyToPlay: 缓冲足够进行播放了
 - ANYPlayerItemStatusBufferFull: 缓冲完成
 - ANYPlayerItemStatusPlayToEndTime: 播放完成
 */
typedef NS_ENUM(NSInteger, ANYPlayerItemStatus) {
    ANYPlayerItemStatusDefault,
    ANYPlayerItemStatusUnknown,
    ANYPlayerItemStatusReadyToPlay,
    ANYPlayerItemStatusFailed,
    ANYPlayerItemStatusBuffering,
    ANYPlayerItemStatusBufferReadyToPlay,
    ANYPlayerItemStatusBufferFull,
    ANYPlayerItemStatusPlayToEndTime,
};


/**
 播放器状态
 这个是记录播放器的真实播放状态的

 - ANYPlayerStatusPlaying: 播放中
 - ANYPlayerStatusPause: 暂停中
 - ANYPlayerStatusFailed: 出错
 */
typedef NS_ENUM(NSInteger, ANYPlayerStatus) {
    ANYPlayerStatusPlaying,
    ANYPlayerStatusPause,
    ANYPlayerStatusFailed
};



/**
 这个是播放器即将的行为状态
 播放器即将执行的状态，
 eg,
 当前播放状态是 ANYPlayerForwardStatusPlay，
 希望播放器执行即将的状态是 ANYPlayerForwardStatusPause
 
 - ANYPlayerForwardStatusPlay: 播放
 - ANYPlayerForwardStatusPause: 暂停
 */
typedef NS_ENUM(NSInteger, ANYPlayerForwardStatus) {
    ANYPlayerForwardStatusPlay,
    ANYPlayerForwardStatusPause
};


#pragma mark kvo
static NSString * const kPlayer_rate = @"rate";
static NSString * const kPlayer_error = @"error";
static NSString * const kPlayer_timeControlStatus = @"timeControlStatus";
static NSString * const kPlayerItem_status = @"status";
static NSString * const kPlayerItem_duration = @"duration";
static NSString * const kPlayerItem_loadedTimeRanges = @"loadedTimeRanges";
static NSString * const kPlayerItem_playbackBufferEmpty = @"playbackBufferEmpty";
static NSString * const kPlayerItem_playbackLikelyToKeepUp = @"playbackLikelyToKeepUp";
static NSString * const kPlayerItem_playbackBufferFull = @"playbackBufferFull";




@interface ANYPlayer ()<ANYResourceLoaderDelegate>
@property (nonatomic, strong) NSString       *urlString;
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *playerItem;
@property (nonatomic, strong) AVPlayerLayer  *playerLayer;
@property (nonatomic, strong) AVURLAsset     *urlAsset;
@property (nonatomic, strong) ANYResourceLoader *resourceLoader;
@property (nonatomic, strong) id timeObserver;

@property (nonatomic, assign) ANYPlayerStatus playerStatus;
@property (nonatomic, assign) ANYPlayerItemStatus playerItemStatus;
@property (nonatomic, assign) ANYPlayerForwardStatus forwardStatus;

@property (nonatomic, assign, readwrite) NSUInteger currentRepeatCount;
@end



@implementation ANYPlayer

#pragma mark - life circle

- (void)dealloc {
    [self removeObsever];
}


#pragma mark - init

- (instancetype)initWithUrl:(NSString *)urlString {
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.backgroundColor = [UIColor blackColor];
        [self setupPlayer];
    }
    return self;
}

+ (ANYPlayer *)playerWithUrl:(NSString *)urlString {
    return [[ANYPlayer alloc] initWithUrl:urlString];
}


#pragma mark - UI

- (void)setControlView:(UIView<ANYPlayerControlDelegate> *)controlView {
    if (controlView == _controlView) {
        // nothing
    } else {
        if (_controlView) {
            [_controlView removeFromSuperview];
        }
        
        _controlView = controlView;
        
        [self addSubview:controlView];
        
        [self layoutIfNeeded];
    }
}

- (void)setupPlayer {
    NSURL *playUrl  = [NSURL URLWithString:self.urlString];
    NSString *cachePath = [ANYCacheHandle cacheFileExistsWithURL:playUrl];
    cachePath = nil;
    if (cachePath.length) {
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:cachePath]];
    } else {
        self.resourceLoader = [[ANYResourceLoader alloc] init];
        self.resourceLoader.delegate = self;
        self.urlAsset = [AVURLAsset URLAssetWithURL:[playUrl any_customSchemeURL] options:nil];
        [self.urlAsset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
        self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    }
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    if (@available(iOS 10, *)) {    
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 44, self.bounds.size.width, self.bounds.size.height-44);
    [self.layer addSublayer:self.playerLayer];
    
    [self addObserver];
    [self addNotification];
    
    self.forwardStatus = ANYPlayerForwardStatusPause;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    self.controlView.frame = self.bounds;
}

- (void)setAutomaticallyPlay:(BOOL)automaticallyPlay {
    _automaticallyPlay = automaticallyPlay;
    if (automaticallyPlay) {
        [self play];
    } else {
        [self pause];
    }
}


#pragma mark - public

- (void)play {
    self.forwardStatus = ANYPlayerForwardStatusPlay;
    
    if (CMTimeGetSeconds(self.player.currentItem.currentTime) >=
        CMTimeGetSeconds(self.player.currentItem.duration)) {
        [self.player seekToTime:CMTimeMakeWithSeconds(4, 600)];
    }
    
    [self.player play];
}

- (void)pause {
    self.forwardStatus = ANYPlayerForwardStatusPause;
    [self.player pause];
}


#pragma mark - action

- (void)setForwardStatus:(ANYPlayerForwardStatus)forwardStatus {
    _forwardStatus = forwardStatus;
    
    [self updatePlayerItemStatus:self.playerItemStatus];
}

- (void)setPlayerItemStatus:(ANYPlayerItemStatus)playerItemStatus {
    _playerItemStatus = playerItemStatus;
    
    [self updatePlayerItemStatus:playerItemStatus];
}

- (void)setPlayerStatus:(ANYPlayerStatus)playerStatus {
    _playerStatus = playerStatus;
    
    if (playerStatus == ANYPlayerStatusFailed) {                                NSLog(@"debug-ANYPlayerStatusFailed");
        [self hidePlayingStatusView];
        [self hideBufferLoadingView];
    } else if (playerStatus == ANYPlayerStatusPlaying) {                        NSLog(@"debug-ANYPlayerStatusPlaying");
        
    } else if (playerStatus == ANYPlayerStatusPause) {                          NSLog(@"debug-ANYPlayerStatusPause");
        
    }
}

- (void)updatePlayerItemStatus:(ANYPlayerItemStatus)playerItemStatus {
    
    // 部分情况处理逻辑相同，暂时全部独立，待扩展
    
    if (playerItemStatus == ANYPlayerItemStatusDefault) {                       NSLog(@"debug--ANYPlayerItemStatusDefault");
        if (self.forwardStatus == ANYPlayerForwardStatusPlay) {                 NSLog(@"debug----ANYPlayerForwardStatusPlay");
            [self hidePlayingStatusView];
            [self showBufferLoadingView];
        } else if (self.forwardStatus == ANYPlayerForwardStatusPause) {         NSLog(@"debug----ANYPlayerForwardStatusPause");
            [self showPlayingStatusView];
            [self hideBufferLoadingView];
        }
        
    } else if (playerItemStatus == ANYPlayerItemStatusReadyToPlay) {            NSLog(@"debug--ANYPlayerItemStatusReadyToPlay");
        if (self.forwardStatus == ANYPlayerForwardStatusPlay) {                 NSLog(@"debug----ANYPlayerForwardStatusPlay");
            [self hidePlayingStatusView];
            [self hideBufferLoadingView];
            [self.player play];
        } else if (self.forwardStatus == ANYPlayerForwardStatusPause) {         NSLog(@"debug----ANYPlayerForwardStatusPause");
            [self showPlayingStatusView];
            [self hideBufferLoadingView];
        }
        
    } else if (playerItemStatus == ANYPlayerItemStatusBuffering) {              NSLog(@"debug--ANYPlayerItemStatusBuffering");
        if (self.forwardStatus == ANYPlayerForwardStatusPlay) {                 NSLog(@"debug----ANYPlayerForwardStatusPlay");
            [self hidePlayingStatusView];
            [self showBufferLoadingView];
        } else if (self.forwardStatus == ANYPlayerForwardStatusPause) {         NSLog(@"debug----ANYPlayerForwardStatusPlay");
            [self showPlayingStatusView];
            [self hideBufferLoadingView];
        }
        
    } else if (playerItemStatus == ANYPlayerItemStatusBufferReadyToPlay) {      NSLog(@"debug--ANYPlayerItemStatusBufferReadyToPlay");
        if (self.forwardStatus == ANYPlayerForwardStatusPlay) {                 NSLog(@"debug----ANYPlayerForwardStatusPlay");
            [self hidePlayingStatusView];
            [self hideBufferLoadingView];
            [self.player play];
        } else if (self.forwardStatus == ANYPlayerForwardStatusPause) {         NSLog(@"debug----ANYPlayerForwardStatusPause");
            [self showPlayingStatusView];
            [self hideBufferLoadingView];
        }
        
    } else if (playerItemStatus == ANYPlayerItemStatusBufferFull) {             NSLog(@"debug--ANYPlayerItemStatusBufferFull");
        if (self.forwardStatus == ANYPlayerForwardStatusPlay) {                 NSLog(@"debug----ANYPlayerForwardStatusPlay");
            [self hidePlayingStatusView];
            [self hideBufferLoadingView];
            [self.player play];
        } else if (self.forwardStatus == ANYPlayerForwardStatusPause) {         NSLog(@"debug----ANYPlayerForwardStatusPause");
            [self showPlayingStatusView];
            [self hideBufferLoadingView];
        }
    } else if (playerItemStatus == ANYPlayerItemStatusFailed) {                 NSLog(@"debug--ANYPlayerItemStatusFailed");
        [self hidePlayingStatusView];
        [self hideBufferLoadingView];
        [self playFinishedWithError];
    } else if (playerItemStatus == ANYPlayerItemStatusUnknown) {                NSLog(@"debug--ANYPlayerItemStatusUnknown");
        
    }
    
//    else if (playerItemStatus == ANYPlayerItemStatusPlayToEndTime) {          NSLog(@"debug--ANYPlayerItemStatusPlayToEndTime");
//        [self showPlayingStatusView];
//        [self hideBufferLoadingView];
//    }
}


#pragma mark - notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAVPlayerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleAVPlayerItemDidPlayToEndTime:(NSNotification *)aNotification {
    AVPlayerItem *item = aNotification.object;
    
    // kCMTimeZero 触发 AVPlayerItemDidPlayToEndTimeNotification
    if (CMTimeGetSeconds(item.currentTime) >=
        CMTimeGetSeconds(item.duration)) {
        NSLog(@"debug-----handleAVPlayerItemDidPlayToEndTime");
        [self showPlayingStatusView];
        [self hideBufferLoadingView];
        if (self.repeatCount > 0 && self.repeatCount >= ++self.currentRepeatCount) {
            [self hidePlayingStatusView];
            [self hideBufferLoadingView];
            [self.player seekToTime:kCMTimeZero];
            [self.player play];
        }
    }
}


#pragma mark - observer

- (void)addObserver {
    [self.playerItem addObserver:self
                      forKeyPath:kPlayerItem_status
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self.playerItem addObserver:self
                      forKeyPath:kPlayerItem_loadedTimeRanges
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self.playerItem addObserver:self
                      forKeyPath:kPlayerItem_playbackBufferEmpty
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self.playerItem addObserver:self
                      forKeyPath:kPlayerItem_playbackLikelyToKeepUp
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self.playerItem addObserver:self
                      forKeyPath:kPlayerItem_playbackBufferFull
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self.playerItem addObserver:self
                      forKeyPath:kPlayerItem_duration
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    [self.player addObserver:self
                  forKeyPath:kPlayer_error
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    [self.player addObserver:self
                  forKeyPath:kPlayer_rate
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    [self.player addObserver:self
                  forKeyPath:kPlayer_timeControlStatus
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, 600)
                                                                  queue:nil
                                                             usingBlock:^(CMTime time) {
                                                                 
        NSLog(@"Playback time %.5f", CMTimeGetSeconds(time));
    }];
}

- (void)removeObsever {
    @try {
        [self.playerItem removeObserver:self forKeyPath:kPlayerItem_status];
        [self.playerItem removeObserver:self forKeyPath:kPlayerItem_duration];
        [self.playerItem removeObserver:self forKeyPath:kPlayerItem_loadedTimeRanges];
        [self.playerItem removeObserver:self forKeyPath:kPlayerItem_playbackBufferFull];
        [self.playerItem removeObserver:self forKeyPath:kPlayerItem_playbackBufferEmpty];
        [self.playerItem removeObserver:self forKeyPath:kPlayerItem_playbackLikelyToKeepUp];
        [self.player removeObserver:self forKeyPath:kPlayer_error];
        [self.player removeObserver:self forKeyPath:kPlayer_rate];
        [self.player removeObserver:self forKeyPath:kPlayer_timeControlStatus];
        [self.player removeTimeObserver:self.timeObserver];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    AVPlayerItem *playerItem = nil;
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        playerItem = (AVPlayerItem *)object;
    }
    
    if ([keyPath isEqualToString:kPlayerItem_status]) {                         // item状态
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            self.playerItemStatus = ANYPlayerItemStatusReadyToPlay;
        } else if (playerItem.status == AVPlayerItemStatusFailed) {
            self.playerItemStatus = ANYPlayerItemStatusFailed;
            NSLog(@"self.player.currentItem.error:%@", self.player.currentItem.error);
        } else if (playerItem.status == AVPlayerItemStatusUnknown) {
            self.playerItemStatus = ANYPlayerItemStatusUnknown;
        }
    } else if ([keyPath isEqualToString:kPlayerItem_loadedTimeRanges]) {        // 缓存进度更新
        NSLog(@"loadedTimeRanges:%@", playerItem.loadedTimeRanges);
    } else if ([keyPath isEqualToString:kPlayerItem_playbackBufferEmpty]) {     // 缓存是空
        if (playerItem.isPlaybackBufferEmpty) {
            self.playerItemStatus = ANYPlayerItemStatusBuffering;
        }

    } else if ([keyPath isEqualToString:kPlayerItem_playbackLikelyToKeepUp]) {  // 缓存好了
        if (playerItem.playbackLikelyToKeepUp) {
            self.playerItemStatus = ANYPlayerItemStatusBufferReadyToPlay;
        }
    } else if ([keyPath isEqualToString:kPlayerItem_playbackBufferFull]) {      // 全部缓存完
        if (playerItem.playbackBufferFull) {
            self.playerItemStatus = ANYPlayerItemStatusBufferFull;
        }
    } else if ([keyPath isEqualToString:kPlayerItem_duration]) {                // 获取到视频时间
        
    } else if ([keyPath isEqualToString:kPlayer_rate]) {                        // player播放状态变化
        if (self.player.rate == 0.0) {
            self.playerStatus = ANYPlayerStatusPause;
        } else if (self.player.rate == 1.0) {
            self.playerStatus = ANYPlayerStatusPlaying;
        }
    } else if ([keyPath isEqualToString:kPlayer_timeControlStatus]) {           // player播放状态变化
        
    } else if ([keyPath isEqualToString:kPlayer_error]) {                       // player出错
        self.playerStatus = ANYPlayerStatusFailed;
        NSLog(@"self.player.error:%@", self.player.error);
    }
}


#pragma mark - tool

- (void)hidePlayingStatusView {
    if ([self.controlView respondsToSelector:@selector(player:didUpdatePlayingStatus:)]) {
        [self.controlView player:self didUpdatePlayingStatus:YES];
    }
}

- (void)showPlayingStatusView {
    if ([self.controlView respondsToSelector:@selector(player:didUpdatePlayingStatus:)]) {
        [self.controlView player:self didUpdatePlayingStatus:NO];
    }
}

- (void)showBufferLoadingView {
    if ([self.controlView respondsToSelector:@selector(player:didUpdateBuferringStatus:)]) {
        [self.controlView player:self didUpdateBuferringStatus:YES];
    }
}

- (void)hideBufferLoadingView {
    if ([self.controlView respondsToSelector:@selector(player:didUpdateBuferringStatus:)]) {
        [self.controlView player:self didUpdateBuferringStatus:NO];
    }
}

- (void)playFinishedWithError {
    if ([self.controlView respondsToSelector:@selector(player:didFinishedWithError:)]) {
        [self.controlView player:self didFinishedWithError:self.playerItem.error];
    }
}

- (BOOL)isPlaying {
    if ([[UIDevice currentDevice] systemVersion].intValue >= 10) {
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    } else {
        return self.player.rate == 1;
    }
}


- (void)bufferingSomeSecond {
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player play];
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}
@end
