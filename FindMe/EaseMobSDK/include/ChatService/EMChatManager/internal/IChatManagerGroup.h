/*!
 @header IChatManagerGroup.h
 @abstract 为ChatManager提供群组的基础操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"

@class EMGroup;
@class EMError;

/*!
 @protocol
 @brief 本协议包括：创建, 销毁, 加入, 退出等群组操作
 @discussion 所有不带Block回调的异步方法, 需要监听回调时, 需要先将要接受回调的对象注册到delegate中, 示例代码如下:
            [[[EaseMob sharedInstance] chatManager] addDelegate:self delegateQueue:dispatch_get_main_queue()]
 */
@protocol IChatManagerGroup <IChatManagerBase>

@required

#pragma mark - properties

/*!
 @property
 @brief 所加入和创建的群组列表, 群组对象
 */
@property (nonatomic, strong, readonly) NSArray *groupList;

#pragma mark - create private group

/*!
 @method
 @brief 创建一个私有群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param pError         错误信息
 @result 创建的群组对象, 失败返回nil
 */
- (EMGroup *)createPrivateGroupWithSubject:(NSString *)subject
                               description:(NSString *)description
                                  invitees:(NSArray *)invitees
                     initialWelcomeMessage:(NSString *)welcomeMessage
                                     error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 创建一个私有群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @discussion
        函数执行完, 回调group:didCreateWithError:会被触发
 */
- (void)asyncCreatePrivateGroupWithSubject:(NSString *)subject
                               description:(NSString *)description
                                  invitees:(NSArray *)invitees
                     initialWelcomeMessage:(NSString *)welcomeMessage;

/*!
 @method
 @brief 异步方法, 创建一个私有群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 */
- (void)asyncCreatePrivateGroupWithSubject:(NSString *)subject
                               description:(NSString *)description
                                  invitees:(NSArray *)invitees
                     initialWelcomeMessage:(NSString *)welcomeMessage
                                completion:(void (^)(EMGroup *group,
                                                     EMError *error))completion
                                   onQueue:(dispatch_queue_t)aQueue;

#pragma mark - create public group

/*!
 @method
 @brief 创建一个公开群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param pError         错误信息
 @result 创建的群组对象, 失败返回nil
 */
- (EMGroup *)createPublicGroupWithSubject:(NSString *)subject
                              description:(NSString *)description
                                 invitees:(NSArray *)invitees
                    initialWelcomeMessage:(NSString *)welcomeMessage
                                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 创建一个公开群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @discussion
        函数执行完, 回调group:didCreateWithError:会被触发
 */
- (void)asyncCreatePublicGroupWithSubject:(NSString *)subject
                              description:(NSString *)description
                                 invitees:(NSArray *)invitees
                    initialWelcomeMessage:(NSString *)welcomeMessage;

/*!
 @method
 @brief 异步方法, 创建一个公开群组
 @param subject        主题
 @param description    说明信息
 @param invitees       初始群组成员的用户名列表
 @param welcomeMessage 对初始群组成员的邀请信息
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 */
- (void)asyncCreatePublicGroupWithSubject:(NSString *)subject
                              description:(NSString *)description
                                 invitees:(NSArray *)invitees
                    initialWelcomeMessage:(NSString *)welcomeMessage
                               completion:(void (^)(EMGroup *group,
                                                    EMError *error))completion
                                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - leave group

/*!
 @method
 @brief 退出群组
 @param groupId  群组ID
 @param pError   错误信息
 @result 退出的群组对象, 失败返回nil
 */
- (EMGroup *)leaveGroup:(NSString *)groupId
                  error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 退出群组
 @param groupId  群组ID
 @discussion
        函数执行完, 回调group:didLeave:error:会被触发
 */
- (void)asyncLeaveGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 退出群组
 @param groupId  群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncLeaveGroup:(NSString *)groupId
             completion:(void (^)(EMGroup *group,
                                  EMGroupLeaveReason reason,
                                  EMError *error))completion
                onQueue:(dispatch_queue_t)aQueue;

#pragma mark - add occupants

/*!
 @method
 @brief 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @param pError         错误信息
 @result 返回群组对象, 失败返回空
 */
- (EMGroup *)addOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
                    error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @discussion
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage;

/*!
 @method
 @brief 异步方法, 邀请用户加入群组
 @param occupants      被邀请的用户名列表
 @param groupId        群组ID
 @param welcomeMessage 欢迎信息
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 */
- (void)asyncAddOccupants:(NSArray *)occupants
                  toGroup:(NSString *)groupId
           welcomeMessage:(NSString *)welcomeMessage
               completion:(void (^)(NSArray *occupants,
                                    EMGroup *group,
                                    NSString *welcomeMessage,
                                    EMError *error))completion
                  onQueue:(dispatch_queue_t)aQueue;

#pragma mark - remove occupants

/*!
 @method
 @brief 将某些人请出群组
 @param occupants 要请出群组的人的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
    此操作需要admin/owner权限
 */
- (EMGroup *)removeOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                       error:(EMError *__autoreleasing *)pError;

/*!
 @method
 @brief 异步方法, 将某些人请出群组
 @param occupants 要请出群组的人的用户名列表
 @param groupId   群组ID
 @discussion
        此操作需要admin/owner权限.
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人请出群组
 @param occupants  要请出群组的人的用户名列表
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncRemoveOccupants:(NSArray *)occupants
                   fromGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue;

#pragma mark - block occupants

/*!
 @method
 @brief 将某些人加入群组黑名单
 @param occupants 要加入黑名单的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
 */
- (EMGroup *)blockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 将某些人加入群组黑名单
 @param occupants 要加入黑名单的用户名列表
 @param groupId   群组ID
 @discussion
        此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人加入群组黑名单
 @param occupants   要加入黑名单的用户名列表
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
        此操作需要admin/owner权限, 被加入黑名单的人, 不会再被允许进入群组
 */
- (void)asyncBlockOccupants:(NSArray *)occupants
                  fromGroup:(NSString *)groupId
                 completion:(void (^)(EMGroup *group,
                                      EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - unblock occupants

/*!
 @method
 @brief 将某些人从群组黑名单中解除
 @param occupants 要从黑名单中移除的用户名列表
 @param groupId   群组ID
 @param pError    错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
 */
- (EMGroup *)unblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                        error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 将某些人从群组黑名单中解除
 @param occupants 要从黑名单中移除的用户名列表
 @param groupId   群组ID
 @discussion
        此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 将某些人从群组黑名单中解除
 @param occupants   要从黑名单中移除的用户名列表
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
        此操作需要admin/owner权限, 从黑名单中移除后, 可以再次进入群组
 */
- (void)asyncUnblockOccupants:(NSArray *)occupants
                     forGroup:(NSString *)groupId
                   completion:(void (^)(EMGroup *group,
                                        EMError *error))completion
                      onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change group subject

/*!
 @method
 @brief 更改群组主题
 @param subject  主题
 @param groupId  群组ID
 @param pError   错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限
 */
- (EMGroup *)changeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                          error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改群组主题
 @param subject  主题
 @param groupId  群组ID
 @discussion
        此操作需要admin/owner权限
        函数执行完, groupDidUpdateInfo:error:回调会被触发
 */
- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改群组主题
 @param subject    主题
 @param groupId    群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncChangeGroupSubject:(NSString *)subject
                       forGroup:(NSString *)groupId
                     completion:(void (^)(EMGroup *group,
                                          EMError *error))completion
                        onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change group description

/*!
 @method
 @brief 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @param pError         错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限
 */
- (EMGroup *)changeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                         error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @discussion
        此操作需要admin/owner权限.
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改群组说明信息
 @param newDescription 说明信息
 @param groupId        群组ID
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncChangeDescription:(NSString *)newDescription
                      forGroup:(NSString *)groupId
                    completion:(void (^)(EMGroup *group,
                                         EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change group password

/*!
 @method
 @brief 更改群组密码
 @param newPassword 新密码
 @param groupId  群组ID
 @param pError      错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限
 */
- (EMGroup *)changePassword:(NSString *)newPassword
                   forGroup:(NSString *)groupId
                      error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改群组密码
 @param newPassword 新密码
 @param groupId     群组ID
 @discussion
        此操作需要admin/owner权限.
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncChangePassword:(NSString *)newPassword
                   forGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改群组密码
 @param newPassword 新密码
 @param groupId     群组ID
 @param completion  消息完成后的回调
 @param aQueue      回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncChangePassword:(NSString *)newPassword
                   forGroup:(NSString *)groupId
                 completion:(void (^)(EMGroup *group, EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - change occupants' affiliation

/*!
 @method
 @brief 更改成员的权限级别
 @param newAffiliation 新的级别
 @param occupants      被更改成员的用户名列表
 @param groupId        群组ID
 @param pError         错误信息
 @result 返回群组对象
 @discussion
        此操作需要admin/owner权限
 */
- (EMGroup *)changeAffiliation:(EMGroupMemberRole)newAffiliation
                  forOccupants:(NSArray *)occupants
                       inGroup:(NSString *)groupId
                         error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 更改成员的权限级别
 @param newAffiliation 新的级别
 @param occupants      被更改成员的用户名列表
 @param groupId        群组ID
 @discussion
        此操作需要admin/owner权限.
        函数执行完, 回调groupDidUpdateInfo:error:会被触发
 */
- (void)asyncChangeAffiliation:(EMGroupMemberRole)newAffiliation
                  forOccupants:(NSArray *)occupants
                       inGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 更改成员的权限级别
 @param newAffiliation 新的级别
 @param occupants      被更改成员的用户名列表
 @param groupId        群组ID
 @param completion     消息完成后的回调
 @param aQueue         回调block时的线程
 @discussion
        此操作需要admin/owner权限
 */
- (void)asyncChangeAffiliation:(EMGroupMemberRole)newAffiliation
                  forOccupants:(NSArray *)occupants
                       inGroup:(NSString *)groupId
                    completion:(void (^)(EMGroup *group,
                                         EMError *error))completion
                       onQueue:(dispatch_queue_t)aQueue;

#pragma mark - accept invitation

/*!
 @method
 @brief 接受并加入群组
 @param groupId 所接受的群组ID
 @param pError  错误信息
 @result 返回所加入的群组对象
 */
- (EMGroup *)acceptInvitationFromGroup:(NSString *)groupId
                                 error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 接受并加入群组
 @param groupId 所接受的群组ID
 @discussion
        函数执行后, didAcceptInvitationFromGroup:error:回调会被触发
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 接受并加入群组
 @param groupId    所接受的群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调执行时的线程
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)groupId
                            completion:(void (^)(EMGroup *group,
                                                 EMError *error))completion
                               onQueue:(dispatch_queue_t)aQueue;

#pragma mark - reject invitation

/*!
 @method
 @brief 拒绝一个加入群组的邀请
 @param groupId  被拒绝的群组ID
 @param username 被拒绝的人
 @param reason   拒绝理由
 */
- (void)rejectInvitationForGroup:(NSString *)groupId
                       toInviter:(NSString *)username
                          reason:(NSString *)reason;

#pragma mark - fetch group info

/*!
 @method
 @brief 获取群组信息
 @param groupId 群组ID
 @param pError  错误信息
 @result 所获取的群组对象
 */
- (EMGroup *)fetchGroupInfo:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取群组信息
 @param groupId 群组ID
 @discussion
        执行后, 回调didFetchGroupInfo:error会被触发
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 获取群组信息
 @param groupId 群组ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchGroupInfo:(NSString *)groupId
                 completion:(void (^)(EMGroup *group,
                                      EMError *error))completion
                    onQueue:(dispatch_queue_t)aQueue;

#pragma mark - fetch all privte groups

/*!
 @method
 @brief 获取所有私有群组
 @param pError 错误信息
 @return 获取的所有私有群组列表
 */
- (NSArray *)fetchAllPrivateGroupsWithError:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取所有私有群组
 @discussion
        执行后, 回调didUpdateGroupList:error会被触发
 */
- (void)asyncFetchAllPrivateGroups;

/*!
 @method
 @brief 异步方法, 获取所有私有群组
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchAllPrivateGroupsWithCompletion:(void (^)(NSArray *groups,
                                                           EMError *error))completion
                                         onQueue:(dispatch_queue_t)aQueue;

#pragma mark - fetch all public groups

/*!
 @method
 @brief 获取所有公开群组
 @param pError 错误信息
 @return 获取的所有群组列表
 */
- (NSArray *)fetchAllPublicGroupsWithError:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 获取所有公开群组
 @discussion
        执行后, 回调didFetchAllPublicGroups:error:会被触发
 */
- (void)asyncFetchAllPublicGroups;

/*!
 @method
 @brief 异步方法, 获取所有公开群组
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncFetchAllPublicGroupsWithCompletion:(void (^)(NSArray *groups,
                                                          EMError *error))completion
                                        onQueue:(dispatch_queue_t)aQueue;

#pragma mark - join public group

/*!
 @method
 @brief 加入一个公开群组
 @param groupId 公开群组的ID
 @param pError  错误信息
 @result 所加入的公开群组
 */
- (EMGroup *)joinPublicGroup:(NSString *)groupId error:(EMError **)pError;

/*!
 @method
 @brief 异步方法, 加入一个公开群组
 @param groupId 公开群组的ID
 @discussion
        执行后, 回调didJoinPublicGroup:error:会被触发
 */
- (void)asyncJoinPublicGroup:(NSString *)groupId;

/*!
 @method
 @brief 异步方法, 加入一个公开群组
 @param groupId    公开群组的ID
 @param completion 消息完成后的回调
 @param aQueue     回调block时的线程
 */
- (void)asyncJoinPublicGroup:(NSString *)groupId
                  completion:(void (^)(EMGroup *group,
                                       EMError *error))completion
                     onQueue:(dispatch_queue_t)aQueue;

/**
 *  根据groundId搜索公开群(同步方法)
 *
 *  @param groundId 群组id
 *  @param error    搜索失败的错误
 *
 *  @return 搜索到的群组
 */
- (EMGroup *)searchPublicGroupWithGroupId:(NSString *)groundId error:(EMError **)error;

/**
 *  根据groundId搜索公开群(异步方法)
 *
 *  @param groundId   群组id
 *  @param completion block
 */
- (void)asyncSearchPublicGroupWithGroupId:(NSString *)groundId
                               completion:(void (^)(EMGroup *group,
                                                    EMError *error))completion;

@end
