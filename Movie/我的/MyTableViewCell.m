//
//  MyTableViewCell.m
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "MyTableViewCell.h"
#import "MovieModel.h"
#import "UIImageView+WebCache.h"
@implementation MyTableViewCell


//赋值方法
-(void)setCellDataWithModel:(MovieModel *)model
{
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:model.big] placeholderImage:[UIImage imageNamed:@"英雄2.png"]];
    if (model.isFinishedDownLoad) {
        self.movieProgressView.progress = 1.0f;
        self.movieProgressLabel.text = @"完成";
    }
}

//Button的点击方法
- (IBAction)moviePlayButtonDidClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MyTableViewCellPlayButtonDidClicked:)]) {
        [self.delegate MyTableViewCellPlayButtonDidClicked:self];//把自己传出去
    }
}

- (void)awakeFromNib {
    self.movieImageView.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
