//
//  LoginView.m
//  FindMe
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupScrollView];
    if (IS_IPHONE_5) {
        self.frame = CGRectMake(0, 0, 320, 513);
    }else{
        self.frame = CGRectMake(0, 0, 320, 424);
    }
}
-(void)setupScrollView{
    NSArray *_photoList = @[[UIImage imageNamed:@"int1"],[UIImage imageNamed:@"int2"],[UIImage imageNamed:@"int3"],[UIImage imageNamed:@"int4"]];
    NSInteger pageCount = [_photoList count];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageCount;
    for(NSInteger i=0;i<pageCount;i++)
    {
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;
        UIImageView *pageView = [[UIImageView alloc] initWithImage:[_photoList objectAtIndex:i]];
        pageView.contentMode = UIViewContentModeScaleAspectFill;
        pageView.frame = frame;
        [_scrollView addSubview:pageView];
    }
    CGSize pageScrollViewSize = _scrollView.frame.size;
    _scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * _photoList.count, 0);
}

- (IBAction)valueChanged:(id)sender {
    // 更新Scroll View到正确的页面
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
    int page = floor((_scrollView.contentOffset.x + pageWidth/2)/pageWidth);
    _pageControl.currentPage = page;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
