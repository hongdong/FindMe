//
//  PostDetailHeadView.h
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ClickImage.h"
@interface PostDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet ClickImage *image;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *markLal;
@property (weak, nonatomic) IBOutlet UILabel *replyLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

-(void)setDataWithPost:(Post *) post;
@end
