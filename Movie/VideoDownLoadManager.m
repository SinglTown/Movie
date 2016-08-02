//
//  VideoDownLoadManager.m
//  Movie
//
//  Created by lanou3g on 15/12/11.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "VideoDownLoadManager.h"
#import "MovieModel.h"
#import "DownLoadOperation.h"

@interface VideoDownLoadManager ()
//用来保存下载任务的Operation
@property (nonatomic,strong)NSMutableDictionary *operationDict;

@end

static VideoDownLoadManager *manager = nil;

static NSOperationQueue *downLoadQueue = nil;

@implementation VideoDownLoadManager

+(instancetype)sharedDownLoadManager
{
    return [[self alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
            [manager getDownLoadQueue];
            manager.downLoadingArray = [NSMutableArray array];//插入不够频繁用这种初始化方法
            //对字典初始化
            manager.operationDict = [NSMutableDictionary dictionary];
        }
    });
    return manager;
}
#pragma mark - 开始下载视频
-(void)startDownLoadVideoWithMovieModel:(MovieModel *)model
{
    //子线程里面进行下载任务,NSOperation和NSOperationQueue
    DownLoadOperation *ope = [[DownLoadOperation alloc] initWithMovieModel:model withBelongOperationQueue:downLoadQueue];
    
    //把ope存储到字典
    [manager.operationDict setValue:ope forKey:model.flv];
    
    //定义更新的block,此block在DownLoadOperation声明了
    //将progress值传过去
    ope.updateBlock = ^(float progress,MovieModel *currentModel){
        NSLog(@"%f",progress);
        if (self.delegate && [self.delegate respondsToSelector:@selector(VideoDownLoadManagerPassValue:withCurrentModel:)]) {
            [self.delegate VideoDownLoadManagerPassValue:progress withCurrentModel:currentModel];
        }
    };
    //把任务块添加到队列
    [downLoadQueue addOperation:ope];
    //把模型加入数组
    [self.downLoadingArray addObject:model];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newVideoDidStartDownload" object:nil];
}
-(void)getDownLoadQueue
{
    if (downLoadQueue == nil) {
        downLoadQueue = [[NSOperationQueue alloc] init];
        //设置最大并发数(最多同时可以下载三个视频)
        downLoadQueue.maxConcurrentOperationCount = 3;
    }
}
#pragma mark - 继续下载的方法
-(void)continueDownloadVideoWithModel:(MovieModel *)model
{
    DownLoadOperation *ope = self.operationDict[model.flv];
    if (!ope.finished) {
        [ope downLoadResume];
    }
    
}
#pragma mark - 暂停下载的方法
-(void)suspendDownLoadVideoWithModel:(MovieModel *)model
{
    DownLoadOperation *ope = self.operationDict[model.flv];
    if (!ope.finished) {
        [ope downloadSuspend];
    }

}

@end
