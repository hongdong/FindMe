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

-(BOOL)isOnline{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"isOnline"];
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

-(void)changeOnlineState:(NSString *)isOnline{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"isOnline"];
    [setting setObject:isOnline forKey:@"isOnline"];
    [setting synchronize];
}

-(void)saveRegistrationID:(NSString *)registrationID{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"registrationID"];
    [setting setObject:registrationID forKey:@"registrationID"];
    [setting synchronize];
}

-(void)saveResignActiveDate{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"resignActiveDate"];
    NSDate *resignActiveDate = [NSDate date];
    [setting setObject:resignActiveDate forKey:@"resignActiveDate"];
    [setting synchronize];
}

-(BOOL)needFresh{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSDate * resignActiveDate = [setting objectForKey:@"resignActiveDate"];
    NSTimeInterval timeInterval = -[resignActiveDate timeIntervalSinceNow];
    NSLog(@"%f",timeInterval);
    if (timeInterval>60*10) {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)getRegistrationID{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"registrationID"];
    if (value==nil) {
        return @"";
    }
    return value;
}

-(void)initBadge{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"badge"];
    [setting setObject:@"0" forKey:@"badge"];
    [setting synchronize];
}
-(void)minusBadge{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    int badgeNum = [[setting objectForKey:@"badge"] intValue]-1;
    NSString *badge = [[NSString alloc] initWithFormat:@"%d",badgeNum];
    [setting removeObjectForKey:@"badge"];
    [setting setObject:badge forKey:@"badge"];
    [setting synchronize];
}

-(void)cleanUser{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"user"];
}

-(BOOL)friendNew:(NSString *)isnew{
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (isnew!=nil) {
        [setting removeObjectForKey:@"friendNew"];
        [setting setObject:isnew forKey:@"friendNew"];
        [setting synchronize];
    }else{
        if ([[setting objectForKey:@"friendNew"] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)matchNew:(NSString *)isnew{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (isnew!=nil) {
        [setting removeObjectForKey:@"matchNew"];
        [setting setObject:isnew forKey:@"matchNew"];
        [setting synchronize];
    }else{
        if ([[setting objectForKey:@"matchNew"] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)fansNew:(NSString *)isnew{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (isnew!=nil) {
        [setting removeObjectForKey:@"fansNew"];
        [setting setObject:isnew forKey:@"fansNew"];
        [setting synchronize];
    }else{
        if ([[setting objectForKey:@"fansNew"] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)postNew:(NSString *)isnew{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (isnew!=nil) {
        [setting removeObjectForKey:@"postNew"];
        [setting setObject:isnew forKey:@"postNew"];
        [setting synchronize];
    }else{
        if ([[setting objectForKey:@"postNew"] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}
-(NSString *)coverPicUrl:(NSString *)url{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (url!=nil) {
        [setting removeObjectForKey:@"coverPicUrl"];
        [setting setObject:url forKey:@"coverPicUrl"];
        [setting synchronize];
    }else{
        return [setting objectForKey:@"coverPicUrl"];
    }
    return nil;
}
-(BOOL)launchGuide:(NSString *)guide{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    if (guide!=nil) {
        [setting removeObjectForKey:@"launchGuide"];
        [setting setObject:guide forKey:@"launchGuide"];
        [setting synchronize];
    }else{
        if (![[setting objectForKey:@"launchGuide"] isEqualToString:@"0"]) {
            return YES;
        }
    }
    return NO;
}
@end
