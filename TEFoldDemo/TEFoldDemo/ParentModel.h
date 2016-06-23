//
//  ParentModel.h
//  StudentServices
//
//  Created by offcn_c on 16/6/15.
//  Copyright © 2016年 offcn_c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentModel : NSObject

/**自己独一无二的id 不要与包id混乱*/
@property (nonatomic, copy) NSString *courseId;
/**标题*/
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;
/**类型 章节*/
@property (nonatomic, copy) NSString *type;
/**课件类型*/
@property (nonatomic, copy) NSString *lesson_type;
@property (nonatomic, copy) NSMutableArray *children;
/**是否打开*/
@property (nonatomic, assign) BOOL unfold;

/**如果是视频视频长度，否则返回直播开始时间*/
@property (nonatomic, copy) NSString *media_length;
/**webView链接*/
@property (nonatomic, copy) NSString *test_paper_link;

@end
