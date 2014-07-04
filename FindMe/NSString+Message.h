//
//  NSString+Message.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Message)

- (NSString *)stringByTrimingWhitespace;

- (NSUInteger)numberOfLines;

@end
