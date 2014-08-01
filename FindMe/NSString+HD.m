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
-(CGSize)getRealSize:(CGSize)size andFont:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize textSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    textSize.height = ceil(textSize.height);
    textSize.width = ceil(textSize.width);
    return textSize;
}
@end
