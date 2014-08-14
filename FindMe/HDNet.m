//
//  HDNet.m
//  FindMe
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HDNet.h"
#import "AFNetworking.h"
#import "EaseMob.h"
#import "User.h"
@implementation HDNet
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Host,URLString];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = responseObject[@"state"];
        if ([state isEqualToString:@"20004"]) {
            if ([[Config sharedConfig] isLogin]) {
                [HDNet freshSession:^{
                    if (success) {
                        success(operation,responseObject);
                    }
                }];
            }else{
                MJLog(@"请先登入");
            }
            return;
        }
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}
+ (void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Host,URLString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = responseObject[@"state"];
        if ([state isEqualToString:@"20004"]) {
            if ([[Config sharedConfig] isLogin]) {
                [HDNet freshSession:^{
                    if (success) {
                        success(operation,responseObject);
                    }
                }];
            }else{
                MJLog(@"请先登入");
            }
            return;
        }
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
       files:(NSDictionary *)files
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",Host,URLString];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString *key in files) {
                [formData appendPartWithFileURL:files[key] name:key error:nil];
            }
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *state = responseObject[@"state"];
            if ([state isEqualToString:@"20004"]) {
                if ([[Config sharedConfig] isLogin]) {
                    [HDNet freshSession:^{
                        if (success) {
                            success(operation,responseObject);
                        }
                    }];
                }else{
                    MJLog(@"请先登入");
                }
                return;
            }
            if (success) {
                success(operation,responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation,error);
            }
        }];

}



+ (void)isOauth:(NSString *) uid forType:(NSString *) type andBack:(NSString *) back handle:(void (^)(id responseObject,NSError *error))handle{
    NSDictionary *parameters = @{@"userOpenId"     : uid,
                                 @"userAuthType"   : type,
                                 @"equitNo"        : [[Config sharedConfig] getRegistrationID],
                                 @"osType"         : @"1",
                                 @"backLogin"      : back};
    [HDNet POST:@"/data/user/grant_user.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handle(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handle(nil,error);
    }];
    
}

+ (void)freshSession:(void (^)())complete{
    User *user = [User getUserFromNSUserDefaults];
    [HDNet isOauth:user.openId forType:user.userAuthType andBack:@"1" handle:^(id responseObject, NSError *error) {
        if (responseObject==nil) {
            return;
        }
        
        NSString *state = [responseObject objectForKey:@"state"];
        
        if ([state isEqualToString:@"20001"]) {
            MJLog(@"刷新session成功");
            [[Config sharedConfig] changeOnlineState:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES userInfo:@{@"isBack": @"1"}];
            if (complete) {
                complete();
            }
            
        }else if ([state isEqualToString:@"10001"]){
            MJLog(@"刷新session失败");
        }else if ([state isEqualToString:@"30001"]){
            MJLog(@"刷新session失败");
        }else{
            MJLog(@"刷新session失败");
        }
    }];
    
}

+ (void)EaseMobLoginWithUsername:(NSString *)username{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:@"123456"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
             
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
             options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
//             options.nickname = _user.userNickName;
             [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
             
         }else {
             
             
         }
     } onQueue:nil];
}
@end
