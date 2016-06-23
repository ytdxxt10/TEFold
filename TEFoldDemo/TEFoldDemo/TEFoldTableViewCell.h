//
//  TEFoldTableViewCell.h
//  StudentServices
//
//  Created by offcn_c on 16/6/15.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParentModel;



@protocol TableViewCellDelegate <NSObject>

@optional
- (void)TableViewCellDidSelectWithLessonModel:(ParentModel *)model;

@end

@interface TEFoldTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *childArray;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UITableView *childTableView;

@property (nonatomic, assign) id <TableViewCellDelegate>delegate;

/**设置图片*/
-(void)setArrowImageIfUnfold:(BOOL)unfold;

- (void)cellConfigureCellFromModel:(ParentModel*)model;
@end
