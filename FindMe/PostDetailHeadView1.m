//
//  PostDetailHeadView1.m
//  FindMe
//
//  Created by mac on 14-7-9.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PostDetailHeadView1.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "UIColor+FlatUI.h"
@implementation PostDetailHeadView1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:13.0f];
    self.contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLbl.numberOfLines = 0;
    self.contentLbl.font = font;

}

-(void)setDataWithPost:(Post *) post{
    self.bgView.backgroundColor = [UIColor randomColor];
    self.contentLbl.text = post.postContent;
    NSDate *date = [[NSDateFormatter defaultDateFormatter] dateFromString:post.postReleaseTime];
    self.time.text = [date formattedDateDescription];
    self.prise.text = [post.postPraise stringValue];
    self.reply.text = [post.postMsgNumber stringValue];
}
@end
