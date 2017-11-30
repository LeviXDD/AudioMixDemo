//
//  MixTool.m
//  AudioMixDemo
//
//  Created by 海涛 黎 on 2017/11/28.
//  Copyright © 2017年 Levi. All rights reserved.
//

#import "MixTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation MixTool
/// 合并音频文件
/// @param sourceURLs 需要合并的多个音频文件
/// @param toURL      合并后音频文件的存放地址
/// 注意:导出的文件是:m4a格式的.
+ (void)sourceComposeToURL:(NSURL *) toURL backUrl:(NSURL*)backUrl audioUrl:(NSURL*)audioUrl startTime:(float)startTime completed:(void (^)(NSError *error)) completed{
    //  合并所有的录音文件
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //  获取音频合并音轨
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *error = nil;
    AVURLAsset  *backAudioAsset = [[AVURLAsset alloc]initWithURL:backUrl options:nil];
    CMTimeRange back_audio_timeRange = CMTimeRangeMake(kCMTimeZero, backAudioAsset.duration);
    BOOL success = [compositionAudioTrack insertTimeRange:back_audio_timeRange ofTrack:[[backAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&error];
    if (!success) {
        NSLog(@"插入音频失败: %@",error);
    }
    
    AVMutableCompositionTrack *recordAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *recordError = nil;
    AVURLAsset  *recordAudioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    //获取录音文件时长
    CMTime audioDuration = recordAudioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    //计算录音文件插入时间段
    CMTime start = CMTimeMakeWithSeconds(startTime, 1);
    CMTime duration = CMTimeMakeWithSeconds(audioDurationSeconds,1);
    CMTimeRange audio_timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), duration);
    
    BOOL recordSuccess = [recordAudioTrack insertTimeRange:audio_timeRange ofTrack:[[recordAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:start error:&recordError];
    if (!recordSuccess) {
        NSLog(@"插入音频失败: %@",recordError);
    }
    
    //设置降低背景音乐参数
    NSMutableArray *audioMixParams = [NSMutableArray array];
    //降低背景音乐时间节点
    AVMutableAudioMixInputParameters *minColumeMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTrack];
    [minColumeMix setVolumeRampFromStartVolume:1. toEndVolume:0.1 timeRange:CMTimeRangeMake(CMTimeMake(startTime-1, 1), CMTimeMake(2, 1))];
    [audioMixParams addObject:minColumeMix];
    //提高背景音乐时间节点
//    AVMutableAudioMixInputParameters *maxVolumeMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTrack];
    CMTime endMinVolumeTime = CMTimeMake(startTime+audioDurationSeconds, 1);
//    [maxVolumeMix setVolume:1.f atTime:endMinVolumeTime];
    [minColumeMix setVolumeRampFromStartVolume:0.1 toEndVolume:1. timeRange:CMTimeRangeMake(endMinVolumeTime, CMTimeMake(2, 1))];
//    [audioMixParams addObject:maxVolumeMix];
    
    AVMutableAudioMix *backAudioMix = [AVMutableAudioMix audioMix];
    backAudioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
    
    // 创建一个导入M4A格式的音频的导出对象
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    //  导入音视频的URL
    assetExport.outputURL = toURL;
    //  导出音视频的文件格式
    assetExport.outputFileType = AVFileTypeAppleM4A;//@"com.apple.m4a-audio";
    //导出参数
    assetExport.audioMix = backAudioMix;
    //  导入出
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        //      分发到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            switch ([assetExport status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"合成失败：%@",[[assetExport error] description]);
                    //                    completionHandle(outputFilePath,NO);
                    completed(nil);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    //                    completionHandle(outputFilePath,NO);
                    completed(nil);
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    //                    completionHandle(outputFilePath,YES);
                    completed(nil);
                } break;
                default: {
                    //                    completionHandle(outputFilePath,NO);
                    completed(nil);
                } break;
            }
        });
    }];
    
}

@end
