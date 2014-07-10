//
//  PostDetailHeadView.m
//  FindMe
//
//  Created by mac on 14-7-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PostDetailHeadView.h"
#import "UIImageView+WebCache.h"
#import "HtmlString.h"
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
        self.content = [[RCLabel alloc] initWithFrame:CGRectZero];
        self.content.lineBreakMode = NSLineBreakByCharWrapping;
        self.content.textColor =  neutralColor;
        self.content.font = font;

    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    [[self.contentView layer] setCornerRadius:5];
//    [[self.contentView layer] setBorderWidth:0.3];
//    
//    [[self.contentView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
}

-(void)setDataWithPost:(Post *) post{
    [self.image setImageWithURL:[NSURL URLWithString:post.postPhoto[0]]];
    
    NSString *transformStr = [HtmlString transformString:post.postContent];
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:transformStr];
    self.content.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [self.content optimumSize:YES];
    self.content.frame = CGRectMake(8, 8, 280, optimalSize.height);
    [self.contentView addSubview:self.content];
    
    self.replyLbl.text = [post.postMsgNumber stringValue];
    self.markLal.text = [post.postPraise stringValue];
}
@end
