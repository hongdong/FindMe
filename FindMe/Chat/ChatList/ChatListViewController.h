//
//  ChatListViewController.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 14-5-24.
//  Copyright (c) 2014年 dujiepeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseMobHeaders.h"
@interface ChatListViewController : UIViewController

- (void)refreshDataSource;

- (void)networkChanged:(EMConnectionState)connectionState;

@end
