//
//  MovieDataManager.m
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "MovieDataManager.h"
#import "MovieModel.h"
static MovieDataManager *manager = nil;
@implementation MovieDataManager


+(instancetype)sharedMovieDataManager
{
    return [[self alloc] init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}
#pragma mark - 请求电影数据
-(void)getMovieDataFromNet:(BLOCK)finishedBlock
{
    //包装为URL
    NSURL *url = [NSURL URLWithString:@"http://www.aipai.com/api/aipaiApp_action-searchVideo_gameid-25296_keyword-%E8%92%B8%E6%B1%BD%E6%9C%BA%E5%99%A8%E4%BA%BA_op-AND_appver-a2.4.6_page-1.html"];
    //创建网络请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //利用NSURLSession发送网络请求
    NSURLSession *session = [NSURLSession sharedSession];
    //发送
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @autoreleasepool {
            //加一层判断,不然网络不好的情况容易崩溃
            if (data == nil || error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(NO);
                    return;
                });
            }
            //解析数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = [dic valueForKey:@"video"];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *d in array) {
                MovieModel *model = [[MovieModel alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [arr addObject:model];
            }
            self.movieDataArray = [NSArray arrayWithArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                //调用Block
                finishedBlock(self.movieDataArray.count>0);
            });
        }
    }];
    //开始请求任务
    [dataTask resume];
}
@end
