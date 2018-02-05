//
//  ANYResourceLoader.h
//  ANYPlayer
//
//  Created by Anyhong on 2018/1/22.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol ANYResourceLoaderDelegate <NSObject>
@optional
@end


@interface ANYResourceLoader : NSObject <AVAssetResourceLoaderDelegate>
@property (nonatomic, assign) id<ANYResourceLoaderDelegate> delegate;
@end
