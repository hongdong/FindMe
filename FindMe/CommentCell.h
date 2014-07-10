//
//  CommentCell.h
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "Comment.h"
@interface CommentCell : UITableViewCell

@property (assign,nonatomic) NSInteger row;
@property (weak, nonatomic) IBOutlet UILabel *floorLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *hostLbl;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property(nonatomic,strong) RCLabel *content;

@property(nonatomic,strong) Comment *comment;
//-(void)setData;
+ (CGFloat)getHeight:(Comment *)comment;
@end
