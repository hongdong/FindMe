//
//  HDCodeView.h
//  FindMe
//
//  Created by mac on 14-7-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAlertViewManager.h"
typedef void (^XYInputViewBlock)(int buttonIndex, NSString *text);
@interface HDCodeView : NSObject

@property (copy, nonatomic) NSString *codeUrl;
@property (copy, nonatomic) XYInputViewBlock blockAfterDismiss;

+(id)HDCodeViewWithAfterDismiss:(XYInputViewBlock)block andUrl:(NSString *)url;

-(id)initWithAfterDismiss:(XYInputViewBlock)block andUrl:(NSString *)url;

-(void)show;
-(void)dismiss:(int)buttonIndex;
@end
