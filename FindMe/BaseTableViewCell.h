//
//  BaseTableViewCell.h
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-5-24.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *bottomLineView;

@end
