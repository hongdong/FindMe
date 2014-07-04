/*!
 @header IChatManagerBuddy.h
 @abstract 为ChatManager提供添加好友,删除好友接受好友等操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */
#import <Foundation/Foundation.h>
#import "IChatManagerBase.h"

/*!
 @protocol
 @brief 本协议包括：添加好友,删除好友,接受好友请求等方法
 @discussion
 */
@protocol IChatManagerBuddy <IChatManagerBase>

@required

/*!
 @property
 @brief 获取好友列表(由EMBuddy对象组成)
 */
@property (nonatomic, strong, readonly) NSArray *buddyList;

/*!
 @property
 @brief 获取好友分组信息(由EMBuddyGroup对象组成)
 */
@property (nonatomic, strong, readonly) NSArray *buddyGroupList;

#pragma mark - add buddy

/*!
 @method
 @brief 申请添加某个用户为好友
 @discussion
 @param username 需要添加为好友的username
 @param nickname 添加好友后的昵称
 @param message  申请添加好友时的附带信息
 @param pError   错误信息
 @result 好友申请是否发送成功
 */
- (BOOL)addBuddy:(NSString *)username
    withNickname:(NSString *)nickname
         message:(NSString *)message
           error:(EMError **)pError __attribute__((deprecated("")));

/*!
 @method
 @brief 申请添加某个用户为好友
 @discussion
 @param username 需要添加为好友的username
 @param message  申请添加好友时的附带信息
 @param pError   错误信息
 @result 好友申请是否发送成功
 */
- (BOOL)addBuddy:(NSString *)username
         message:(NSString *)message
           error:(EMError **)pError;


/*!
 @method
 @brief 申请添加某个用户为好友,同时将该好友添加到分组中,好友与分组可以多对多
 @discussion
 @param username 需要添加为好友的username
 @param nickname 添加好友后的昵称
 @param message  申请添加好友时的附带信息
 @param groupNames  将好友添加到分组中(groupNames由NSString对象组成)
 @param pError   错误信息
 @result 好友申请是否发送成功
*/
- (BOOL)addBuddy:(NSString *)username
    withNickname:(NSString *)nickname
         message:(NSString *)message
        toGroups:(NSArray *)groupNames
           error:(EMError **)pError __attribute__((deprecated("")));

/*!
 @method
 @brief 申请添加某个用户为好友,同时将该好友添加到分组中,好友与分组可以多对多
 @discussion
 @param username 需要添加为好友的username
 @param message  申请添加好友时的附带信息
 @param groupNames  将好友添加到分组中(groupNames由NSString对象组成)
 @param pError   错误信息
 @result 好友申请是否发送成功
 */
- (BOOL)addBuddy:(NSString *)username
         message:(NSString *)message
        toGroups:(NSArray *)groupNames
           error:(EMError **)pError;

#pragma mark - remove buddy

/*!
 @method
 @brief 将某个用户从好友列表中移除
 @discussion
 @param username 需要移除的好友username
 @param removeFromRemote 是否将自己从对方好友列表中移除
 @param pError   错误信息
 @result 是否移除成功
 */
- (BOOL)removeBuddy:(NSString *)username
   removeFromRemote:(BOOL)removeFromRemote
              error:(EMError **)pError;

#pragma mark - accept buddy request

/*!
 @method
 @brief 接受某个好友发送的好友请求
 @discussion
 @param username 需要接受的好友username
 @param pError   错误信息
 @result 是否接受成功
 */
- (BOOL)acceptBuddyRequest:(NSString *)username
                     error:(EMError **)pError;

#pragma mark - reject buddy request

/*!
 @method
 @brief 拒绝某个好友发送的好友请求
 @discussion
 @param username 需要拒绝的好友username
 @param pError   错误信息
 @result 是否拒绝成功
 */
- (BOOL)rejectBuddyRequest:(NSString *)username
                    reason:(NSString *)reason
                     error:(EMError **)pError;

@end
