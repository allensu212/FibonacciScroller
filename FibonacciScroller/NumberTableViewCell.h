//
//  NumberTableViewCell.h
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "BaseTableViewCell.h"
@class NumberObject;

@interface NumberTableViewCell : BaseTableViewCell
@property (nonatomic, strong, readonly) NumberObject *numberObject;
- (void)configureCellWithNumberObject:(NumberObject *)numberObject;
@end
