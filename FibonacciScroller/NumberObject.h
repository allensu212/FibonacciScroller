//
//  NumberObject.h
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BigInteger;

@interface NumberObject : NSObject

@property (nonatomic, strong, readonly) BigInteger *bigInteger;
- (instancetype)initWithBigInteger:(BigInteger *)bigInteger;
- (NSString *)stringValueForBase10;

@end
