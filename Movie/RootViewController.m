//
//  RootViewController.m
//  Movie
//
//  Created by lanou3g on 15/12/10.
//  Copyright © 2015年 chuanbao. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"视频.png"] tag:101];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:myVC];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"我的.png"] tag:102];
    
    self.viewControllers = @[nav1,nav2];
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
