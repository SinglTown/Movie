//
//  MovieModel.m
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
#pragma mark - 归档的时候会执行的方法
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.flv forKey:@"flv"];
    [aCoder encodeObject:self.totalTime forKey:@"totalTime"];
    [aCoder encodeObject:self.big forKey:@"big"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeBool:self.isFinishedDownLoad forKey:@"isFinishedDownLoad"];
}
#pragma mark - 反归档的时候会执行的方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.flv = [aDecoder decodeObjectForKey:@"flv"];
        self.totalTime = [aDecoder decodeObjectForKey:@"totalTime"];
        self.big = [aDecoder decodeObjectForKey:@"big"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.isFinishedDownLoad = [aDecoder decodeBoolForKey:@"isFinishedDownLoad"];
    }
    return self;
}
@end
