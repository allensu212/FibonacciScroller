//
//  CustomTableViewCell.h
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberObject;

@interface CustomTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) NumberObject *numberObject;
- (void)configureCellWithNumberObject:(NumberObject *)numberObject;
@end
