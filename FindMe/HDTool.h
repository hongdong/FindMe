//
//  HDTool.h
//  FindMe
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+HDHUD.h"
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
//载入自己定义的View
+ (id)loadCustomViewByIndex:(NSUInteger)index;
//判断APP是否是这个版本第一次启动
+ (BOOL) isFirstLoad;
//在其他地方判断APP是否是这个版本第一次启动
+ (BOOL) isFirstLoad2;
+(id)getControllerByStoryboardId:(NSString *)storyboardId;
//关闭IOS7返回手势
+(void)noGes:(UIViewController *)controller;

+(void)ges:(UIViewController *)controller;

+(NSURL *)getLImage:(NSString *)url;
+(NSURL *)getSImage:(NSString *)url;
+(void)showHUD:(NSString *)title;
+(void)dismissHUD;
+(void)successHUD;
+(void)errorHUD;

+(void)autoSex:(UIImageView *)imageView;

+(NSString *)generateImgName;
@end
