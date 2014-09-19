//
//  CoverView.m
//  FindMe
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "CoverView.h"
#import "PopoverView.h"
#import "UIView+Common.h"
#import "UIImageView+MJWebCache.h"

#import "User.h"
#import "NSDate+Category.h"
@interface CoverView(){
    PopoverView *_pv;
}

@end
@implementation CoverView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCover:) name:CoverChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshTime:) name:FreshTime object:nil];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    if (!IS_IPHONE_5) {
        self.frame = CGRectMake(0, 0, 320, 367+64);
    }else{
        self.frame = CGRectMake(0, 0, 320, 455+64);
    }
    
    if ([[Config sharedConfig] coverPicUrl:nil]==nil) {
        [HDNet GET:@"/backstage/getPictureUrl.do" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *coverpic = [responseObject objectForKey:@"coverpic"];
            if (coverpic!=nil) {
                [[Config sharedConfig] coverPicUrl:coverpic];
                [[NSNotificationCenter defaultCenter] postNotificationName:CoverChange object:nil];
            }else{
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            MJLog(@"请求失败");
        }];
    }else{
       [self changeCover:nil]; 
    }

}

-(void)freshTime:(NSNotification *)note{
    [self addTime];
}

-(void)addTime{
    if (self.flipView) {
        [self.flipView removeFromSuperview];
        self.flipView=nil;
    }
    self.flipView = [[JDDateCountdownFlipView alloc] initWithDayDigitCount:0 imageBundleName:nil];
    if (IS_IPHONE_5) {
        self.flipView.frame = CGRectMake(126, 406, 200, 80);
    }else{
        self.flipView.frame = CGRectMake(126, 406-88, 200, 80);
    }
    
    [self addSubview:self.flipView];
    NSDate *todayDate = [NSDate date];
    NSDate *torromoDate = [NSDate dateTomorrow];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat: @"HH:mm"];
    NSDate *girlTime = [dateFormatter1 dateFromString:@"10:00"];
    NSDate *boyTime = [dateFormatter1 dateFromString:@"21:00"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    User *user = [User getUserFromNSUserDefaults];
    if ([user.userSex isEqualToString:@"男"]) {
        if ([todayDate isLaterThanDate:boyTime]) {//已经过了今天的匹配时间了
            self.flipView.targetDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%ld-%ld-%ld 21:00",(long)torromoDate.year,(long)torromoDate.month,(long)torromoDate.day]];;
        }else{
            self.flipView.targetDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%ld-%ld-%ld 21:00",(long)todayDate.year,(long)todayDate.month,(long)todayDate.day]];;
        }
    }else if ([user.userSex isEqualToString:@"女"]){
        if ([todayDate isLaterThanDate:girlTime]) {//已经过了今天的匹配时间了
            self.flipView.targetDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%ld-%ld-%ld 10:00",(long)torromoDate.year,(long)torromoDate.month, (long)torromoDate.day]];;
        }else{
            self.flipView.targetDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%ld-%ld-%ld 10:00",(long)todayDate.year,(long)todayDate.month, (long)todayDate.day]];;
        }
    }else{

    }
//    [self.flipView updateValuesAnimated:YES];
//    [self.flipView start];
}

-(void)changeCover:(NSNotification *)note{
    [self.coverImg setImageURLStr:[[Config sharedConfig] coverPicUrl:nil] placeholder:[UIImage imageNamed:@"wordBg"]];
}

- (IBAction)helpPressed:(UIButton *)sender {
    _pv = [PopoverView showPopoverAtPoint:CGPointMake(sender.left+0.5*sender.width, sender.bottom)
                                  inView:self
                               withTitle:@"使用帮助"
                                 withText:@"---从此每天都将开启一段与来自星星的“TA”的奇妙邂逅。番迷君眉间心尘，几度思量只为你寻找最合适的那个Ta，与番迷君熟识越久匹配也就越精准。--交友规则：点击“like ”尝试认识一下“TA”，点击“pass”放弃这一次机会。双方都点击like才建立好友关系，有效防止“妖孽们”骚扰。（小贴士：个性化的照片墙能提高人气指数，更有机会偶遇你的缘分！）" delegate:nil];
}
- (IBAction)freshPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(coverViewRefreshPressed:)]) {
        [self.delegate coverViewRefreshPressed:sender];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CoverChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FreshTime object:nil];
}

@end
