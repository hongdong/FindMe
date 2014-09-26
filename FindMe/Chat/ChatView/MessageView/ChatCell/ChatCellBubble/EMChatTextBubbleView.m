/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMChatTextBubbleView.h"
#import "NSString+HD.h"

NSString *const kRouterEventTextBubbleTapEventName = @"kRouterEventTextBubbleTapEventName";

@interface EMChatTextBubbleView ()

@end

@implementation EMChatTextBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        _textLabel.isNeedAtAndPoundSign = YES;
        _textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _textLabel.customEmojiPlistName = @"expression.plist";
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.multipleTouchEnabled = NO;
        [self addSubview:_textLabel];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width -= BUBBLE_ARROW_WIDTH;
    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
    if (self.model.isSender) {
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.textLabel setFrame:frame];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    
    CGSize retSize= [_textLabel preferredSizeWithMaxWidth:TEXTLABEL_MAX_WIDTH];
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height;
    }
    
    return CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, height);
    
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    [_textLabel setEmojiText:self.model.content];
//    _textLabel.text = self.model.content;
//    if (model.isSender) {
//        _textLabel.textColor = [UIColor whiteColor];
//    }
}

#pragma mark - public

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    
    MLEmojiLabel *label = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    label.isNeedAtAndPoundSign = YES;
    label.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    label.customEmojiPlistName = @"expression.plist";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    label.multipleTouchEnabled = NO;
    [label setEmojiText:object.content];
    CGSize size;
    size = [label preferredSizeWithMaxWidth:TEXTLABEL_MAX_WIDTH];
    return 2 * BUBBLE_VIEW_PADDING + size.height;
}

+(UIFont *)textLabelFont
{
    return [UIFont systemFontOfSize:LABEL_FONT_SIZE];
}

+(NSLineBreakMode)textLabelLineBreakModel
{
    return NSLineBreakByCharWrapping;
}


@end
