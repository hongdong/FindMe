//
//  NSString+HD.m
//  FindMe
//
//  Created by mac on 14-7-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "NSString+HD.h"

@implementation NSString (HD)
-(BOOL)isOK{
    NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(temp.length==0)
    {
        return NO;
    }
    
    return YES;
}
@end
