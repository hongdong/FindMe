//
//  DetailViewController.h
//  FindMe
//
//  Created by mac on 14-7-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"
#import "QiniuSimpleUploader.h"
@interface DetailViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,LXActionSheetDelegate,QiniuUploadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *qianming;
@property (weak, nonatomic) IBOutlet UILabel *constellation;
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UIImageView *vUserImg;


@property (weak, nonatomic) IBOutlet UIView *nicknameView;
@property (weak, nonatomic) IBOutlet UIView *qianmingView;
@end
