//
//  FirstPageView.m
//  FindMe
//
//  Created by mac on 14-7-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FirstPageView.h"

@implementation FirstPageView

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
    self.photo.layer.cornerRadius = 40;
    self.photo.layer.masksToBounds = YES;
}

@end
