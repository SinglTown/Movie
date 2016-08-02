//
//  HomeViewController.m
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "HomeViewController.h"
#import "MovieDataManager.h"
#import "HomeTableViewCell.h"
#import "MovieModel.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoDownLoadManager.h"
#import "MBProgressHUD.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频列表";
    
    [MBProgressHUD showHUDAddedTo:self.mainTableView animated:YES];
    [[MovieDataManager sharedMovieDataManager] getMovieDataFromNet:^(BOOL isFinished) {
        [MBProgressHUD hideHUDForView:self.mainTableView animated:YES];
        [self.mainTableView reloadData];
    }];
    //cell如果是xib文件,使用以下方式去注册
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeTableViewCell"];
    
    //设置代理
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;

    
    NSLog(@"%@",NSHomeDirectory());
}
#pragma mark - 设置row的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MovieDataManager sharedMovieDataManager].movieDataArray.count;
}
#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.也可以使用这种方式
//    static NSString *cell_id = @"cell_id";
//    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
//    if (cell == nil) {
//        //加载可视化文件
//        cell = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:nil options:nil].firstObject;
//    }
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    MovieModel *model = [MovieDataManager sharedMovieDataManager].movieDataArray[indexPath.row];
    [cell setCellDataWithModel:model];
    return cell;
}
#pragma mark - 设置section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark - 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
#pragma mark - 选中方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //
    MovieModel *model = [MovieDataManager sharedMovieDataManager].movieDataArray[indexPath.row];
    UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self playMovieWithMovieModel:model];
    }];
    UIAlertAction *dowloadAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([[VideoDownLoadManager sharedDownLoadManager].downLoadingArray containsObject:model]) {
            //提示正在下载
            [self alertDownLoadingMessage];
            return ;
        }
        [[VideoDownLoadManager sharedDownLoadManager] startDownLoadVideoWithMovieModel:model];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //将三个按钮加在alertVC上
    [alertVC addAction:playAction];
    [alertVC addAction:dowloadAction];
    [alertVC addAction:cancelAction];
    //模态推出
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - 播放视频的方法
-(void)playMovieWithMovieModel:(MovieModel *)model
{
    //播放视频 MPMoviePlayerViewController(ios9之前)
    //ios9以后 使用AVPlayer 去播放
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:model.flv]];
    //准备播放状态
    [playerVC.moviePlayer prepareToPlay];
    //设置自动播放
    playerVC.moviePlayer.shouldAutoplay = NO;
    [self presentViewController:playerVC animated:YES completion:nil];
    
//    MPMoviePlayerController
}
#pragma mark - 弹框-提示正在下载
-(void)alertDownLoadingMessage
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频正在下载" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVC animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
