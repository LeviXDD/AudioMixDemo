//
//  HTSoundBoard+fadeVolume.m
//  AudioMixDemo
//
//  Created by 海涛 黎 on 2017/12/29.
//  Copyright © 2017年 Levi. All rights reserved.
//

#import "HTSoundBoard+fadeVolume.h"

@implementation HTSoundBoard (fadeVolume)
+ (void)fadeInWithBackgroundKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval{
    [[self sharedInstance] fadeInWithBackgroundKey:key fadeOutInterval:fadeOutInterval];
}
- (void)fadeInWithBackgroundKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeIn:)
                                       userInfo:player
                                        repeats:YES];
    }
    //    else {
    //        [player stop];
    //    }
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:MCSOUNDBOARD_AUDIO_STOPPED_NOTIFICATION object:key];
}


- (void)fadeIn:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume + 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume > 1.0 ? 1.0 : volume;
    player.volume = volume;
    
    if (volume >= 1.0) {
        [timer invalidate];
    }
}

+ (void)fadeOutWithBackgroundKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval{
    [[self sharedInstance] fadeOutWithBackgroundKey:key fadeOutInterval:fadeOutInterval];
}
- (void)fadeOutWithBackgroundKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOut:)
                                       userInfo:player
                                        repeats:YES];
    }
    //    else {
    //        [player stop];
    //    }
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:MCSOUNDBOARD_AUDIO_STOPPED_NOTIFICATION object:key];
}

- (void)fadeOut:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.2 ? 0.2 : volume;
    player.volume = volume;
    
        if (volume <= 0.21) {
            [timer invalidate];
        }
}

@end
