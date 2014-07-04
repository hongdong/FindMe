//
//  IEMFileMessageBody.h
//  EaseMobClientSDK
//
//  Created by Ji Fang on 5/23/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEMMessageBody.h"

typedef enum : NSUInteger {
    EMAttachmentDownloading,
    EMAttachmentDownloadSuccessed,
    EMAttachmentDownloadFailure
} EMAttachmentDownloadStatus;

@protocol IEMFileMessageBody <IEMMessageBody>

@required

/*!
 @property
 @brief 文件消息体的显示名
 */
@property (nonatomic, strong) NSString *displayName;

/*!
 @property
 @brief 文件消息体的本地文件路径
 */
@property (nonatomic, strong) NSString *localPath;

/*!
 @property
 @brief 文件消息体的服务器远程文件路径
 */
@property (nonatomic, strong) NSString *remotePath;

/*!
 @property
 @brief 远端文件的密钥, 下载时需要文件密钥和用户安全信息配合以下载远程文件
 */
@property (nonatomic, strong) NSString *secretKey;

/*!
 @property
 @brief 附件是否下载完成
 */
@property (nonatomic)EMAttachmentDownloadStatus attachmentDownloadStatus;

/*!
 @property
 @brief 文件消息体的文件长度, 以字节为单位
 */
@property (nonatomic) long long fileLength;

@end
