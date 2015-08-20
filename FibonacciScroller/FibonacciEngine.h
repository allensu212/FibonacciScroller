//
//  FibonacciEngine.h
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    FibonacciEngineStateInitial = 0,
    FibonacciEngineStateIdle = 1,
    FibonacciEngineStateProcessing = 2,
    FibonacciEngineStateCompleted = 3
} FibonacciEngineState;

@protocol FibonacciEngineDelegate <NSObject>

- (void)onFibonacciNumbersGenerated:(NSArray *)list;

@end

@interface FibonacciEngine : NSObject

@property (atomic, assign) FibonacciEngineState state;
@property (nonatomic, weak) id<FibonacciEngineDelegate> delegate;
- (void)generateNextPagedSet;

@end
