//
//  ViewController.m
//  TEFoldDemo
//
//  Created by offcn_c on 16/6/22.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import "ViewController.h"
#import "ParentModel.h"
#import "CustomTableViewCell.h"
#import "TEFoldTableViewCell.h"
#import "UIColor+hexadecimal.h"

static NSString * const foldCellIdentifier = @"TEFoldTableViewCell";
static NSString * const customTableViewCellIdentifier = @"CustomTableViewCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,TableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *endArray;
@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.listTableView];
    
    _endArray  = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dataDic[@"data"] objectForKey:@"contents"];
    [self handleData:arr];
    [self handleEndData];
    [_listTableView reloadData];
    
}

//筛选掉其中不包括课的空章和空节
- (void)handleEndData {
    
    NSMutableArray *pArr = [_endArray mutableCopy];
    for (ParentModel *pmodel in pArr) {
        if ([pmodel.type isEqualToString:@"chapter"]) {
            if (pmodel.children.count == 0) {
                [_endArray removeObject:pmodel];
            } else {
                NSMutableArray *array = [NSMutableArray array];
                array = [pmodel.children mutableCopy];
                for (ParentModel *cmodel in pmodel.children) {
                    
                    if (cmodel.children.count == 0) {
                        [array removeObject:cmodel];
                    }
                    pmodel.children = array;
                }
                if (array.count == 0) {
                    [_endArray removeObject:pmodel];
                }
            }
        }else if([pmodel.type isEqualToString:@"unit"]){
            if (pmodel.children.count == 0) {
                [_endArray removeObject:pmodel];
            }
        }
    }
    
}

//将数据变为模型
- (void)handleData:(NSArray *)arr {
    
    for (int i = 0; i < arr.count; i ++) {
        
        ParentModel *pmodel = [[ParentModel alloc]init];
        pmodel.name = arr[i][@"name"];
        pmodel.type = arr[i][@"type"];
        pmodel.lesson_type = arr[i][@"lesson_type"];
        pmodel.media_length = arr[i][@"media_length"];
        pmodel.courseId = arr[i][@"id"];
        pmodel.test_paper_link = arr[i][@"test_paper_link"];
        NSArray *tempArr = arr[i][@"list"];
        
        if (tempArr.count == 0) {
            
            [_endArray addObject:pmodel];
            continue;
        } else {
            
            pmodel.children = [self handleNextData:tempArr];
        
        }
        [_endArray addObject:pmodel];
    }
}

- (NSMutableArray *)handleNextData:(NSArray *)arr {
    
    NSMutableArray *backArr = [NSMutableArray array];

    for (int i = 0; i < arr.count; i++) {
        
        ParentModel *model = [[ParentModel alloc]init];
        model.name = arr[i][@"name"];
        model.type = arr[i][@"type"];
        model.lesson_type = arr[i][@"lesson_type"];
        model.media_length = arr[i][@"media_length"];
        model.courseId = arr[i][@"id"];
        model.test_paper_link = arr[i][@"test_paper_link"];
        NSArray *tempArr = arr[i][@"list"];
        
        if (tempArr.count == 0) {
            
            [backArr addObject:model];
            continue;
            
        } else {
            
           model.children = [self handleThirdData:tempArr];
        }
        
        [backArr addObject:model];

    }
    return backArr;
}

- (NSMutableArray *)handleThirdData:(NSArray *)arr {
    
    NSMutableArray *backArr = [NSMutableArray array];
    
    for (int i = 0; i < arr.count; i++) {
        
        ParentModel *cmodel = [[ParentModel alloc]init];
        cmodel.name = arr[i][@"name"];
        cmodel.type = arr[i][@"type"];
        cmodel.lesson_type = arr[i][@"lesson_type"];
        cmodel.media_length = arr[i][@"media_length"];
        cmodel.courseId = arr[i][@"id"];
        cmodel.test_paper_link = arr[i][@"test_paper_link"];
        [backArr addObject:cmodel];
        
    }
    return backArr;
}

#pragma mark--UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _endArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ParentModel *pmodel = _endArray[section];
    if (pmodel.unfold) {
        return pmodel.children.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParentModel *pmodel = _endArray[indexPath.section];
    ParentModel *cmodel = pmodel.children[indexPath.row];
    if ([cmodel.type isEqualToString:@"unit"]) {
        TEFoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:foldCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:foldCellIdentifier owner:self options:nil]lastObject];
        }
        if (indexPath.row == 0 && cmodel.unfold) {
            cell.lineView.backgroundColor = [UIColor colorFromHexRGB:@"0xdddddd"];
        }
        [cell cellConfigureCellFromModel:cmodel];
        cell.delegate = self;
        return cell;
    }
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customTableViewCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:customTableViewCellIdentifier owner:self options:nil]lastObject];
    }
    
    [cell cellConfigureContentFromModel:cmodel];
    return cell;
    
}

#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParentModel *testModel = _endArray[indexPath.section];
    ParentModel *childModel = testModel.children[indexPath.row];
    if (childModel.unfold && [childModel.type isEqualToString:@"unit"]) {
        return childModel.children.count * 62 + 45;
    }
    if ([childModel.type isEqualToString:@"lesson"]) {
        return 62;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParentModel *testModel = _endArray[indexPath.section];
    ParentModel *childModel = testModel.children[indexPath.row];
    childModel.unfold = !childModel.unfold;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ParentModel *pmodel = _endArray[section];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tag = section + 1;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([pmodel.type isEqualToString:@"lesson"]) {
        button.frame = CGRectMake(0, 0, self.view.frame.size.width, 62);
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 17, 17)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame) + 10, 10, CGRectGetWidth(self.view.frame) - CGRectGetMaxX(leftImageView.frame) - 10, 20)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorFromHexRGB:@"0x666666"];
        titleLabel.text = pmodel.name;
        
        [button addSubview:titleLabel];
        
        UILabel *subTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame) + 5, CGRectGetMaxY(titleLabel.frame) + 5, self.view.frame.size.width/4, 15)];
        subTitleLable.font = [UIFont systemFontOfSize:11];
        subTitleLable.textColor = [UIColor colorFromHexRGB:@"0x999999"];
        subTitleLable.text = pmodel.type;
        [button addSubview:subTitleLable];
        
        UILabel *liveStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(subTitleLable.frame) + 8, CGRectGetMinY(subTitleLable.frame), 35, 15)];
        liveStatusLabel.layer.cornerRadius = 7;
        liveStatusLabel.layer.masksToBounds = YES;
        liveStatusLabel.backgroundColor = [UIColor colorFromHexRGB:@"0xe93131"];
        liveStatusLabel.textColor = [UIColor colorFromHexRGB:@"0xfffefe"];
        liveStatusLabel.text = @"直播中";//通过判断时间来判断是否直播中，或已结束
        liveStatusLabel.font = [UIFont systemFontOfSize:11];
        [button addSubview:liveStatusLabel];
        liveStatusLabel.hidden = YES;
        
        switch ([pmodel.lesson_type integerValue]) {
            case 1:
                leftImageView.image = [UIImage imageNamed:@"play-round"];
                subTitleLable.text = [NSString stringWithFormat:@"%@分钟",pmodel.media_length];
                break;
            case 2:
            case 4:
#warning 这里为直播，显示直播时间，还要判断是否在直播中，无数据，有数据需要完善。
                
                leftImageView.image = [UIImage imageNamed:@"zb"];
                NSLog(@"等待处理时间戳转换");
                break;
            case 3:
            case 8:
                leftImageView.image = [UIImage imageNamed:@"cl"];
                subTitleLable.text = @"试卷";
                break;
            case 5:
            case 6:
            case 7:
                leftImageView.image = [UIImage imageNamed:@"tkd"];
                subTitleLable.text = @"材料";
                break;
                
            default:
                break;
        }
        [button addSubview:leftImageView];
        
    } else {
        button.frame = CGRectMake(0, 0, self.view.frame.size.width, 45);
        
        UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (44-20)/2, 200, 20)];
        [tlabel setBackgroundColor:[UIColor clearColor]];
        [tlabel setFont:[UIFont systemFontOfSize:16]];
        tlabel.textColor = [UIColor colorFromHexRGB:@"0x333333"];
        [tlabel setText:[pmodel.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [button addSubview:tlabel];
        
        UIImageView *rightImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 21,button.frame.size.height / 2 -5 , 11, 11)];
        if ([pmodel.type isEqualToString:@"unit"]) {
            rightImageVIew.frame = CGRectMake(self.view.frame.size.width - 21,button.frame.size.height / 2 -5 , 11, 7);
            if (pmodel.unfold) {
                rightImageVIew.image = [UIImage imageNamed:@"slgx"];
                
            } else {
                rightImageVIew.image = [UIImage imageNamed:@"slgx1"];
                
            }
        }else {
            if (pmodel.unfold) {
                rightImageVIew.image = [UIImage imageNamed:@"xcjq"];
            } else {
                rightImageVIew.image = [UIImage imageNamed:@"xcjq1"];
                
            }
        }
        [button addSubview:rightImageVIew];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(button.frame) - 3, self.view.frame.size.width, 3)];
    if (pmodel.unfold) {
        lineView.frame = CGRectMake(0, CGRectGetHeight(button.frame) - 1, self.view.frame.size.width, 1);
    } else {
        lineView.frame = CGRectMake(0, CGRectGetHeight(button.frame) - 3, self.view.frame.size.width, 3);
    }
    lineView.backgroundColor = [UIColor colorFromHexRGB:@"0xdddddd"];
    
    [button addSubview:lineView];
    
    return  button;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ParentModel *model = _endArray[section];
    if ([model.type isEqualToString:@"lesson"]) {
        return 62;
    }
    return 44;
    
}


#pragma mark-- headerButtonPress
- (void)buttonPress:(UIButton *)sender//headButton点击
{
    ParentModel *model = _endArray[sender.tag - 1];
    //判断状态值
    if (![model.type isEqualToString:@"lesson"]) {
        model.unfold = !model.unfold;
        
    }
    [_listTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


#pragma mark -- property
- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.backgroundColor = [UIColor whiteColor];
    }
    return  _listTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
