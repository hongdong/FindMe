/*!
 @header EMChatServiceDefs.h
 @abstract ChatManager相关宏定义
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#ifndef EaseMobClientSDK_EMChatServiceDefs_h
#define EaseMobClientSDK_EMChatServiceDefs_h

#import "commonDefs.h"

/*!
 @enum
 @brief 聊天类型
 @constant eMessageBodyType_Text 文本类型
 @constant eMessageBodyType_Image 图片类型
 @constant eMessageBodyType_Video 视频类型
 @constant eMessageBodyType_Location 位置类型
 @constant eMessageBodyType_Voice 语音类型
 @constant eMessageBodyType_File 文件类型
 @constant eMessageBodyType_Command 命令类型
 */
typedef enum {
    eMessageBodyType_Text = 1,
    eMessageBodyType_Image,
    eMessageBodyType_Video,
    eMessageBodyType_Location,
    eMessageBodyType_Voice,
    eMessageBodyType_File,
    eMessageBodyType_Command
}MessageBodyType;

/*!
 @enum
 @brief 聊天消息发送状态
 @constant eMessageDeliveryState_Pending 待发送
 @constant eMessageDeliveryState_Delivering 正在发送
 @constant eMessageDeliveryState_Delivered 已发送, 成功
 @constant eMessageDeliveryState_Failure 已发送, 失败
 */
typedef enum {
    eMessageDeliveryState_Pending = 0, 
    eMessageDeliveryState_Delivering, 
    eMessageDeliveryState_Delivered, 
    eMessageDeliveryState_Failure
}MessageDeliveryState;

/*!
 @enum
 @brief 群组中的成员角色
 @constant eGroupMemberRole_Admin  群组管理员
 @constant eGroupMemberRole_Owner  群组所有者
 @constant eGroupMemberRole_Member 普通成员
 */
typedef enum {
    eGroupMemberRole_Admin = 0,
    eGroupMemberRole_Owner,
    eGroupMemberRole_Member
} EMGroupMemberRole;

/*!
 @enum
 @brief 退出群组的原因
 @constant eGroupLeaveReason_BeRemoved 被管理员移除出该群组
 @constant eGroupLeaveReason_UserLeave 用户主动退出该群组
 @constant eGroupLeaveReason_Destroyed 该群组被别人销毁
 */
typedef enum {
    eGroupLeaveReason_BeRemoved = 1,
    eGroupLeaveReason_UserLeave,
    eGroupLeaveReason_Destroyed
}EMGroupLeaveReason;

#endif
