//
//  HDCodeView.m
//  FindMe
//
//  Created by mac on 14-7-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HDCodeView.h"

@implementation HDCodeView
@synthesize blockAfterDismiss = _blockAfterDismiss;

+(id)HDCodeViewWithAfterDismiss:(XYInputViewBlock)block andUrl:(NSString *)url{
    return [[HDCodeView alloc] initWithAfterDismiss:block andUrl:url];
}

-(id)initWithAfterDismiss:(XYInputViewBlock)block andUrl:(NSString *)url{
    self = [self init];
    if(self)
    {
        self.blockAfterDismiss = block;
        self.codeUrl = url;
    }
    return self;
}

-(void)show{
    [[XYAlertViewManager sharedAlertViewManager] show:self];
}
-(void)dismiss:(int)buttonIndex{
    [[XYAlertViewManager sharedAlertViewManager] dismiss:self button:buttonIndex];
}
@end
