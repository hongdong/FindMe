#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (Config *)sharedConfig;

-(BOOL)isLogin;

-(BOOL)isOnline;

-(void)changeLoginState:(NSString *)isLogin;

-(void)changeOnlineState:(NSString *)isOnline;

-(void)saveRegistrationID:(NSString *)registrationID;

-(NSString *)getRegistrationID;

-(void)initBadge;

-(void)minusBadge;

-(void)cleanUser;

-(void)saveResignActiveDate;

-(BOOL)needFresh;

-(BOOL)friendNew:(NSString *)isnew;

-(BOOL)matchNew:(NSString *)isnew;

-(BOOL)fansNew:(NSString *)isnew;

-(BOOL)postNew:(NSString *)isnew;

-(NSString *)coverPicUrl:(NSString *)url;
@end
