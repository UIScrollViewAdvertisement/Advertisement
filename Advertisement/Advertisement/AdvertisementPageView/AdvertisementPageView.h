/**
 *  @file
 *  @author 张凡
 *  @date 2015-11-11
 *  @version 2.0
 */

#import <UIKit/UIKit.h>

/**
 *  @class AdvertisementPageView
 *  @brief Scollre和page+自动滚动的封装
 *  @author 张凡
 *  @date 2015-11-11
 *  @version 2.0
 */

typedef NS_ENUM(NSInteger,kPictureForm){
    kPictureFormLocation,  //本地图片方式
    kPictureFormNetWork,   //图片url方式
};

@protocol AdvertisementProtocol <NSObject>

@optional
/// @brief UIScrollView点击事件
- (void)advertisementdisSelectIndex:(NSInteger)page;

@end

@interface AdvertisementPageView : UIView<UIScrollViewDelegate,AdvertisementProtocol>

/// @brief 设置是否自滚动
@property (assign,nonatomic) BOOL isSelfRolling;
@property (strong,nonatomic) id<AdvertisementProtocol> delegate;

/// @brief PhotoForm参数为图片来源方式,有本地图片方式(kPictureFormLocation)，网络图片方式(kPictureFormNetWork)
- (instancetype)initWithFrame:(CGRect)frame andImageData:(NSArray *)data PhotoForm:(kPictureForm)PhotoForm;

//滚动视图协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
