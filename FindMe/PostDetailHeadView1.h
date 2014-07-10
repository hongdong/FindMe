//
//  PostDetailHeadView1.h
//  FindMe
//
//  Created by mac on 14-7-9.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@interface PostDetailHeadView1 : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reply;
@property (weak, nonatomic) IBOutlet UILabel *prise;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
-(void)setDataWithPost:(Post *) post;
@end
