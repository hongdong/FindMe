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

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
       files:(NSDictionary *)files
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)isOauth:(NSString *) uid
        forType:(NSString *) type
        andBack:(NSString *) back
         handle:(void (^)(id responseObject,NSError *error))handle;
@end
