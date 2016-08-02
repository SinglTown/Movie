//
//  HomeTableViewCell.h
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieModel;
@interface HomeTableViewCell : UITableViewCell
//电影图片
@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;
//视频名字
@property (strong, nonatomic) IBOutlet UILabel *movieNameLabel;
//解说人
@property (strong, nonatomic) IBOutlet UILabel *speakerNameLabel;
//视频时长
@property (strong, nonatomic) IBOutlet UILabel *movieTotalTimeLabel;

//赋值方法
-(void)setCellDataWithModel:(MovieModel *)model;

@end
