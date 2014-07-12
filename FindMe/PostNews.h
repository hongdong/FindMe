//
//  PostNews.h
//  FindMe
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
@interface PostNews : Post

@property(strong,nonatomic) NSString *isRead;
@property(strong,nonatomic) NSString *updateTime;

@end
