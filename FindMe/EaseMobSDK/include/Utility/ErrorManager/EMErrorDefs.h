//
//  EMErrorDefs.h
//  EaseMobClientSDK
//
//  Created by Li Zhiping on 14-6-16.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#ifndef EaseMobClientSDK_EMErrorDefs_h
#define EaseMobClientSDK_EMErrorDefs_h


/*!
 *  SDK系统支持的errorCode 是从1001开始, 但是还是会返回HTTP Response Code, 如果遇到404, 501等ErrorType时, 需要和HTTP的网络请求返回的responseCode进行对比
 */
typedef enum : NSUInteger {
    EMErrorServerNotReachable = 1001,       //连接服务器失败(Ex. 手机客户端无网的时候, 会返回的error)
    EMErrorServerTimeout,                   //连接超时(Ex. 服务器连接超时会返回的error)
    EMErrorServerAuthenticationFailure,     //用户名或密码错误(Ex. 登录时,用户名密码错误会返回的error)
    EMErrorServerAPNSRegistrationFailure,   //APNS注册失败 (Ex. 登录时, APNS注册失败会返回的error)
    EMErrorServerDuplicatedAccount,         //注册失败(Ex. 注册时, 如果用户存在, 会返回的error)
    EMErrorServerGroupNotExist,             //操作的群组不存在(Ex. 删除或退出不存在的群组时, 会返回的error)
    EMErrorServerGroupHasAlreadyJoined,     //加入一个已加入的群组
    EMErrorServerInsufficientPrivilege,     //所执行操作的权限不够(Ex. 非管理员删除群成员时, 会返回的error)
    EMErrorServerOccupantNotExist,          //操作群组时, 人员不在此群组(Ex. remove群组成员时, 会返回的error)
    EMErrorServerTooManyOperations,         //短时间内多次发起同一异步请求(Ex. 频繁刷新群组列表, 会返回的error)
    
    EMErrorAttachmentNotFound,   //本地未找着附件
    EMErrorAttachmentDamaged,    //文件被损坏或被修改了
    EMErrorIllegalURI,           //URL非法(内部使用)
    EMErrorAudioPlayFailure,     //音频播放失败
    EMErrorAudioRecordFailure,   //录音失败
    EMErrorTooManyLoginRequest,  //正在登陆的时候又发起了登陆请求
    EMErrorTooManyLogoffRequest,  //正在登出的时候又发起了登出请求
    
    EMErrorFeatureNotImplemented         //还未实现的功能
} EMErrorType;

#endif
