//
//  Comment.m
//  FindMe
//
//  Created by mac on 14-7-3.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Comment.h"

@implementation Comment
+(NSCache*)shareCacheForComment;
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        cache.totalCostLimit=0.1*1024*1024;
    });
    return cache;
}
-(MatchParser*)getMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@MatchParser",self._id];
        MatchParser *parser=[[self.class shareCacheForComment] objectForKey:key];
        if (parser) {
            _match=parser;
            parser.data=self;
            return parser;
        }else{
            parser=[self createMatch:280];
            if (parser) {
                [[self.class shareCacheForComment]  setObject:parser forKey:key];
            }
            return parser;
        }
    }
}
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link{
    
}
-(MatchParser*)getMatch:(void(^)(MatchParser *parser,id data))complete data:(id)data
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@MatchParser",self._id];
        MatchParser *parser=[[self.class shareCacheForComment] objectForKey:key];
        if (parser) {
            _match=parser;
            parser.data=self;
            return parser;
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                MatchParser*parser=[self createMatch:280];
                if (parser) {
                    _match=parser;
                    [[self.class shareCacheForComment]  setObject:parser forKey:key];
                    if (complete) {
                        complete(parser,data);
                    }
                }
            });
            return nil;
        }
    }
}

-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@MatchParser",self._id];
        MatchParser *parser=[[self.class shareCacheForComment] objectForKey:key];
        if (parser) {
            _match=parser;
            parser.data=self;
            
        }else{
            MatchParser* parser=[self createMatch:280];
            if (parser) {
                [[self.class shareCacheForComment]  setObject:parser forKey:key];
            }
        }
    }
}

-(void)setMatch:(MatchParser *)match
{
    _match=match;
}

-(MatchParser*)createMatch:(float)width
{
    MatchParser * parser=[[MatchParser alloc]init];
    parser.keyWorkColor=[UIColor blueColor];
    parser.width=width;
    parser.numberOfLimitLines=5;
    [parser match:self.postMsgContent];
    _match=parser;
    parser.data=self;
    return parser;
}
@end
