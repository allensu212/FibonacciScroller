//
//  NumberObject.m
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "NumberObject.h"
#import "BigInteger.h"

@interface NumberObject ()
@property (nonatomic, strong, readwrite) BigInteger *bigInteger;
@end

@implementation NumberObject

-(instancetype)initWithBigInteger:(BigInteger *)bigInteger {
    if (self = [super init]) {
        _bigInteger = bigInteger;
    }
    return self;
}

-(NSString *)stringValueForBase10 {
    
    return [self.bigInteger toRadix:10];
}

@end
