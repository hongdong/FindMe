//
//  PostDetailHeadView.h
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "Post.h"
@interface PostDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *markLal;
@property (weak, nonatomic) IBOutlet UILabel *replyLbl;

@property(nonatomic,strong) RCLabel *content;

-(void)setDataWithPost:(Post *) post;
@end
