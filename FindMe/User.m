//
//  User.m
//  FindMe
//
//  Created by mac on 14-4-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "User.h"
@implementation User
-(void)saveToNSUserDefaults{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:[self keyValues] forKey:@"user"];
    [setting synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChange object:nil];
    
}


-(void)getUserInfo:(void (^)())complete{
    NSDictionary *parameters = @{@"userId": self._id};
    __weak __typeof(&*self)weakSelf = self;
    
    [HDNet GET:@"/data/user/user_info.do" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            weakSelf.userAlbum = [[userInfo objectForKey:@"userAlbum"] mutableCopy];
            if (weakSelf.userAlbum==nil) {
                weakSelf.userAlbum = [[NSMutableArray alloc] init];
            }
            if (complete) {
                complete();
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MJLog(@"获取用户信息错误%@",error.debugDescription);
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
    user.userAlbum = [user.userAlbum mutableCopy];
    return user;
}

@end

