//
//  HDTool.m
//  FindMe
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HDTool.h"
#import "GCDiscreetNotificationView.h"
#define LAST_RUN_VERSION_KEY        @"last_run_version_of_application"
@implementation HDTool
+ (UIImage *)scale:(UIImage *)sourceImg toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [sourceImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (CGSize)scaleSize:(CGSize)sourceSize
{
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    }
    else
    {
        return CGSizeMake(800 * width / height, 800);
    }
}

+ (NSString *)getOSVersion
{
    return [NSString stringWithFormat:@"FindMe/%@/%@/%@/%@",AppVersion,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    [notificationView hideAnimatedAfter:2.6];
}

+ (NSString *)ReplaceString:(NSString *)targetString useRegExp:(NSString *) regExp byString:(NSString *) replaceString
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExp options:0 error:&error];
    NSString *lowercaseString = [targetString lowercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:lowercaseString options:0 range:NSMakeRange(0,[lowercaseString length]) withTemplate:replaceString];
    return modifiedString;
}

+ (NSDate *)NSStringDateToNSDate:(NSString *)string
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d = [f dateFromString:string];
    return d;
}

+ (NSString *) readResouceFile:(NSString *)filename andExt:(NSString *)ext
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:ext];
    NSString *content = [NSString  stringWithContentsOfFile:path encoding: NSUTF8StringEncoding  error:NULL];
    return content;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    
    return newimage;
    
}

+(id)loadCustomViewByIndex:(NSUInteger)index{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    return [nib objectAtIndex:index];
}

+ (BOOL) isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults setBool:YES forKey:@"firstLaunch"];
        return YES;
        // App is being run for first time
    }else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults setBool:YES forKey:@"firstLaunch"];
        return YES;
        // App has been updated since last run
    }else{
       [defaults setBool:NO forKey:@"firstLaunch"];
    }
    return NO;
}

+ (BOOL) isFirstLoad2{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        return YES;
    }
    return NO;
}

+(id)getControllerByStoryboardId:(NSString *)storyboardId{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardId];
}

+(void)noGes:(UIViewController *)controller{
    
    if ([controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
               controller.navigationController.interactivePopGestureRecognizer.enabled = NO;
           }

}
+(void)ges:(UIViewController *)controller{
    
    if ([controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                 controller.navigationController.interactivePopGestureRecognizer.enabled = YES;
             }

}
@end
