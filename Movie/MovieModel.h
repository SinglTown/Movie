//
//  MovieModel.h
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject<NSCoding>

//视频标题
@property (nonatomic,copy)NSString *title;
//视频地址
@property (nonatomic,copy)NSString *flv;
//视频总时长
@property (nonatomic,copy)NSString *totalTime;
//视频图片
@property (nonatomic,copy)NSString *big;
//借解说人
@property (nonatomic,copy)NSString *nickname;

//判断视频是否下载完毕的标志
@property (nonatomic,assign)BOOL isFinishedDownLoad;

@end
