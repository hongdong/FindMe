//
//  FindMeDetailViewController.m
//  FindMe
//
//  Created by mac on 14-7-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FindMeDetailViewController.h"
#import "FirstPageView.h"
#import "SecondPageView.h"
@interface FindMeDetailViewController ()

@end

@implementation FindMeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpScroll];
}
-(void)setUpScroll{
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 2;
    
    
    _scrollView.delegate = self;

    FirstPageView *firstView = [HDTool loadCustomViewByIndex:2];
    firstView.contentMode = UIViewContentModeScaleAspectFill;
    firstView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);;
    [_scrollView addSubview:firstView];

    SecondPageView *secondPageView = [HDTool loadCustomViewByIndex:3];
    secondPageView.contentMode = UIViewContentModeScaleAspectFill;
    secondPageView.frame = CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:secondPageView];
    
    CGSize pageScrollViewSize = _scrollView.frame.size;
    _scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * 2, 0);
}
- (IBAction)valueChanged:(id)sender {
    CGRect frame;
    frame.origin.x = _scrollView.frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = _scrollView.frame.size;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

#pragma delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((_scrollView.contentOffset.x + pageWidth/2)/pageWidth) ;
    _pageControl.currentPage = page;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
