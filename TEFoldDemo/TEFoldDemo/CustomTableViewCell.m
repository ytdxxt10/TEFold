//
//  CustomTableViewCell.m
//  StudentServices
//
//  Created by offcn_c on 16/6/13.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "ParentModel.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.liveStatusLabel.layer.cornerRadius = 7;
    self.liveStatusLabel.layer.masksToBounds = YES;
    self.liveStatusLabel.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellConfigureContentFromModel:(ParentModel *)model {
    self.titleNameLabel.text = [model.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    switch ([model.lesson_type integerValue]) {
        case 1:
            self.typeImageView.image = [UIImage imageNamed:@"play-round"];
            self.typeLabel.text = [NSString stringWithFormat:@"%@分钟",model.media_length];
            
            break;
        case 2:
        case 4:
#warning 这里为直播，显示直播时间，还要判断是否在直播中，无数据，有数据需要完善。
            self.typeImageView.image = [UIImage imageNamed:@"zb"];
            self.liveStatusLabel.hidden = NO;
//            self.typeLabel.text = [NSString timeStampToDateString:model.media_length];
            break;
        case 3:
        case 8:
            self.typeImageView.image = [UIImage imageNamed:@"cl"];
            self.typeLabel.text = @"试卷";
            break;
        case 5:
        case 6:
        case 7:
            self.typeImageView.image = [UIImage imageNamed:@"tkd"];
            self.typeLabel.text = @"材料";
            break;
        default:
            break;
    }


}

@end
