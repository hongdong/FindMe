//
//  HDNet.m
//  FindMe
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HDNet.h"
#import "AFNetworking.h"
@implementation HDNet
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Host,URLString];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
@end
