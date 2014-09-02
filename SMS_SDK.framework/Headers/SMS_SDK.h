//
//  SMS_SDK.h
//  SMS_SDKDemo
//
//  Created by 严军 on 14-6-27.
//  Copyright (c) 2014年 严军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMS_UserInfo.h"
#import <MessageUI/MessageUI.h>
#import "SMS_SDKResultHanderDef.h"

/**
 * @brief 短信SDK 顶层类。
 */
@interface SMS_SDK : NSObject <MFMessageComposeViewControllerDelegate>

/**
 * @brief 注册应用，此方法在应用启动时调用一次并且只能在主线程调用。
 * @param appKey ,应用key,在shareSDK官网中注册的应用Key
 * @param appSecret 应用秘钥，在shareSDK官网中注册的应用秘钥
 */
+(void)registerApp:(NSString*)appKey withSecret:(NSString*)appSecret;

/**
 * @brief 获取appkey。
 * @return 返回appkey
 */
+(NSString*)appKey;

/**
 * @brief 获取appsecret。
 * @return 返回appsecret
 */
+(NSString*)appSecret;

/**
 * @brief 获取通讯录数据
 * @return 返回的数组里面存储的数据类型是SMS_AddressBook
 */
+(NSMutableArray*)addressBook;

/**
 * @brief 发送短信。
 * @param 要发送短信的号码
 * @param 要发送的信息
 */
+(void)sendSMS:(NSString*)tel AndMessage:(NSString*)msg;

/**
 * @brief 向服务端请求获取通讯录好友信息。
 * @param 调用参数 默认填choose=1
 * @param 请求结果回调block
 */
+(void)getAppContactFriends:(int)choose
                     result:(GetAppContactFriendsBlock)result;

/**
 * @brief 获取验证码。
 * @param 电话号码
 * @param 区号
 * @param 请求结果回调block
 */
+(void)getVerifyCodeByPhoneNumber:(NSString*) phone
                          AndZone:(NSString*) zone
                           result:(GetVerifyCodeBlock)result;

/**
 * @brief 提交验证码。
 * @param 验证码
 * @param 请求结果回调block
 */
+(void)commitVerifyCode:(NSString *)code
                 result:(CommitVerifyCodeBlock)result;
/**
 * @brief 请求所支持的区号。
 * @param 请求结果回调block
 */
+(void)getZone:(GetZoneBlock)result;

/**
 * @brief 提交用户资料。
 * @param 用户信息
 * @param 请求结果回调block
 */
+(void)submitUserInfo:(SMS_UserInfo*)user
               result:(SubmitUserInfoBlock)result;

/**
 * @brief 设置最近新好友条数。
 */
+(void)setLatelyFriendsCount:(int)count;

/**
 * @brief 显示最近新好友条数回调。
 * @param 设置结果回调block
 */
+(void)showFriendsBadge:(ShowNewFriendsCountBlock)result;

/**
 * @brief 是否启用通讯录好友功能
 * @param YES 代表启用 NO 代表不启用 默认为启用
 */
+(void)enableAppContactFriends:(BOOL)state;


@end

