//
//  TEFoldTableViewCell.m
//  StudentServices
//
//  Created by offcn_c on 16/6/15.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import "TEFoldTableViewCell.h"
#import "ParentModel.h"
#import "CustomTableViewCell.h"

static NSString * const customTableViewCellIdentifier = @"CustomTableViewCell";

@interface TEFoldTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TEFoldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.childTableView.scrollEnabled = NO;
    self.childTableView.delegate = self;
    self.childTableView.dataSource = self;
}


#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _childArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CustomTableViewCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:self options:nil]lastObject];;
    }
    ParentModel * model = _childArray[indexPath.row];
    [cell cellConfigureContentFromModel:model];
    cell.titleNameLabel.text = [model.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentModel *model = _childArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(TableViewCellDidSelectWithLessonModel:)]) {
        [self.delegate TableViewCellDidSelectWithLessonModel:model];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//更换图片
-(void)setArrowImageIfUnfold:(BOOL)unfold {
    
    if (unfold) {
        [self.imageButton setImage:[UIImage imageNamed:@"slgx"] forState:UIControlStateNormal];
        
    } else {
        [self.imageButton setImage:[UIImage imageNamed:@"slgx1"] forState:UIControlStateNormal];

    }

}

- (void)cellConfigureCellFromModel:(ParentModel *)model {
    
    self.nameLabel.text = model.name;
    self.childArray = model.children;
    [self setArrowImageIfUnfold:model.unfold];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
