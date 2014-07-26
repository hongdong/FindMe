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
                                withText:@"你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好" delegate:nil];
}
- (IBAction)freshPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(coverViewRefreshPressed)]) {
        [self.delegate coverViewRefreshPressed];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CoverChange object:nil];
}

@end
