
#import "AdvertisementPageView.h"
#import "UIImageView+WebCache.h"
@interface AdvertisementPageView()

@property (strong,nonatomic) UIPageControl *pc;

@property (strong,nonatomic) UIScrollView *pv;

@property (strong,nonatomic) NSTimer *timer;

@property (strong,nonatomic) NSArray *imageNames;

@property (assign,nonatomic) kPictureForm PictureForm;

@end

@implementation AdvertisementPageView

- (instancetype)initWithFrame:(CGRect)frame andImageData:(NSArray *)data PhotoForm:(kPictureForm)PhotoForm
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageNames = data;
        self.PictureForm = PhotoForm;
        self.isSelfRolling = YES;
        [self createScrollView:frame];
        //创建UIpageControl对象
        [self createPage];
        //往UIScrollView对象中添加数据
        [self addDataToScroll];
        //给广告栏设置定时器使其自行移动
        self.timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(move) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

    }
    
    return self;
}

#pragma mark - 创建滚动视图
- (void)createScrollView:(CGRect)frame
{
    self.pv = [[UIScrollView alloc] initWithFrame:frame];
    [self addSubview:self.pv];
    //设置背景色
    self.pv.backgroundColor = [UIColor whiteColor];
    //设置偏移量
    self.pv.contentOffset = CGPointMake(self.frame.size.width,0);
    //设置内容大小
    self.pv.contentSize = CGSizeMake(self.frame.size.width*([self.imageNames count] + 2), self.frame.size.height);
    NSLog(@"w:%f",self.frame.size.width*([self.imageNames count] + 2));
    //当偏移量到了最大位置是否反弹
    self.pv.bounces = NO;
    //设置按页滚动
    self.pv.pagingEnabled = YES;
    //隐藏水平滚动条
    self.pv.showsHorizontalScrollIndicator = NO;
    //隐藏垂直滚动条
    self.pv.showsVerticalScrollIndicator = NO;
    self.pv.delegate = self;
    
    //单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    //点击次数,默认是1,如果大于1表次需要连续点多少次才会调用事件
    tap.numberOfTapsRequired = 1;
    //需要几根手指点击,默认为1
    tap.numberOfTouchesRequired = 1;
    //附着在视图上
    [self.pv addGestureRecognizer:tap];
}

#pragma mark - 点击事件
- (void)onClick:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate advertisementdisSelectIndex:self.pc.currentPage];
    }
}

#pragma mark - 创建UIpageControl对象
- (void)createPage
{
    self.pc = [[UIPageControl alloc] init];
    float y = self.frame.size.height - (self.frame.size.height / 22.0)*3;
    self.pc.frame = CGRectMake((self.frame.size.width-17.5*self.imageNames.count)/2.0, y, 17.5*self.imageNames.count, 0);
    //页数
    self.pc.numberOfPages = self.imageNames.count;
    //当前页数
    self.pc.currentPage = 0;
    //当前页颜色
    self.pc.currentPageIndicatorTintColor = [UIColor blackColor];
    //其它页的颜色
    self.pc.pageIndicatorTintColor = [UIColor grayColor];
    //设置透明度为0.5
    self.pc.alpha = 1;
    [self addSubview:self.pc];
    [self bringSubviewToFront:self.pc];
}

#pragma mark - 往UIScrollView对象中添加数据
- (void)addDataToScroll
{
    if (self.imageNames.count > 0)
    {
        UIImageView *iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (self.PictureForm == kPictureFormLocation) {
            iv1.image = [UIImage imageNamed:self.imageNames[[self.imageNames count] - 1]];
        }
        else if(self.PictureForm == kPictureFormNetWork){
            [iv1 sd_cancelCurrentImageLoad];
            [iv1 sd_setImageWithURL:[NSURL URLWithString:self.imageNames[[self.imageNames count] - 1]] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
        }
        
        [self.pv addSubview:iv1];
        for (int i = 0; i < self.imageNames.count; i++)
        {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*(i+1), 0, self.frame.size.width, self.frame.size.height)];
            if (self.PictureForm == kPictureFormLocation) {
                iv.image = [UIImage imageNamed:self.imageNames[i]];
            }
            else if(self.PictureForm == kPictureFormNetWork){
                [iv sd_cancelCurrentImageLoad];
                [iv sd_setImageWithURL:[NSURL URLWithString:self.imageNames[i]] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
            }
            [self.pv addSubview:iv];
        }
    
        UIImageView *iv5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*([self.imageNames count]+1), 0, self.frame.size.width, self.frame.size.height)];
        
        if (self.PictureForm == kPictureFormLocation) {
            iv5.image = [UIImage imageNamed:self.imageNames[0]];
        }
        else if(self.PictureForm == kPictureFormNetWork){
            [iv5 sd_cancelCurrentImageLoad];
            [iv5 sd_setImageWithURL:[NSURL URLWithString:self.imageNames[0]] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
        }
        [self.pv addSubview:iv5];
    }
}

#pragma mark - 滚动视图协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //已经结束减速
    CGPoint point = scrollView.contentOffset;
    self.pc.currentPage = (int)(point.x/self.frame.size.width)-1;
    if (point.x == 0.0)
    {
        scrollView.contentOffset = CGPointMake(self.frame.size.width*self.imageNames.count, 0);
        self.pc.currentPage = self.imageNames.count;
    }
    else if(point.x / self.frame.size.width == self.imageNames.count+1)
    {
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.pc.currentPage = 0;
    }
}

- (void)move
{
    if (self.isSelfRolling) {
        CGPoint point_pv = self.pv.contentOffset;
        if(point_pv.x / self.frame.size.width == self.imageNames.count+1)
        {
            self.pv.contentOffset = CGPointMake(self.frame.size.width, 0);
            self.pc.currentPage = 0;
        }
        else
        {
            [UIView animateWithDuration:2 animations:^{
                CGPoint point = {self.pv.contentOffset.x + self.frame.size.width,0};
                self.pv.contentOffset = point;
                self.pc.currentPage = (int)(point_pv.x/self.frame.size.width);
                if (point_pv.x / self.frame.size.width == self.imageNames.count) {
                    self.pc.currentPage = 0;
                }
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}


@end
