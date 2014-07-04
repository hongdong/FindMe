//
//  Config.m
//  FindMe
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Config.h"

@implementation Config

+ (Config *)sharedConfig {
    static Config *_sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [[Config alloc] init];

    });
    
    return _sharedConfig;
}

-(BOOL)isLogin{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"isLogin"];
    if (value && [value isEqualToString:@"1"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)changeLoginState:(NSString *)isLogin{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"isLogin"];
    [setting setObject:isLogin forKey:@"isLogin"];
    [setting synchronize];
}

-(void)saveRegistrationID:(NSString *)registrationID{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"registrationID"];
    [setting setObject:registrationID forKey:@"registrationID"];
    [setting synchronize];
}

-(NSString *)getRegistrationID{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"registrationID"];
    if (value==nil) {
        return @"";
    }
    return value;
}
@end
