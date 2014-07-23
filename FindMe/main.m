//
//  main.m
//  FindMe
//
//  Created by mac on 14-6-18.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Stack Trace:%@",[exception callStackSymbols]);
    }
//    @finally {
//        
//    }

}
