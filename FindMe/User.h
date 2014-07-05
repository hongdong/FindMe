//
//  User.h
//  FindMe
//
//  Created by mac on 14-4-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface User : NSObject
@property (strong,nonatomic) NSString *openId;
@property (strong,nonatomic) NSString *userNickName;
@property (strong,nonatomic) NSString *userPhoto;
@property (strong,nonatomic) NSString *userDeptNo;
@property (strong,nonatomic) NSString *userDeptName;
@property (strong,nonatomic) NSString *userScNo;
@property (strong,nonatomic) NSString *userScName;
@property (strong,nonatomic) NSString *userGrade;
@property (strong,nonatomic) NSString *userSex;
@property (strong,nonatomic) NSString *_id;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *userSignature;
@property (strong,nonatomic) NSString *userRealName;

@property (strong,nonatomic) NSString *isOnLine;
@property (strong,nonatomic) NSString *userLoginCount;
@property (strong,nonatomic) NSString *userAlbum;


@property (strong,nonatomic) NSString *userAuthType;


@property (strong,nonatomic) NSString *registrationID;

@property(strong,nonatomic)  NSString *constellation;


-(void)saveToNSUserDefaults;

-(void)getUserInfo;

+(id)getUserFromNSUserDefaults;
@end
