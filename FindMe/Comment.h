//
//  Comment.h
//  FindMe
//
//  Created by mac on 14-7-3.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchParser.h"
@interface Comment : NSObject<MatchParserDelegate>{
    __weak MatchParser* _match;
}

@property (strong,nonatomic) NSString *postMsgTime;
@property (strong,nonatomic) NSString *postMsgContent;
@property (strong,nonatomic) NSString *_id;
@property (strong,nonatomic) NSString *postMsgUser;


@property(nonatomic,weak,getter =getMatch) MatchParser * match;


-(MatchParser*)createMatch:(float)width;

-(void)setMatch;

+(NSCache*)shareCacheForComment;

@end
