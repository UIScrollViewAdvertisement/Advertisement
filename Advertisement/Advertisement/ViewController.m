//
//  ViewController.m
//  Advertisement
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 ZhangFan. All rights reserved.
//

#import "ViewController.h"
#import "AdvertisementPageView.h"

@interface ViewController ()<AdvertisementProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// @brief 创建并初始化图片地址数组
    NSArray *photoArray = @[@"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg",@"http://img3.3lian.com/2013/s1/20/d/57.jpg",@"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg",@"http://pic3.nipic.com/20090525/2416945_231841034_2.jpg",@"http://pic1.nipic.com/2008-11-13/2008111384358912_2.jpg"];
    
    /// @brief 创建AdvertisementPageView对象
    /// @brief PhotoForm参数:为图片来源是本地图片还是网络URL图片,值分别有(kPictureFormLocation(本地图片),kPictureFormNetWork(网络图片))
    /// @brief andImageData参数:为图片的数组
     AdvertisementPageView *pageView = [[AdvertisementPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) andImageData:photoArray PhotoForm:kPictureFormNetWork];
    
    /// @brief 设置是否自滚动,默认为YES
    pageView.isSelfRolling = NO;
    
    /// @brief 设置代理
    /// @brief 要实现点击事件必须设置代理
    pageView.delegate = self;
    
    /// @brief 添加进父视图
    [self.view addSubview:pageView];
}

#pragma mark - 滚动视图点击事件
- (void)advertisementdisSelectIndex:(NSInteger)page
{
    NSLog(@"第%ld页被点击",page);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
