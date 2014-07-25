//
//  User.m
//  FindMe
//
//  Created by mac on 14-4-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "User.h"
#import "AFNetworking.h"
@implementation User
-(void)saveToNSUserDefaults{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"user"];
    [setting setObject:[self keyValues] forKey:@"user"];
    [setting synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSUserDefaultsUserChange" object:nil];
}
-(void)getUserInfo{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/user_info.do",Host];
    NSDictionary *parameters = @{@"userId": self._id};
    __weak __typeof(&*self)weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userInfo = [responseObject objectForKey:@"userInfo"];
        if (userInfo!=nil) {
            weakSelf._id = [userInfo objectForKey:@"_id"];
            weakSelf.userRealName = [userInfo objectForKey:@"userRealName"];
            weakSelf.department = [userInfo objectForKey:@"department"];
            weakSelf.school = [userInfo objectForKey:@"school"];
            weakSelf.userAuthType = [userInfo objectForKey:@"userAuthType"];
            weakSelf.userAuth = [userInfo objectForKey:@"userAuth"];
            weakSelf.userConstellation = [userInfo objectForKey:@"userConstellation"];
            weakSelf.userGrade = [userInfo objectForKey:@"userGrade"];
            weakSelf.userNickName = [userInfo objectForKey:@"userNickName"];
            weakSelf.userPhoto = [userInfo objectForKey:@"userPhoto"];
            weakSelf.openId = [userInfo objectForKey:@"userOpenId"];
            weakSelf.userSex = [userInfo objectForKey:@"userSex"];
            weakSelf.userSignature = [userInfo objectForKey:@"userSignature"];
            weakSelf.isOnLine = [userInfo objectForKey:@"isOnLine"];
            weakSelf.userLoginCount = [userInfo objectForKey:@"userLoginCount"];
            weakSelf.userAlbum = [userInfo objectForKey:@"userAlbum"];
            if (weakSelf.userAlbum==nil) {
                weakSelf.userAlbum = [[NSMutableArray alloc] init];
            }
            
            if ([self.class getUserFromNSUserDefaults]==nil) {
                    [weakSelf saveToNSUserDefaults];
            }

            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(void)getUserInfo:(void (^)())complete{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/user_info.do",Host];
    NSDictionary *parameters = @{@"userId": self._id};
    __weak __typeof(&*self)weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userInfo = [responseObject objectForKey:@"userInfo"];
        if (userInfo!=nil) {
            weakSelf._id = [userInfo objectForKey:@"_id"];
            weakSelf.userRealName = [userInfo objectForKey:@"userRealName"];
            weakSelf.department = [userInfo objectForKey:@"department"];
            weakSelf.school = [userInfo objectForKey:@"school"];
            weakSelf.userAuthType = [userInfo objectForKey:@"userAuthType"];
            weakSelf.userAuth = [userInfo objectForKey:@"userAuth"];
            weakSelf.userConstellation = [userInfo objectForKey:@"userConstellation"];
            weakSelf.userGrade = [userInfo objectForKey:@"userGrade"];
            weakSelf.userNickName = [userInfo objectForKey:@"userNickName"];
            weakSelf.userPhoto = [userInfo objectForKey:@"userPhoto"];
            weakSelf.openId = [userInfo objectForKey:@"userOpenId"];
            weakSelf.userSex = [userInfo objectForKey:@"userSex"];
            weakSelf.userSignature = [userInfo objectForKey:@"userSignature"];
            weakSelf.isOnLine = [userInfo objectForKey:@"isOnLine"];
            weakSelf.userLoginCount = [userInfo objectForKey:@"userLoginCount"];
            weakSelf.userAlbum = [userInfo objectForKey:@"userAlbum"];
            if (weakSelf.userAlbum==nil) {
                weakSelf.userAlbum = [[NSMutableArray alloc] init];
            }
            NSLog(@"获取用户资料完成");
            if (complete!=nil) {
                complete();
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSString *)getSchoolId{
    return [self.school objectForKey:@"_id"];
}
-(NSString *)getSchoolName{
    return [self.school objectForKey:@"schoolName"];
}
-(NSString *)getDepartmentId{
    return [self.department objectForKey:@"_id"];
}
-(NSString *)getDepartmentName{
    return [self.department objectForKey:@"deptName"];
}

+(id)getUserFromNSUserDefaults{
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (userDic==nil) {
        return nil;
    }
    User *user = [User objectWithKeyValues:userDic];
    return user;
}

-(void)freshSession{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/user/grant_user.do",Host];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.operationQueue setMaxConcurrentOperationCount:1];
    NSDictionary *parameters = @{@"userOpenId"     : self.openId,
                                 @"userAuthType"       : self.userAuthType,
                                 @"equitNo"    : [[Config sharedConfig] getRegistrationID],
                                 @"osType"      : @"1",
                                 @"backLogin"   : @"1"};
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *state = [responseObject objectForKey:@"state"];
        
        if ([state isEqualToString:@"20001"]) {
            NSLog(@"刷新session成功");
        [[Config sharedConfig] changeOnlineState:@"1"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:EaseMobShouldLogin object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            
        }else if ([state isEqualToString:@"10001"]){
            
            
        }else if ([state isEqualToString:@"30001"]){
            
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end

