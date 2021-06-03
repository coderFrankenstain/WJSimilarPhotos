//
//  TestViewController.m
//  DeDuplicationImage
//
//  Created by mac on 2021/3/12.
//

#import "TestViewController.h"
#import "AMHistogramCompare.h"
#import "AMPhashAssetsCompare.h"
#import <Masonry/Masonry.h>
#import "AMPhotoManager.h"
#import "UIViewController+AMNavigationItem.h"
#import "AMOrbAssetsCompare.h"




@interface TestViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic) UIImageView* imageView1;
@property(strong,nonatomic) UIImageView* imageView2;
@property(strong,nonatomic) PHAsset* asset1;
@property(strong,nonatomic) PHAsset* asset2;
@end

@implementation TestViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavRightBarItem:@selector(clickOnCaculate) title:@"开始计算" color:[UIColor blackColor]];
    [self setupViews];
    
    Protocol;
}



- (void) setupViews {
    UIImageView* imageV1 = [[UIImageView alloc] init];
    [imageV1 setBackgroundColor:[UIColor lightGrayColor]];
    self.imageView1 = imageV1;
    [self.view addSubview:imageV1];
    
    UIImageView* imageV2 = [[UIImageView alloc] init];
    [imageV2 setBackgroundColor:[UIColor lightGrayColor]];
    self.imageView2 = imageV2;
    [self.view addSubview:imageV2];
    
    UIButton* button1 = [[UIButton alloc] init];
    [button1 setTitle:@"点击获取图片" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 1;
    [self.view addSubview:button1];
    
    UIButton* button2 = [[UIButton alloc] init];
    [button2 setTitle:@"点击获取图片" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 2;
    [self.view addSubview:button2];
    
    [imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV1.superview).offset(10+64);
        make.size.mas_equalTo(CGSizeMake(200, 200));
        make.centerX.mas_equalTo(imageV1.superview);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(button1.superview);
        make.size.mas_equalTo(CGSizeMake(200, 60));
        make.top.mas_equalTo(imageV1.mas_bottom).offset(10);
    }];
    
    [imageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button1.mas_bottom).offset(10);
        make.centerX.mas_equalTo(imageV2.superview);
        make.size.mas_equalTo(imageV1);
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV2.mas_bottom).offset(10);
        make.centerX.mas_equalTo(button2.superview);
        make.size.mas_equalTo(button1);
    }];
    
}

- (void) clickOnCaculate {

    UIAlertController* alertVc = [UIAlertController alertControllerWithTitle:@"选择计算方法" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertVc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UIAlertAction* hisAction = [UIAlertAction actionWithTitle:@"颜色直方图判断" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self hisAction];
    }];
    
    UIAlertAction* phashAction = [UIAlertAction actionWithTitle:@"感知哈希相似度判断" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pHashAction];
    }];
    
    
    UIAlertAction* orbAction = [UIAlertAction actionWithTitle:@"orb相似度" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self orbAction];
    }];
    
    UIAlertAction* loadAction = [UIAlertAction actionWithTitle:@"图片加载时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImageAction];
    }];
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }];

    [alertVc addAction:hisAction];
    [alertVc addAction:phashAction];
    [alertVc addAction:orbAction];
    [alertVc addAction:loadAction];
    [alertVc addAction:cancelAction];
    
    [self.navigationController presentViewController:alertVc animated:YES completion:^{
        
    }];
    
}

- (void) clickOnButton:(UIButton*) sender {
    UIImagePickerController* pVc = [[UIImagePickerController alloc] init];
    pVc.delegate = self;
    pVc.view.tag = sender.tag;
    [self.navigationController presentViewController:pVc animated:YES completion:^{
        
    }];
}

- (void) hisAction {
    __block UIImage* resImage = nil;
    [AMPhotoManager requestImage:self.asset1 targetSize:CGSizeMake(224, 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        resImage = image;
    }];
    
    __block UIImage* challengeImage = nil;
    [AMPhotoManager requestImage:self.asset2 targetSize:CGSizeMake(224, 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        challengeImage = image;
    }];
    
    AMHistogramCompare* compare = [[AMHistogramCompare alloc] init];
    double distance = [compare handleImage:resImage withImage:challengeImage];
    [self setTitleView:[NSString stringWithFormat:@"%lf",distance] Color:[UIColor blackColor]];
}

- (void) pHashAction {
    __block UIImage* resImage = nil;
    [AMPhotoManager requestImage:self.asset1 targetSize:CGSizeMake(224 , 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        resImage = image;
    }];
    
    __block UIImage* challengeImage = nil;
    [AMPhotoManager requestImage:self.asset2 targetSize:CGSizeMake(224, 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        challengeImage = image;
    }];
    
    
    AMPhashAssetsCompare* compare = [[AMPhashAssetsCompare alloc] init];
    int distance = [compare handleImage:resImage withImage:challengeImage];
    [self setTitleView:[NSString stringWithFormat:@"%d",distance] Color:[UIColor blackColor]];

}




- (void) orbAction {
    __block UIImage* resImage = nil;

    
    [AMPhotoManager requestImage:self.asset1 targetSize:CGSizeMake(224, 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        resImage = image;
    }];
    
    __block UIImage* challengeImage = nil;
    [AMPhotoManager requestImage:self.asset2 targetSize:CGSizeMake(224, 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        challengeImage = image;
    }];

//    NSLog(@"w1 h1 %@ w2 h2 %@",NSStringFromCGSize(resImage.size),NSStringFromCGSize(challengeImage.size));
    AMOrbAssetsCompare* compare = [[AMOrbAssetsCompare alloc] init];
    double sim =[compare handleImage:resImage withImage:challengeImage];
    [self setTitleView:[NSString stringWithFormat:@"%lf",sim] Color:[UIColor blackColor]];
}

- (void) loadImageAction {
    
    NSLog(@"1start image");
    [AMPhotoManager requestImage:self.asset1 targetSize:CGSizeMake(224, 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        NSLog(@"1end image");
    }];
    
    NSLog(@"2start image");
    [AMPhotoManager requestImage:self.asset1 targetSize:CGSizeMake(224, 224) synchronous:YES block:^(UIImage * _Nonnull image) {
        NSLog(@"2end image");
    }];
}


#pragma UImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.view.tag == 1) {
        [self.imageView1 setImage:image];
        self.asset1 = [info objectForKey:@"UIImagePickerControllerPHAsset"];
    }
    else {
        [self.imageView2 setImage:image];
        self.asset2 = [info objectForKey:@"UIImagePickerControllerPHAsset"];

    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
