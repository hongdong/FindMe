//
//  NewPostViewController.h
//  FindMe
//
//  Created by mac on 14-7-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "XHMessageTextView.h"
#import "LXActionSheet.h"
@interface NewPostViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,LXActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet XHMessageTextView *content;
@property (weak, nonatomic) IBOutlet UIButton *addimage;
@property (weak, nonatomic) IBOutlet UILabel *remainTextNum;
@property (weak, nonatomic) IBOutlet UIButton *sendBt;

@end
