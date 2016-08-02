//
//  MovieDataManager.h
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLOCK)(BOOL isFinished);

@interface MovieDataManager : NSObject

//存放电影数据模型的数组
@property (nonatomic,strong)NSArray *movieDataArray;

+(instancetype)sharedMovieDataManager;

#pragma mark - 请求电影数据
-(void)getMovieDataFromNet:(BLOCK)finishedBlock;


@end
