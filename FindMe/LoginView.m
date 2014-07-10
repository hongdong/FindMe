//
//  LoginView.m
//  FindMe
//
//  Created by mac on 14-7-4.
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

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupScrollView];

    
}

-(void)setupScrollView{
    _photoList = @[[UIImage imageNamed:@"int1"],[UIImage imageNamed:@"int2"],[UIImage imageNamed:@"int3"],[UIImage imageNamed:@"int4"]];
    NSInteger pageCount = [_photoList count];
    //    _pageScroll.frame = CGRectMake(0.0,
    //                                   0.0,
    //                                   320.0,
    //                                   400.0);
    //    _pageScroll.contentSize = CGSizeMake(0, 0);
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageCount;
    
    
    _pageScroll.delegate = self;
    for(NSInteger i=0;i<pageCount;i++)
    {
        CGRect frame;
        frame.origin.x = _pageScroll.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _pageScroll.frame.size;
        UIImageView *pageView = [[UIImageView alloc] initWithImage:[_photoList objectAtIndex:i]];
        pageView.contentMode = UIViewContentModeScaleAspectFill;
        pageView.frame = frame;
        [_pageScroll addSubview:pageView];
    }
    CGSize pageScrollViewSize = _pageScroll.frame.size;
    _pageScroll.contentSize = CGSizeMake(pageScrollViewSize.width * _photoList.count, 0);
}
- (IBAction)valueChange:(id)sender {
    // 更新Scroll View到正确的页面
    CGRect frame;
    frame.origin.x = _pageScroll.frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = _pageScroll.frame.size;
    [_pageScroll scrollRectToVisible:frame animated:YES];
}

- (void)moveToUpSide {
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         self.frame = CGRectMake(self.frame.origin.x,
                                                           -self.frame.size.height-64,
                                                           self.frame.size.width,
                                                           self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
}

- (IBAction)loginPressed:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(login:)]) {
        [_delegate login:sender];
    }
}



#pragma delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _pageScroll.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((_pageScroll.contentOffset.x + pageWidth/2)/pageWidth) ;
    _pageControl.currentPage = page;
    
}
@end
