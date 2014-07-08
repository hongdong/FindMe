//
//  IdentifyViewController.h
//  FindMe
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentifyViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *schoolId;
@property (weak, nonatomic) IBOutlet UITextField *schoolPwd;

@end
