//
//  AMImageShowController.m
//  DeDuplicationImage
//
//  Created by mac on 2021/4/9.
//

#import "AMImageShowController.h"
#import "AMPhotoManager.h"
#import <Masonry/Masonry.h>
@interface AMImageShowController ()<UIScrollViewDelegate>
@property(strong,nonatomic) UIImageView* imageView;
@property(assign,nonatomic) CGFloat proportion;
@end

@implementation AMImageShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}



- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) setAssets:(NSArray *)assets {
    
    _assets = assets;
    
    [self setupUI];
}

- (void) setupUI{
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.contentSize = CGSizeMake(kScreen_Width*self.assets.count, kScreen_Height-64);
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    UIView* barView = [[UIView alloc] init];
    barView.backgroundColor = [UIColor blackColor];
    barView.alpha = 0.5;
    [self.view addSubview:barView];
    
    UIButton* backButton = [[UIButton alloc] init];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton.titleLabel setTextColor:[UIColor whiteColor]];
    backButton.alpha = 1.0;
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backButton];
    
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(60));
        make.left.mas_equalTo(barView.superview);
        make.right.mas_equalTo(barView.superview);
        make.top.mas_equalTo(barView.superview);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView.superview);
        make.bottom.mas_equalTo(scrollView.superview.mas_bottom);
        make.left.mas_equalTo(scrollView.superview);
        make.right.mas_equalTo(scrollView.superview);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backButton.superview).offset(10);
        make.top.mas_equalTo(backButton.superview).offset(10);
        make.bottom.mas_equalTo(backButton.superview).offset(-10);
    }];
    
    for(int i = 0; i < self.assets.count;i++){
        PHAsset* asst = self.assets[i];
        
        __block UIImageView* imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scrollView).offset(kScreen_Width*i);
            make.width.mas_equalTo(scrollView);
            make.height.mas_equalTo(scrollView).multipliedBy((asst.pixelHeight*1.0/(asst.pixelWidth*1.0)));
            make.centerY.mas_equalTo(scrollView);
        }];
        NSLog(@"start image");
        [AMPhotoManager requestImage:asst targetSize:CGSizeMake(kScreen_Width, kScreen_Width*(asst.pixelHeight*1.0/(asst.pixelWidth*1.0))) synchronous:NO block:^(UIImage * _Nonnull image) {
            NSLog(@"end image");
            [imageView setImage:image];
        }];
    }
}



#pragma action

- (void) backAction {
    [self.navigationController popViewControllerAnimated:YES];
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
