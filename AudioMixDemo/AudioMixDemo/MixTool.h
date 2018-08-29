//
//  MixTool.h
//  AudioMixDemo
//
//  Created by 海涛 黎 on 2017/11/28.
//  Copyright © 2017年 Levi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixTool : NSObject
/**
 合成音频文件（包含渐入渐出人声效果）

 @param toURL 合成文件后的导出路径
 @param backUrl 背景音乐文件路径
 @param audioUrl 要突出的声音文件
 @param startTime 渐入人声时间节点
 @param completed 合并文件完成
 */
+ (void)sourceComposeToURL:(NSURL *)toURL
                   backUrl:(NSURL*)backUrl
                  audioUrl:(NSURL*)audioUrl
                 startTime:(float)startTime
                 completed:(void (^)(NSError *error)) completed;
@end
