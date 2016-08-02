//
//  HomeTableViewCell.m
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
@implementation HomeTableViewCell



-(void)setCellDataWithModel:(MovieModel *)model
{
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:model.big] placeholderImage:[UIImage imageNamed:@"英雄2.png"]];
    self.movieNameLabel.text = model.title;
    self.speakerNameLabel.text = model.nickname;
    self.movieTotalTimeLabel.text = model.totalTime;
}



- (void)awakeFromNib {
    //在此方法中给圆角度
    self.movieImageView.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
