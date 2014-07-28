//
//  FirstPageView.m
//  FindMe
//
//  Created by mac on 14-7-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FirstPageView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Common.h"
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

-(void)setUser:(User *)user{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:user.userPhoto] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    
    CGSize size = CGSizeMake(320,2000);
    CGSize realsize = [user.userRealName sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.realNameLbl = [[UILabel alloc] init];
    self.realNameLbl.bounds = (CGRect){{0,0},realsize};
    self.realNameLbl.center = CGPointMake(self.centerX, self.photo.bottom+16);
    self.realNameLbl.textColor = [UIColor whiteColor];
    self.realNameLbl.font = [UIFont systemFontOfSize:16.0f];
    self.realNameLbl.text = user.userRealName;
    [self addSubview:self.realNameLbl];
    
    self.sex = [[UIImageView alloc] init];
    self.sex.bounds = (CGRect){{0,0},{16,16}};
    self.sex.center = CGPointMake(self.realNameLbl.right+10, self.photo.bottom+16);
    if ([user.userSex isEqualToString:@"男"]) {
        self.sex.image = [UIImage imageNamed:@"boy"];
    }else{
        self.sex.image = [UIImage imageNamed:@"girl"];
    }
    [self addSubview:self.sex];
    if ([user.userAuth integerValue]==1) {
        self.vUserImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VUser"]];
        self.vUserImg.bounds = (CGRect){{0,0},{16,16}};
        self.vUserImg.center = CGPointMake(self.sex.right+10, self.photo.bottom+16);
        [self addSubview:self.vUserImg];
    }
}
@end
