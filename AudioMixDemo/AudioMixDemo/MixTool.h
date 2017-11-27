//
//  MixTool.h
//  AudioMixDemo
//
//  Created by 海涛 黎 on 2017/11/28.
//  Copyright © 2017年 Levi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixTool : NSObject
/// 合并音频文件
/// @param sourceURLs 需要合并的多个音频文件
/// @param toURL      合并后音频文件的存放地址
/// 注意:导出的文件是:m4a格式的.
+ (void)sourceComposeToURL:(NSURL *) toURL backUrl:(NSURL*)backUrl audioUrl:(NSURL*)audioUrl completed:(void (^)(NSError *error)) completed;
@end
