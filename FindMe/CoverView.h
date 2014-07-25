//
//  CoverView.h
//  FindMe
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoverViewDelegate <NSObject>

@required
-(void)coverViewRefreshPressed;

@end

@interface CoverView : UIView

@property(weak,nonatomic) id<CoverViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;

@property (weak, nonatomic) IBOutlet UIButton *helpBt;
@property (weak, nonatomic) IBOutlet UIButton *freshBt;

@end
