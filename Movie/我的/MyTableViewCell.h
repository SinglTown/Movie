//
//  MyTableViewCell.h
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieModel;
@class MyTableViewCell;
@protocol MyTableViewCellDelegate <NSObject>

-(void)MyTableViewCellPlayButtonDidClicked:(MyTableViewCell *)cell;

@end

@interface MyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;

@property (strong, nonatomic) IBOutlet UILabel *movieProgressLabel;

@property (strong, nonatomic) IBOutlet UIProgressView *movieProgressView;

@property (strong, nonatomic) IBOutlet UIButton *moviePlayButton;

//代理属性
@property (nonatomic,weak)id<MyTableViewCellDelegate> delegate;

//赋值方法
-(void)setCellDataWithModel:(MovieModel *)model;

@end
