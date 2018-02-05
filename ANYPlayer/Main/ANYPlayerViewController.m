//
//  ANYPlayerViewController.m
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/22.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYPlayerViewController.h"
#import "ANYPlayer.h"
#import "ANYPlayerControlView.h"

@interface ANYPlayerViewController () <ANYPlayerControlViewDelegate>
@property (nonatomic, strong) ANYPlayer *player;
@end

@implementation ANYPlayerViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ANYPlayerControlView *controlView = [[ANYPlayerControlView alloc] init];
    controlView.delegate = self;
    self.player = [[ANYPlayer alloc] initWithUrl:self.videoUrl];
    self.player.controlView = controlView;
    self.player.frame = self.view.bounds;
    self.player.repeatCount = 5;
    [self.view addSubview:self.player];
    
    self.player.automaticallyPlay = YES;
}


#pragma mark - ANYPlayerControlViewDelegate

- (void)controlViewStartPlay:(ANYPlayerControlView *)controlView {
    [self.player play];
}

- (void)controlViewStartPause:(ANYPlayerControlView *)controlView {
    [self.player pause];
}
@end
