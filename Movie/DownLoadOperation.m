//
//  DownLoadOperation.m
//  Movie
//
//  Created by lanou3g on 15/12/11.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "DownLoadOperation.h"
#import "MovieModel.h"
#import "SqliteHandle.h"
@interface DownLoadOperation ()<NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>

{
    BOOL isDownLoading;
}

@property (nonatomic,strong)MovieModel *downMdoel;


//session的下载任务对象
@property (nonatomic,strong)NSURLSessionDownloadTask *task;

@end


@implementation DownLoadOperation


#pragma mark - 自定义初始化方法
-(instancetype)initWithMovieModel:(MovieModel *)model withBelongOperationQueue:(NSOperationQueue *)queue
{
    self = [super init];
    if (self) {
        self.downMdoel = model;
        isDownLoading = YES;
    }
    return self;
}
-(void)main
{
    @autoreleasepool {
        //主要做的工作:让线程保持活跃状态,持续下载视频
        //通过NSURLSession 来进行下载(delegate的方式)
        NSString *urlString = self.downMdoel.flv;
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //创建session的配置信息
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //创建session
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        //开始进行网络请求
        self.task = [session downloadTaskWithRequest:request];
        //开始任务
        [self.task resume];
        
        while (isDownLoading) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        }

    }
}
#pragma mark - 收到数据
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//    NSLog(@"呵呵");
    //文件以字节为单位
    //1.totalBytesExpectedToWrite所需下载文件的总大小
    //2.totalBytesWritten已经下载好的大小
    //3.bytesWritten本次下载的文件的大小
    dispatch_async(dispatch_get_main_queue(), ^{
        float progress = totalBytesWritten*1.0f/totalBytesExpectedToWrite;
        self.updateBlock(progress,self.downMdoel);
    });
}
#pragma mark - 数据接收完毕
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *movieName = [NSString stringWithFormat:@"%@.mp4",self.downMdoel.title];
    cachesPath = [cachesPath stringByAppendingPathComponent:movieName];
    //文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    //移动下载好的视频到指定的位置
    [manager moveItemAtPath:location.path toPath:cachesPath error:nil];
    
    //判断是否下载完毕的标志(下载完毕之后标志改变)
    self.downMdoel.isFinishedDownLoad = YES;
    
    //把Model保存到数据库文件
    [[SqliteHandle sharedSqliteHandle] insertToTable:self.downMdoel.title withMovieModel:self.downMdoel];
    
    
    isDownLoading = NO;
}
#pragma mark - 继续下载
-(void)downLoadResume
{
    [self.task resume];
}
#pragma mark - 暂停下载
-(void)downloadSuspend
{
    [self.task suspend];
}
@end
