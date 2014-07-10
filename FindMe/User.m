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
    NSLog(@"保存到本地完成");
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
            weakSelf.department = [userInfo objectForKey:@"department"];
            weakSelf.school = [userInfo objectForKey:@"school"];
            weakSelf.userAuthType = [userInfo objectForKey:@"userAuth"];
            weakSelf.userConstellation = [userInfo objectForKey:@"userConstellation"];
            weakSelf.userGrade = [userInfo objectForKey:@"userGrade"];
            weakSelf.userNickName = [userInfo objectForKey:@"userNickName"];
            weakSelf.userPhoto = [userInfo objectForKey:@"userPhoto"];
            weakSelf.openId = [userInfo objectForKey:@"openId"];
            weakSelf.userSex = [userInfo objectForKey:@"userSex"];
            weakSelf.userSignature = [userInfo objectForKey:@"userSignature"];
            weakSelf.isOnLine = [userInfo objectForKey:@"isOnLine"];
            weakSelf.userLoginCount = [userInfo objectForKey:@"userLoginCount"];
            weakSelf.userAlbum = [userInfo objectForKey:@"userAlbum"];
            NSLog(@"获取用户资料完成");
            
            
            [weakSelf saveToNSUserDefaults];
            
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
@end

