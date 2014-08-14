//
//  AlbumViewController.h
//  FindMe
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"
#import "QiniuSimpleUploader.h"
@interface AlbumViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,LXActionSheetDelegate,QiniuUploadDelegate>
@end
