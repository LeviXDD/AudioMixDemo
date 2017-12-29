//
//  HTSoundBoard+fadeVolume.h
//  AudioMixDemo
//
//  Created by 海涛 黎 on 2017/12/29.
//  Copyright © 2017年 Levi. All rights reserved.
//

#import "HTSoundBoard.h"

@interface HTSoundBoard (fadeVolume)
+ (void)fadeOutWithBackgroundKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
//- (void)fadeOutWithBackgroundKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)fadeInWithBackgroundKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
@end
