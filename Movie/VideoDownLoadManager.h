//
//  VideoDownLoadManager.h
//  Movie
//
//  Created by lanou3g on 15/12/11.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MovieModel;

@protocol VideoDownLoadManagerDelegate <NSObject>

-(void)VideoDownLoadManagerPassValue:(float)progress
                    withCurrentModel:(MovieModel *)currentModel;


@end

@interface VideoDownLoadManager : NSObject

//记录下载的视频模型
@property (nonatomic,strong)NSMutableArray *downLoadingArray;

//暴露借口,方便外边进行设置代理
@property (nonatomic,weak)id<VideoDownLoadManagerDelegate> delegate;

+(instancetype)sharedDownLoadManager;

#pragma mark - 开始下载视频
-(void)startDownLoadVideoWithMovieModel:(MovieModel *)model;

#pragma mark - 继续下载的方法
-(void)continueDownloadVideoWithModel:(MovieModel *)model;
#pragma mark - 暂停下载的方法
-(void)suspendDownLoadVideoWithModel:(MovieModel *)model;

@end
