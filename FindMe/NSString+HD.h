//
//  NSString+HD.h
//  FindMe
//
//  Created by mac on 14-7-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HD)
-(BOOL)isOK;
-(CGSize)getRealSize:(CGSize)size andFont:(UIFont*)font;
@end
