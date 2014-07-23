//
//  CommentCell.h
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCoreLabel.h"
#import "Comment.h"
@interface CommentCell : UITableViewCell

@property (assign,nonatomic) NSInteger row;
@property (weak, nonatomic) IBOutlet UILabel *floorLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *hostLbl;
@property (weak, nonatomic) IBOutlet UIView *floorView;


@property(nonatomic,strong) HBCoreLabel *content;

@property(nonatomic,strong) Comment *comment;
//-(void)setData;
@end
