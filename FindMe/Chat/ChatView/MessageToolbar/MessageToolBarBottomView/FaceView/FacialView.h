//
//  FacialView.h
//  Share
//
//  Created by xieyajie on 11-8-16.
//  Copyright 2013 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacialViewDelegate

@optional
-(void)selectedFacialView:(NSString*)str;
-(void)deleteSelected:(NSString *)str;

@end


@interface FacialView : UIView
{

}

@property(nonatomic) id<FacialViewDelegate> delegate;



- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index;
@end
