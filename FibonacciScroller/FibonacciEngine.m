//
//  FibonacciEngine.m
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "FibonacciEngine.h"
#import "BigInteger.h"
#import "NumberObject.h"
#import "Constants.h"

@interface FibonacciEngine ()

@property (nonatomic, strong) NSArray * fullList;
@property (nonatomic, strong) NSArray * lastPagedList;
@property (nonatomic, assign) NSUInteger currentOffset;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation FibonacciEngine

- (instancetype)init {
    if ((self = [super init])) {
        _state = FibonacciEngineStateInitial;
        _serialQueue = dispatch_queue_create("serialQueue", NULL);
        _currentOffset = 0;
        _fullList = [NSArray new];
        _lastPagedList = [NSArray new];
    }
    return self;
}

- (void)generateFibonacciWithOffset:(NSUInteger)offset {
    
    __weak FibonacciEngine *weakSelf = self;
    
    dispatch_async(self.serialQueue, ^{
        FibonacciEngine *strongSelf = weakSelf;
        
        if (!strongSelf) {
            NSAssert(NO, @"strongSelf is nil and thus, we have prematurely deallocated");
            return;
        }
        
        //	Transition the engine to the processing state
        strongSelf.state = FibonacciEngineStateProcessing;
        
        NSUInteger startIndex = 0;
        NSUInteger lastIndex = PRELOAD_THRESHOLD;
        NSMutableArray * list = [NSMutableArray new];
        BigInteger * a;
        BigInteger * b;
        
        if (offset != 0) {
            startIndex = strongSelf.currentOffset-1;
            lastIndex = startIndex + PAGED_SET_THRESHOLD;
            
            NSUInteger penultimateIndex = strongSelf.fullList.count-2;	//	Represents the second-to-last index; this is a summarization local variable
            BigInteger * lastBigInteger = [[strongSelf.fullList lastObject] bigInteger];
            BigInteger * penultimateBigInteger = [[strongSelf.fullList objectAtIndex:penultimateIndex] bigInteger];
            
            a = [BigInteger bigintWithBigInteger:penultimateBigInteger];
            b = [BigInteger bigintWithBigInteger:lastBigInteger];
            
        } else {
            
            a = [BigInteger bigintWithUnsignedInt32:0];
            b = [BigInteger bigintWithUnsignedInt32:1];
            
            //	Seed the list with the initial 2 values in the sequence
            [list addObjectsFromArray:@[[[NumberObject alloc] initWithBigInteger:a],
                                        [[NumberObject alloc] initWithBigInteger:b]]];
        }
        for (; startIndex < lastIndex; startIndex++) {
            BigInteger * c = [a add:b];
            a = b;
            b = c;
            
            [list addObject:[[NumberObject alloc] initWithBigInteger:b]];
        }
        
        //	Cache the generated list
        strongSelf.fullList = [strongSelf.fullList arrayByAddingObjectsFromArray:list];
        strongSelf.lastPagedList = list;
        strongSelf.currentOffset = strongSelf.fullList.count;
        
        //	Transition the generator to the completed state
        strongSelf.state = FibonacciEngineStateCompleted;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!strongSelf || !strongSelf.delegate) {
                NSAssert(NO, @"There has been a terminal failure, as an instance of AAFibonacciGenerator has been prematurely deallocated. Correct order of the outputted sequence will not be gauranteed.");
                return;
            }
            
            if ([strongSelf.delegate respondsToSelector:@selector(onFibonacciNumbersGenerated:)]) {
                [strongSelf.delegate onFibonacciNumbersGenerated:strongSelf.lastPagedList];
            }
        });
    });
}

#pragma mark - Pagination methods

- (void)generateNextPagedSet {
    
    @synchronized(self) {
        self.state = FibonacciEngineStateIdle;
        NSUInteger offset = self.currentOffset;
        [self generateFibonacciWithOffset:offset];
    }
}

@end
