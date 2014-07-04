//
//  ChooseDepartmentViewController.h
//  FindMe
//
//  Created by mac on 14-4-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface ChooseDepartmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
    NSArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray *dataArray;
@property(strong,nonatomic) User *user;
@end
