//
//  SqliteHandle.m
//  Movie
//
//  Created by lanou3g on 15/12/12.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "SqliteHandle.h"
#import <sqlite3.h>
#import "MovieModel.h"
static SqliteHandle *handle = nil;

@implementation SqliteHandle

+(instancetype)sharedSqliteHandle
{
    return [[self alloc] init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (handle == nil) {
            handle = [super allocWithZone:zone];
        }
    });
    return handle;
}

static sqlite3 *db = nil;

-(void)openDB
{
    if (db) {
        return;
    }
    NSString *path = [self getPathOfDataBase];
    //如果路径所指示的数据已经存在,则直接打开,否则创建data.sqlite然后再打开
    sqlite3_open([path UTF8String], &db);
}

#pragma mark - 创建表格
-(void)createTable
{
    [self openDB];
    NSString *createSql = @"create table video_table(key TEXT,model BLOB)";
    sqlite3_exec(db, [createSql UTF8String], NULL, NULL, NULL);
    
}
#pragma mark - 给表格插入数据
-(void)insertToTable:(NSString *)key withMovieModel:(MovieModel *)model
{
    //如果数据库需要插入BLOB数据,必须用绑定的方式,如果不需要则可以使用sqlite_exce这种简单方式
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码
    [archiver encodeObject:model forKey:key];
    //结束归档
    [archiver finishEncoding];
    //SQL语句
    NSString *sql = @"insert into video_table(key,model)values(?,?)";
    //创建临时结果集
    sqlite3_stmt *stmt = nil;
    //数据库准备状态
    int result = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [key UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 2, [data bytes], (int)[data length], NULL);
        //把结果集数据插入到数据库
        sqlite3_step(stmt);
    }
    //释放(结束结果集的写入操作)
    sqlite3_finalize(stmt);
}
#pragma mark - 查找所有的电影模型
-(NSArray *)selectAllModelFromTable
{
    NSString *sql = @"select *from video_table";
    //准备临时结果集
    sqlite3_stmt *stmt = nil;
    //准备状态
    int result = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    //创建数组
    NSMutableArray *array = [NSMutableArray array];
    if (result == SQLITE_OK) {
        //遍历结果集
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const char *keyChar = (const char *)sqlite3_column_text(stmt, 0);
            NSString *key = [[NSString alloc] initWithUTF8String:keyChar];
            //取二进制的数据(model字段)
            const void *modelBytes = sqlite3_column_blob(stmt, 1);
            //长度
            int length = sqlite3_column_bytes(stmt, 1);
            NSData *modelData = [NSData dataWithBytes:modelBytes length:length];
            //反归档
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:modelData];
            MovieModel *model = [unarchiver decodeObjectForKey:key];
            [unarchiver finishDecoding];
            [array addObject:model];
        }
    }
    sqlite3_finalize(stmt);
    return array;
}
#pragma mark - 获取路径
-(NSString *)getPathOfDataBase
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"data.sqlite"];
    return path;
}
@end
