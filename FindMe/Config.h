#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (Config *)sharedConfig;

-(BOOL)isLogin;

-(void)changeLoginState:(NSString *)isLogin;

-(void)saveRegistrationID:(NSString *)registrationID;

-(NSString *)getRegistrationID;

-(void)initBadge;

-(void)minusBadge;
@end
