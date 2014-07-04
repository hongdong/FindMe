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
-(void)sendFace;

@end


@interface FacialView : UIView
{
	NSArray *_faces;
}

@property(nonatomic) id<FacialViewDelegate> delegate;

@property(strong, nonatomic, readonly) NSArray *faces;

-(void)loadFacialView:(int)page size:(CGSize)size;

@end
