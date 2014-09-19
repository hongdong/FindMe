//
//  FacialView.m
//  Share
//
//  Created by xieyajie on 11-8-16.
//  Copyright 2013 Share. All rights reserved.
//

#import "FacialView.h"
#import "Emoji.h"
#define NumPerLine 7
#define Lines    3
#define FaceSize  30
/*
 ** 两边边缘间隔
 */
#define EdgeDistance 20
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 3
@interface FacialView ()

@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {

        // 水平间隔
        CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-NumPerLine*FaceSize -2*EdgeDistance)/(NumPerLine-1);
        // 上下垂直间隔
        CGFloat verticalInterval = (CGRectGetHeight(self.bounds)-2*EdgeInterVal -Lines*FaceSize)/(Lines-1);
        
        for (int i = 0; i<Lines; i++)
        {
            for (int x = 0;x<NumPerLine;x++)
            {
                UIButton *expressionButton =[UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:expressionButton];
                [expressionButton setFrame:CGRectMake(x*FaceSize+EdgeDistance+x*horizontalInterval,
                                                      i*FaceSize +i*verticalInterval+EdgeInterVal,
                                                      FaceSize,
                                                      FaceSize)];
                
                if (i*7+x+1 ==21) {
                    [expressionButton setBackgroundImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7@2x.png"]
                                                forState:UIControlStateNormal];
                    expressionButton.tag = 0;
                    
                }else{
                    NSString *imageStr = [NSString stringWithFormat:@"Expression_%d@2x.png",index*20+i*7+x+1];
                    [expressionButton setBackgroundImage:[UIImage imageNamed:imageStr]
                                                forState:UIControlStateNormal];
                    expressionButton.tag = 20*index+i*7+x+1;
                }
                [expressionButton addTarget:self
                                     action:@selector(selected:)
                           forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return self;
}

-(void)selected:(UIButton*)button
{
  
    NSString *faceName;
    BOOL isDelete;
    if (button.tag ==0){
        faceName = nil;
        isDelete = YES;
        [_delegate deleteSelected:nil];
    }else{
        NSString *expressstring = [NSString stringWithFormat:@"Expression_%d@2x.png",button.tag];
        NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];//得到文件路径
        NSDictionary *plistDic = [[NSDictionary  alloc] initWithContentsOfFile:plistStr];
        for (NSString *key in [plistDic allKeys]) {
            if ([[plistDic objectForKey:key] isEqualToString:expressstring]) {
                faceName = key;
            }
        }
        isDelete = NO;
        [_delegate selectedFacialView:faceName];
    }
    

}


@end
