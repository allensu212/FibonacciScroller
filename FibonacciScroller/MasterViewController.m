//
//  MasterViewController.m
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "MasterViewController.h"
#import "Constants.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MasterViewController

#pragma mark - Lifecycle

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

@end
