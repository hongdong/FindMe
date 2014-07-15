//
//  FansCell.h
//  FindMe
//
//  Created by mac on 14-7-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MCSwipeTableViewCell.h"
#import "User.h"
@interface FansCell : MCSwipeTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (weak, nonatomic) IBOutlet UILabel *schoolLbl;
@property (weak, nonatomic) IBOutlet UILabel *departmentLbl;
@property (weak, nonatomic) IBOutlet UILabel *gradeLbl;

@property(strong,nonatomic) User *user;

@end
