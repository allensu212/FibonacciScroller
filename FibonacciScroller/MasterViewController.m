//
//  MasterViewController.m
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "MasterViewController.h"
#import "Constants.h"
#import "NumberTableViewCell.h"
#import "FibonacciEngine.h"
#import "NumberObject.h"
#import "NavigationBarLabel.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, FibonacciEngineDelegate>
@property (nonatomic, strong) FibonacciEngine * fibonacciEngine;
@property (nonatomic, strong) NSArray * numberList;
@property (nonatomic, strong) NumberTableViewCell * sizingCell;
@end

@implementation MasterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberList = [NSArray new];
    self.fibonacciEngine = [[FibonacciEngine alloc]init];
    self.fibonacciEngine.delegate = self;
    
    NavigationBarLabel *label = [[NavigationBarLabel alloc]initWithText:NAVIGATION_BAR_TITLE];
    self.navigationItem.titleView = label;
    
    [self configureSizingCell];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureFooter];
    [self.fibonacciEngine generateNextPagedSet];
}

#pragma mark - UIUpdate

- (void)checkIfPreloadIsNeeded {
    
    for (UITableViewCell * cell in self.tableView.visibleCells) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        
        if (indexPath.row >= self.numberList.count - PRELOAD_THRESHOLD_CONTROLLER &&
            self.fibonacciEngine.state != FibonacciEngineStateIdle &&
            self.fibonacciEngine.state != FibonacciEngineStateProcessing) {
            [self.fibonacciEngine generateNextPagedSet];
        }
    }
}

-(void)configureSizingCell{
    
    self.sizingCell = [NumberTableViewCell cellForTableView:self.tableView];
    self.sizingCell.userInteractionEnabled = NO;
    self.sizingCell.hidden = YES;
    [self.tableView addSubview:self.sizingCell];
}

-(void)configureFooter{
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [activityIndicator startAnimating];
    
    UIView * container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, FOOTER_HEIGHT)];
    [container addSubview:activityIndicator];
    self.tableView.tableFooterView = container;
    
    NSLayoutConstraint * constraint_H = [NSLayoutConstraint constraintWithItem:activityIndicator
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:container
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0f
                                                                      constant:0.0f];
    
    NSLayoutConstraint * constraint_V = [NSLayoutConstraint constraintWithItem:activityIndicator
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:container
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0f];
    
    NSArray * constraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(20)]"
                                                                      options:NSLayoutFormatAlignAllBaseline
                                                                      metrics:nil
                                                                        views:@{ @"view": activityIndicator}];
    
    NSArray * constraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(20)]"
                                                                      options:NSLayoutFormatAlignAllBaseline
                                                                      metrics:nil
                                                                        views:@{ @"view": activityIndicator}];
    
    [container addConstraints:@[constraint_H, constraint_V]];
    [container addConstraints:constraints_H];
    [container addConstraints:constraints_V];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NumberObject * numberObject = [self.numberList objectAtIndex:indexPath.row];
    NumberTableViewCell * numberCell = [NumberTableViewCell cellForTableView:tableView];
    [numberCell configureCellWithNumberObject:numberObject];
    return numberCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.numberList count];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NumberObject * numberItem = [self.numberList objectAtIndex:indexPath.row];
    [self.sizingCell configureCellWithNumberObject:numberItem];
    CGFloat height = [self.sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + LABEL_SPACER;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NumberTableViewCell cellHeight];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkIfPreloadIsNeeded];
}

#pragma mark - FibonacciEngineDelegate

-(void)onFibonacciNumbersGenerated:(NSArray *)list{
    if (![NSThread isMainThread]) {
        NSAssert(NO, @"This method MUST be called on the main thread");
        return;
    }
    
    self.numberList = [self.numberList arrayByAddingObjectsFromArray:list];
    [self.tableView reloadData];
}

@end
