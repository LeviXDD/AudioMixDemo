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
+ (void)sourceComposeToURL:(NSURL *) toURL backUrl:(NSURL*)backUrl audioUrl:(NSURL*)audioUrl completed:(void (^)(NSError *error)) completed{
    NSMutableArray *audioMixParams = [NSMutableArray array];
    
    //    NSAssert(sourceURLs.count > 1,@"源文件不足两个无需合并");
    
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
    
    

    
    //Demo中暂时把时间设置的短一点
    CGFloat startSecond = 3;
    CGFloat endSecond = 13;
    CMTime start = CMTimeMakeWithSeconds(startSecond, backAudioAsset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endSecond - startSecond,backAudioAsset.duration.timescale);
    CMTimeRange audio_timeRange = CMTimeRangeMake(start, duration);
    
    //修改背景音乐
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTrack];
    [trackMix setVolume:0.3f atTime:start];
    [audioMixParams addObject:trackMix];
    
    AVMutableAudioMix *backAudioMix = [AVMutableAudioMix audioMix];
    backAudioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
    
    AVMutableCompositionTrack *recordAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *recordError = nil;
    AVURLAsset  *recordAudioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    //    CMTimeRange record_audio_timeRange = CMTimeRangeMake(kCMTimeZero, backAudioAsset.duration);
    BOOL recordSuccess = [recordAudioTrack insertTimeRange:audio_timeRange ofTrack:[[recordAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:start error:&recordError];
    if (!recordSuccess) {
        NSLog(@"插入音频失败: %@",recordError);
    }
    //      记录开始时间
    
    
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
