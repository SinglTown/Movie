//
//  MyViewController.m
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"
#import "VideoDownLoadManager.h"
#import "MovieModel.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,VideoDownLoadManagerDelegate,MyTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyTableViewCell"];
    //注册通知下载新电影的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newVideoDidStartNeedUpdate:) name:@"newVideoDidStartDownload" object:nil];
    
    //设置代理(VideoDownLoadManagerDelegate)
    [VideoDownLoadManager sharedDownLoadManager].delegate = self;
    
}
#pragma mark - 实现代理方法
-(void)VideoDownLoadManagerPassValue:(float)progress withCurrentModel:(MovieModel *)currentModel
{
    NSInteger index = [[VideoDownLoadManager sharedDownLoadManager].downLoadingArray indexOfObject:currentModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //根据indexPath拿出cell
    MyTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    //赋值
    cell.movieProgressLabel.text = [NSString stringWithFormat:@"%0.2f%%",progress*100];
    cell.movieProgressView.progress = progress;
}
#pragma mark - 通知方法刷新数据(收到新电影的下载通知)
-(void)newVideoDidStartNeedUpdate:(NSNotification *)sender
{
    [self.myTableView reloadData];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    NSLog(@"---------%ld",[VideoDownLoadManager sharedDownLoadManager].downLoadingArray.count);
//    [self.myTableView reloadData];
//}
#pragma mark - row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [VideoDownLoadManager sharedDownLoadManager].downLoadingArray.count;
}
#pragma mark - 分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    //设置代理
    cell.delegate = self;
    
    MovieModel *model = [VideoDownLoadManager sharedDownLoadManager].downLoadingArray[indexPath.row];
    [cell setCellDataWithModel:model];
    return cell;
}
#pragma mark - 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieModel *model = [VideoDownLoadManager sharedDownLoadManager].downLoadingArray[indexPath.row];
    if (model.isFinishedDownLoad) {
        NSString *urlString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *movieName = [NSString stringWithFormat:@"%@.mp4",model.title];
        urlString = [urlString stringByAppendingPathComponent:movieName];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        //准备播放状态
        [playerVC.moviePlayer prepareToPlay];
        //设置自动播放
        playerVC.moviePlayer.shouldAutoplay = NO;
        [self presentViewController:playerVC animated:YES completion:nil];
    }
}
#pragma mark - MyTableViewCell的代理方法
-(void)MyTableViewCellPlayButtonDidClicked:(MyTableViewCell *)cell
{
    //根据cell拿模型
    //首先看cell是第几行
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    MovieModel *model = [VideoDownLoadManager sharedDownLoadManager].downLoadingArray[indexPath.row];
    if (cell.moviePlayButton.selected == NO) {
        [[VideoDownLoadManager sharedDownLoadManager] suspendDownLoadVideoWithModel:model];
        [cell.moviePlayButton setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
    }else{
        [[VideoDownLoadManager sharedDownLoadManager] continueDownloadVideoWithModel:model];
        [cell.moviePlayButton setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    }
    cell.moviePlayButton.selected = !cell.moviePlayButton.selected;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
