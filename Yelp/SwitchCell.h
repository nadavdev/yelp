//
//  SwitchCell.h
//  Yelp
//
//  Created by Nadav Golbandi on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void) SwitchCell: (SwitchCell*) cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL on;
@property (weak, nonatomic) id<SwitchCellDelegate> delegate;

-(void) setOn:(BOOL)on animated:(BOOL) animated;
@end
