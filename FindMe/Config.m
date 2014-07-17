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
    if (timeInterval>60*30) {
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
@end
