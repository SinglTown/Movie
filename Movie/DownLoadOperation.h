//
//  DownLoadOperation.h
//  Movie
//
//  Created by lanou3g on 15/12/11.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MovieModel;

typedef void(^UPDATEBLOCK)(float progress,MovieModel *currentModel);

@interface DownLoadOperation : NSOperation


@property (nonatomic,copy)UPDATEBLOCK updateBlock;

#pragma mark - 自定义初始化方法
-(instancetype)initWithMovieModel:(MovieModel *)model
         withBelongOperationQueue:(NSOperationQueue *)queue;

#pragma mark - 继续下载
-(void)downLoadResume;
#pragma mark - 暂停下载
-(void)downloadSuspend;

@end
