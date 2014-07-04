//
//  ContactsViewController.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 14-5-23.
//  Copyright (c) 2014年 dujiepeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ContactsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *applysArray;

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;



//好友个数变化时，重新获取数据
- (void)reloadDataSource;



@end
