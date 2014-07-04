/*!
 @header EMChatManagerLoginDelegate.h
 @abstract 关于ChatManager中登陆相关功能的异步回调
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

@class EMError;

/*!
 @protocol
 @brief 本协议包括：登录成功的回调、登录失败的回调、修改密码的回调、账号在其它设置上登录时的回调操作
 @discussion
 */
@protocol EMChatManagerLoginDelegate <EMChatManagerDelegateBase>

@optional

/*!
 @method
 @brief 用户登录后的回调
 @discussion
 @param loginInfo 登录的用户信息
 @param error        错误信息
 @result
 */
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error;

/*!
 @method
 @brief 用户注销后的回调
 @discussion
 @param error        错误信息
 @result
 */
- (void)didLogoffWithError:(EMError *)error;

/*!
 @method
 @brief 当前登录账号在其它设备登录时的通知回调
 @discussion
 @result
 */
- (void)didLoginFromOtherDevice;

/*!
 @method
 @brief 当前登陆用户掉线重连后发生的通知回调
 @discussion
 @result
 */
- (void)didReconnect;

/*!
 @method
 @brief 成功注册新用户后的回调
 @discussion
 @result
 */
- (void)didRegisterNewAccount:(NSString *)username password:(NSString *)password error:(EMError *)error;

@end
