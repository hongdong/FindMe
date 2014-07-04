//
//  Comment.h
//  FindMe
//
//  Created by mac on 14-7-3.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (strong,nonatomic) NSString *postMsgTime;
@property (strong,nonatomic) NSString *postMsgContent;
@property (strong,nonatomic) NSString *_id;
@property (strong,nonatomic) NSString *postMsgUser;
@end
