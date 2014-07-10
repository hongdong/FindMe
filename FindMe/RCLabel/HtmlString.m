//
//  HtmlString.m
//  TEST_16
//
//  Created by apple on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HtmlString.h"
#import <Foundation/NSObjCRuntime.h>
#import "RegexKitLite.h"

@implementation HtmlString

+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;

    //解析表情
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\]";//表情的正则表达式
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
    
//    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"expression.plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src ='%@'>",  i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:[imageHtml stringByAppendingString:@" "]];
            }
        }
    }
    return text;
}

@end
