//
//  Post.h
//  FindMe
//
//  Created by mac on 14-6-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Post : NSObject
@property(strong,nonatomic)NSString *_id;
@property(strong,nonatomic)NSString *postContent;
@property(strong,nonatomic)NSNumber *postMsgNumber;
@property(strong,nonatomic)NSNumber *postOfficial;
@property(strong,nonatomic)NSArray *postPhoto;
@property(strong,nonatomic)NSNumber *postPraise;
@property(strong,nonatomic)NSString *postReadNumber;
@property(strong,nonatomic)NSString *postReleaseTime;
@property(strong,nonatomic)NSString *postTop;
@property(strong,nonatomic)NSDictionary *postUser;

@end

