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
                [HDNet freshSession:^(BOOL isSuccess){
                    if (!isSuccess) {
                        return;
                    }
                    [HDNet GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            success(operation,responseObject);
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(operation,error);
                        }
                    }];

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
                [HDNet freshSession:^(BOOL isSuccess){
                    if (!isSuccess) {
                        return;
                    }
                    [HDNet POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (success) {
                            success(operation,responseObject);
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure) {
                            failure(operation,error);
                        }
                    }];

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

            if (success) {
                success(operation,responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation,error);
            }
        }];

}

+ (void)login:(NSString *)userPhoneNumber
  andPassword:(NSString *)userPassword
      andBack:(NSString *)back
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSDictionary *parameters = @{@"userPhoneNumber"     : userPhoneNumber,
                                 @"userPassword"   : userPassword,
                                 @"equitNo"        : [[Config sharedConfig] getRegistrationID],
                                 @"osType"         : @"1",
                                 @"backLogin"      : back};
    [HDNet POST:@"/data/user/login_user_phonenumber.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}



+ (void)freshSession:(void (^)(BOOL isSuccess))complete{
    User *user = [User getUserFromNSUserDefaults];
    [HDNet login:user.userPhoneNumber andPassword:user.userPassword andBack:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *state = [responseObject objectForKey:@"state"];
        if ([state isEqualToString:@"20001"]) {
            MJLog(@"刷新session成功");
            [[Config sharedConfig] changeOnlineState:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES userInfo:@{@"isBack": @"1"}];
            if (complete) {
                complete(YES);
            }
            
        }else if ([state isEqualToString:@"20002"]){
            MJLog(@"资料还未完善");
            if (complete) {
                complete(NO);
            }
        }else if ([state isEqualToString:@"10001"]){
            MJLog(@"刷新session失败");
            if (complete) {
                complete(NO);
            }
        }else if ([state isEqualToString:@"30001"]){
            MJLog(@"刷新session失败");
            if (complete) {
                complete(NO);
            }
        }else{
            MJLog(@"刷新session失败");
            if (complete) {
                complete(NO);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"刷新session失败");
        if (complete) {
            complete(NO);
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
