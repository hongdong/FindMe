//
//  ChooseGradeViewController.h
//  FindMe
//
//  Created by mac on 14-4-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface ChooseGradeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic)NSInteger lastestYear;
@property(strong,nonatomic)User *user;

@end
