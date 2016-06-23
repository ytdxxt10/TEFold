//
//  CustomTableViewCell.h
//  StudentServices
//
//  Created by offcn_c on 16/6/13.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParentModel;

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *liveStatusLabel;

- (void)cellConfigureContentFromModel:(ParentModel *)model;

@end
