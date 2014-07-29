//
//  AgreeController.m
//  FindMe
//
//  Created by mac on 14-7-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "AgreeController.h"
#import "UIImageView+WebCache.h"
@interface AgreeController ()

@end

@implementation AgreeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ((UIScrollView *)self.view).backgroundColor = [UIColor whiteColor];
    [self.indicator startAnimating];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak __typeof(&*self)weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://114.215.115.33/upload/agreement/agreement.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.indicator stopAnimating];
        weakSelf.imageView.frame = CGRectMake(0, 0, 320, 1182);
        ((UIScrollView *)weakSelf.view).contentSize = CGSizeMake(0, 1182);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
