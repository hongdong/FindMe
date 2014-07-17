//
//  EMPushNotificationOptions.h
//  EaseMobClientSDK
//
//  Created by Ji Fang on 7/7/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMChatServiceDefs.h"


@interface EMPushNotificationOptions : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic) EMPushNotificationDisplayStyle displayStyle;
@property (nonatomic) BOOL noDisturbing;
@property (nonatomic) NSUInteger noDisturbingStartH;
@property (nonatomic) NSUInteger noDisturbingStartM;
@property (nonatomic) NSUInteger noDisturbingEndH;
@property (nonatomic) NSUInteger noDisturbingEndM;

@end
