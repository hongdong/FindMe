//
//  HDTool.h
//  FindMe
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDTool : NSObject

+ (UIImage *) scale:(UIImage *)sourceImg toSize:(CGSize)size;

+ (CGSize)scaleSize:(CGSize)sourceSize;

+ (NSString *)getOSVersion;

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;


+ (NSDate *)NSStringDateToNSDate:(NSString *)string;



//替换字符串
+ (NSString *)ReplaceString:(NSString *)targetString useRegExp:(NSString *) regExp byString:(NSString *) replaceString;


//读取资源文件
+ (NSString *)readResouceFile:(NSString *)filename andExt:(NSString *)ext;

//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

+(id)loadCustomViewByIndex:(NSUInteger)index;
@end
