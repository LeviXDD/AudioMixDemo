//
//  HTSoundBoard.h
//  AudioMixDemo
//
//  Created by 海涛 黎 on 2017/12/29.
//  Copyright © 2017年 Levi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define MCSOUNDBOARD_SOUND_PLAYED_NOTIFICATION @"MCSOUNDBOARD_SOUND_PLAYED_NOTIFICATION"
#define MCSOUNDBOARD_AUDIO_STARTED_NOTIFICATION @"MCSOUNDBOARD_AUDIO_STARTED_NOTIFICATION"
#define MCSOUNDBOARD_AUDIO_PAUSED_NOTIFICATION @"MCSOUNDBOARD_AUDIO_PAUSED_NOTIFICATION"
#define MCSOUNDBOARD_AUDIO_STOPPED_NOTIFICATION @"MCSOUNDBOARD_AUDIO_STOPPED_NOTIFICATION"

#define MCSOUNDBOARD_AUDIO_FADE_STEPS   30

@interface HTSoundBoard : NSObject {
    NSMutableDictionary *_sounds;
    NSMutableDictionary *_audio;
}
+ (HTSoundBoard *)sharedInstance;

+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key;
+ (void)playSoundForKey:(id)key;

+ (void)addAudioAtPath:(NSString *)filePath forKey:(id)key;

+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval;
+ (void)playAudioForKey:(id)key;

+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)stopAudioForKey:(id)key;

+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)pauseAudioForKey:(id)key;

+ (AVAudioPlayer *)audioPlayerForKey:(id)key;

+ (void)loopAudioForKey:(id)key numberOfLoops:(NSInteger)loops;

@end
