//
//  Config.h
//  FindMe
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (Config *)sharedConfig;

-(BOOL)isLogin;

-(void)changeLoginState:(NSString *)isLogin;

-(void)saveRegistrationID:(NSString *)registrationID;

-(NSString *)getRegistrationID;

@end
