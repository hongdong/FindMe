//
//  NewPostViewController.h
//  FindMe
//
//  Created by mac on 14-7-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
#import "LXActionSheet.h"
@interface NewPostViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,LXActionSheetDelegate>
@property (weak, nonatomic) IBOutlet XHMessageTextView *content;
@property (weak, nonatomic) IBOutlet UIButton *changeKeyboard;
@property (weak, nonatomic) IBOutlet UIButton *addimage;

@end
