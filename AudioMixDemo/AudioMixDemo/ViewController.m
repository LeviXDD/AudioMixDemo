//
//  ViewController.m
//  AudioMixDemo
//
//  Created by 海涛 黎 on 2017/11/28.
//  Copyright © 2017年 Levi. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MixTool.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *composeButton;

@property (nonatomic, strong) AVAudioRecorder *recoder;


@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong)   AVAssetExportSession* assetExport;

/// 目标路径
@property (nonatomic, copy) NSURL *destURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (IBAction)start {
    //  准备录音
    [self prepareToRecord];
    //  录音记录
    BOOL isSuccess = [self.recoder record];
    if (isSuccess) {
        NSLog(@"开始录音成功");
    }else{
        NSLog(@"开始录音失败");
    }
}

- (IBAction)stop {
    [self.recoder stop];
    NSLog(@"停止录音,保存文件的路径为:%@",self.recoder.url.absoluteString);
}

- (IBAction)compose {
    
    //  文档路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //  文件路径
    NSArray *fileNames = [[NSFileManager defaultManager] subpathsAtPath:docPath];
    //  获取文档目录保存所有 .AAC 格式的音频文件URL
    NSMutableArray *sourceURLs = [NSMutableArray array];
    
    //  遍历
    for (NSString *fileName in fileNames) {
        NSLog(@"源文件:%@",fileName);
        
        if (![fileName.pathExtension isEqualToString:@"AAC"]) {
            continue;
        }
        
        //      文件路径
        NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
        //      文件的URL
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        //      源文件数组
        [sourceURLs addObject:fileURL];
    }
    
    //  目标文件路径
    
    
    
    NSString *destPath = [docPath stringByAppendingPathComponent:@"dest.m4a"];
    NSError *error = nil;
    //  如果目标文件已经存在删除目标文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
        if (!success) {
            NSLog(@"删除文件失败:%@",error);
        }else{
            NSLog(@"删除文件:%@成功",destPath);
        }
    }
    //  目录文件URL
    self.destURL = [NSURL fileURLWithPath:destPath];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"GALA" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [sourceURLs addObject:url];
    ////  导出音频
    [MixTool sourceComposeToURL:self.destURL backUrl:url audioUrl:sourceURLs.firstObject completed:^(NSError *error) {
        if (error == nil) {
            [self.composeButton setTitle:@"合并成功" forState:UIControlStateNormal];
        }
    }];
    
}

- (IBAction)play {
    //  创建音频播放器
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.destURL error:&error];
    if (error) {
        NSLog(@"创建音频播放器失败:%@",error);
        return;
    }
    //  准备播放
    [self.player prepareToPlay];
    [self.player play];
}


- (void) prepareToRecord {
    
    // 真机环境仅仅是这样还不能录音
    NSError *error = nil;
    //  单例对象,用于设置当前的应用的音频环境
    //  设置音频的类别
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord  error:&error];
    if (error) {
        NSLog(@"设置录音模式出错");
        return;
    }
    static int count = 0;
    count++;
    NSString *fileName = [NSString stringWithFormat:@"recoder_%d.AAC",count];
    //  把录音文件保存在沙盒中
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    //  路径转换为URL
    NSURL *url = [NSURL fileURLWithPath:path];
    //    NSLog(@"%@",url);
    //  录音设置: 了解,涉及到音频很专业的东西,
    //录音: 音频文件最小
    //settings  设置参数  录音相关参数  声道  速率  采样率
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    //2.够着  录音参数
    // 音频格式
    setting[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    //    文件后缀必须是: AAC,必须是大写
    // 音频采样率
    setting[AVSampleRateKey] = @(16000.0);
    // 音频通道数
    setting[AVNumberOfChannelsKey] = @(1);
    // 线性音频的位深度
    setting[AVLinearPCMBitDepthKey] = @(8);
    // 音频编码质量
    setting[AVEncoderAudioQualityKey] = @(AVAudioQualityMin);
    
    //  1 .创建录音器
    /// URL: 录音文件保存的地址
    /// settings: 录音的设置
    /// error: 创建录音器的错误信息
    //    NSError *error = nil;
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:url settings:@{} error:&error];
    
    if (error) {
        NSLog(@"创建录音器失败:%@",error);
        return;
    }
    
    //  2. 准备录音
    [recorder prepareToRecord];
    //  3. 开启音频的分贝的更新
    recorder.meteringEnabled = YES;
    
    //  记录录音器
    self.recoder = recorder;
    
}
@end
