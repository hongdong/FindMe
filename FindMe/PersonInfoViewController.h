//
//  PersonInfoViewController.h
//  FindMe
//
//  Created by mac on 14-6-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"
#import "User.h"
@interface PersonInfoViewController : UIViewController<UIGestureRecognizerDelegate,LXActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIView *constellationView;
@property (weak, nonatomic) IBOutlet UIImageView *constellationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phtot;
@property (weak, nonatomic) IBOutlet UILabel *constellationLbl;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *photoView;
-(void)setConstellation:(NSIndexPath *)indexPath;
@end
