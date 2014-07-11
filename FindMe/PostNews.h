//
//  PostNews.h
//  FindMe
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostNews : NSObject

@property(strong,nonatomic) NSString *_id;
@property(strong,nonatomic) NSString *isRead;
@property(strong,nonatomic) NSString *postContent;
@property(strong,nonatomic) NSString *postMsgNumber;
@property(strong,nonatomic) NSString *postOfficial;
@property(strong,nonatomic) NSString *postPraise;
@property(strong,nonatomic) NSString *postReadNumber;
@property(strong,nonatomic) NSString *postReleaseTime;
@property(strong,nonatomic) NSString *postTop;
@property(strong,nonatomic) NSDictionary *postUser;
@property(strong,nonatomic) NSString *updateTime;

@end
