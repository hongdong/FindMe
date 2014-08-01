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
#import "AFNetworking.h"
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
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    if ([[Config sharedConfig] coverPicUrl:nil]==nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/backstage/getPictureUrl.do",Host];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *coverpic = [responseObject objectForKey:@"coverpic"];
            if (coverpic!=nil) {
                [[Config sharedConfig] coverPicUrl:coverpic];
                [[NSNotificationCenter defaultCenter] postNotificationName:CoverChange object:nil];
            }else{
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
    }else{
       [self changeCover:nil]; 
    }
    
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
}

@end
