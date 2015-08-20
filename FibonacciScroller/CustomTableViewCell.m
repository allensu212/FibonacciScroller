//
//  CustomTableViewCell.m
//  FibonacciScroller
//
//  Created by Wei-Lun Su on 2015/8/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "NumberObject.h"
#import "Constants.h"

@interface CustomTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong, readwrite) NumberObject *numberObject;
@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.numberLabel.text = @"";
    self.numberLabel.font = [UIFont fontWithName:FONT_MAIN size:14.0f];
    self.numberLabel.textColor = [UIColor darkGrayColor];
    self.numberLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberLabel.numberOfLines = 0;
}

-(void)prepareForReuse {
    self.numberLabel.text = @"";
}

-(void)layoutSubviews {
    self.numberLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
}

-(void)configureCellWithNumberObject:(NumberObject *)numberObject{
    self.numberObject = numberObject;
    self.numberLabel.text = [numberObject stringValueForBase10];
    [self.numberLabel setNeedsLayout];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
