//
//  SqliteHandle.h
//  Movie
//
//  Created by lanou3g on 15/12/12.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MovieModel;
@interface SqliteHandle : NSObject

+(instancetype)sharedSqliteHandle;

#pragma mark - 创建表格
-(void)createTable;
#pragma mark - 给表格插入数据
-(void)insertToTable:(NSString *)key withMovieModel:(MovieModel *)model;
#pragma mark - 查找所有的电影模型
-(NSArray *)selectAllModelFromTable;
@end
