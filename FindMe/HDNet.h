//
//  HDNet.h
//  FindMe
//
//  Created by mac on 14-8-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@interface HDNet : NSObject
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//+ (void)POST:(NSString *)URLString
//  parameters:(id)parameters
//       files:(NSDictionary *)files
//     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)login:(NSString *)userPhoneNumber
  andPassword:(NSString *)userPassword
      andBack:(NSString *)back
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)freshSession:(void (^)(BOOL isSuccess))complete;

+ (void)EaseMobLoginWithUsername:(NSString *)username;
@end
