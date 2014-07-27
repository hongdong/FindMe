//
//  LoginViewController.m
//  FindMe
//
//  Created by mac on 14-7-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController ()<UIScrollViewDelegate>{
    NSArray *_photoList;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setupScrollView{
    _photoList = @[[UIImage imageNamed:@"int1"],[UIImage imageNamed:@"int2"],[UIImage imageNamed:@"int3"],[UIImage imageNamed:@"int4"]];
    NSInteger pageCount = [_photoList count];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageCount;
    
    
    _srollView.delegate = self;
    for(NSInteger i=0;i<pageCount;i++)
    {
        CGRect frame;
        frame.origin.x = _srollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _srollView.frame.size;
        UIImageView *pageView = [[UIImageView alloc] initWithImage:[_photoList objectAtIndex:i]];
        pageView.contentMode = UIViewContentModeScaleAspectFill;
        pageView.frame = frame;
        [_srollView addSubview:pageView];
    }
    CGSize pageScrollViewSize = _srollView.frame.size;
    _srollView.contentSize = CGSizeMake(pageScrollViewSize.width * _photoList.count, 0);
}
- (IBAction)valueChange:(id)sender {
    // 更新Scroll View到正确的页面
    CGRect frame;
    frame.origin.x = _srollView.frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = _srollView.frame.size;
    [_srollView scrollRectToVisible:frame animated:YES];
}
- (void)moveToUpSide {
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                 -self.view.frame.size.height-64,
                                                 self.view.frame.size.width,
                                                 self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.view removeFromSuperview];
                     }];
    
}

#pragma delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _srollView.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((_srollView.contentOffset.x + pageWidth/2)/pageWidth) ;
    _pageControl.currentPage = page;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
