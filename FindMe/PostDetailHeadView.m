//
//  PostDetailHeadView.m
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PostDetailHeadView.h"
#import "UIImageView+WebCache.h"
@implementation PostDetailHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {


        
        UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:13.0f];
        UIColor* neutralColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        self.contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentLbl.textColor =  neutralColor;
        self.contentLbl.font = font;

    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];

}

-(void)setDataWithPost:(Post *) post{
    [self.image setImageWithURL:[NSURL URLWithString:post.postPhoto[0]]];
    
    self.contentLbl.text = post.postContent;
    
    self.replyLbl.text = [post.postMsgNumber stringValue];
    self.markLal.text = [post.postPraise stringValue];
}
@end
