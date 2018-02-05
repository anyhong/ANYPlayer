//
//  ANYPlayerControlView.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/2/2.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYPlayerControlView.h"


@interface ANYPlayerControlView ()
@property (nonatomic, weak) UIView *actionView;
@property (nonatomic, weak) UIButton *playButton;
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@end

@implementation ANYPlayerControlView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *actionView = [[UIView alloc] init];
    actionView.backgroundColor = [UIColor clearColor];
    [self addSubview:actionView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionPause:)];
    [actionView addGestureRecognizer:tap];
    self.actionView = actionView;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.hidesWhenStopped = YES;
    indicatorView.userInteractionEnabled = NO;
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    playButton.hidden = YES;
    [playButton setImage:[UIImage imageNamed:@"ic_sv_play_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"ic_sv_play_play"] forState:UIControlStateHighlighted];
    [self addSubview:playButton];
    self.playButton = playButton;
    
    [playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.actionView.frame = self.bounds;
    self.playButton.frame = self.bounds;
    self.indicatorView.frame = self.bounds;
}

- (void)actionPlay:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewStartPlay:)]) {
        [self.delegate controlViewStartPlay:self];
    }
}

- (void)actionPause:(UITapGestureRecognizer *)ges {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewStartPause:)]) {
        [self.delegate controlViewStartPause:self];
    }
}


#pragma mark - ANYPlayerControlDelegate

- (void)player:(ANYPlayer *)player didUpdatePlayingStatus:(BOOL)isPlaying {
    self.playButton.hidden = isPlaying;
}

- (void)player:(ANYPlayer *)player didUpdateBuferringStatus:(BOOL)isBuffering {
    isBuffering ? [self.indicatorView startAnimating] : [self.indicatorView stopAnimating];
}

- (void)player:(ANYPlayer *)player didFinishedWithError:(NSError *)error {
    // 显示错误提示
}

- (void)playerReadyToPlay:(ANYPlayer *)player {
    // 隐藏图片
    // 显示进度条
    // 等
}
@end
