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
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIView+Common.h"
#import "HYCircleLoadingView.h"
@interface FindMeDetailViewController (){
        NSMutableArray *myImageUrlArr;
        HYCircleLoadingView *_circleLoadingView;
}

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
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.user = [[User alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _circleLoadingView = [[HYCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc]initWithCustomView:_circleLoadingView];
    self.navigationItem.rightBarButtonItem = loadingItem;
    __weak __typeof(&*self)weakSelf = self;
    if (self.userId!=nil) {
        self.user._id = self.userId;
        [_circleLoadingView startAnimation];
        [self.user getUserInfo:^{
            [_circleLoadingView stopAnimation];
            [weakSelf setUpScroll];
            weakSelf.qianming.text = weakSelf.user.userSignature;
            [weakSelf setPhoto];
        }];
    }else{
        [self setUpScroll];
        self.qianming.text = self.user.userSignature;
        [self setPhoto];
    }

}

-(void)setPhoto{
    myImageUrlArr = self.user.userAlbum;
    if (myImageUrlArr==nil||[myImageUrlArr count]==0) {
        self.emptyLbl.hidden = NO;
        return;
    }
    int BtnW = 100;
    int BtnWS = 6;
    int BtnX = 4;
    
    int BtnH = 100;
    int BtnHS = 0;
    int BtnY = 0;
    
    self.emptyLbl.hidden = YES;
    
    int i = 0;
    for (i = 0; i < [myImageUrlArr count]; i++ ) {
        UIImageView * imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake( (BtnW+BtnWS) * (i%3) + BtnX , (BtnH+BtnHS) *(i/3) + BtnY, BtnW, BtnH );
        imageview.tag = 10000 + i;
        imageview.userInteractionEnabled = YES;
        // 内容模式
        imageview.clipsToBounds = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageview sd_setImageWithURL:[HDTool getSImage:[myImageUrlArr objectAtIndex:i]] placeholderImage: [UIImage imageNamed:@"defaultImage"] options:SDWebImageRetryFailed];
        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        
        [self.photoWallView addSubview: imageview];
    }
}

-(void)photoClick:(UITapGestureRecognizer *)imageTap
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity: [myImageUrlArr count]];
    for (int i = 0; i < [myImageUrlArr count]; i++) {
        // 替换为中等尺寸图片
        
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [myImageUrlArr objectAtIndex:i]];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:getImageStrUrl];
        UIImageView * imageView = (UIImageView *)[self.view viewWithTag:10000+i];
        photo.srcImageView = imageView;
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = (imageTap.view.tag - 10000); // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}


-(void)setUpScroll{
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 2;
    
    
    _scrollView.delegate = self;

    FirstPageView *firstView = [HDTool loadCustomViewByIndex:FirstPageViewIndex];
    firstView.contentMode = UIViewContentModeScaleAspectFill;
    firstView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [firstView setUser:self.user];
    [_scrollView addSubview:firstView];

    SecondPageView *secondPageView = [HDTool loadCustomViewByIndex:SecondPageViewIndex];
    secondPageView.contentMode = UIViewContentModeScaleAspectFill;
    secondPageView.frame = CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    secondPageView.nicknameLbl.text = self.user.userNickName;
    secondPageView.constellationLbl.text = self.user.userConstellation;
    secondPageView.school.text = [self.user getSchoolName];
    secondPageView.departmentLbl.text = [self.user getDepartmentName];
    secondPageView.gradeLbl.text = self.user.userGrade;
    
    
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
}



@end
