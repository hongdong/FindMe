//
//  DXFaceView.h
//  Share
//
//  Created by xieyajie on 14-2-27.
//  Copyright (c) 2014年 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FacialView.h"

@protocol DXFaceDelegate <FacialViewDelegate>

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;

@end


@interface DXFaceView : UIView <FacialViewDelegate>

@property (nonatomic, assign) id<DXFaceDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;

@end
