//
//  MainViewController.m
//  DeDuplicationImage
//
//  Created by mac on 2021/3/10.
//

#import "MainViewController.h"
#import "AMAssetCollectionViewCell.h"
#import "AMPhotoManager.h"
#import "UIViewController+AMNavigationItem.h"
#import "TestViewController.h"
#import "AMImageShowController.h"

#import <Masonry/Masonry.h>
#define collectionMaxCount 4
#define kScreen_Width  [[UIScreen mainScreen] bounds].size.width
#define kScreen_Height [[UIScreen mainScreen] bounds].size.height
@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(strong,nonatomic) UICollectionView* collectionView;
@property(strong,nonatomic) NSArray* dataArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
    [self setNavRightBarItem:@selector(finsh) title:@"开始" color:[UIColor blackColor]];
    [self setTitleView:@"图片相似度" Color:[UIColor blackColor]];
        // Do any additional setup after loading the view.
}

- (void) finsh {
    NSLog(@"start");
    [self setTitleView:@"正在计算....." Color:[UIColor blackColor]];
    [self loadImageData];
   
}

- (void) test {
    TestViewController* testVc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:testVc animated:YES];
}

- (void) loadImageData {
    
    //异步加载图片数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataArray = [AMPhotoManager fectchSimilarArray];
        
        //计算相似总数
        int count = 0;
        for (NSArray* array  in self.dataArray) {
            count += array.count;
        }
        
        //加载完毕刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self setTitleView:[NSString stringWithFormat:@"相似图片 %d张",count] Color:[UIColor blackColor]];
            NSLog(@"end");
            
        });
    });
}


- (void) setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = MIN(kScreen_Width, kScreen_Height);
    
    NSInteger columnCount;
    
    columnCount = collectionMaxCount;
    
    layout.itemSize = CGSizeMake((width-1.5*columnCount)/columnCount, (width-1.5*columnCount)/columnCount);
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 1.5;
    layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
    layout.headerReferenceSize = CGSizeMake(kScreen_Width, 20);
    layout.sectionHeadersPinToVisibleBounds = YES;

    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[AMAssetCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([AMAssetCollectionViewCell class])];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(collectionView.superview);

    }];
}

#pragma tableViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray* sectionArray = [self.dataArray objectAtIndex:section];
    return sectionArray.count;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* assts = [self.dataArray objectAtIndex:indexPath.section];
    AMImageShowController* showController = [[AMImageShowController alloc] init];
    [showController setAssets:assts];
    [self.navigationController pushViewController:showController animated:YES];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* sectionArray = [self.dataArray objectAtIndex:indexPath.section];
    PHAsset* asst = [sectionArray objectAtIndex:indexPath.row];
    
    AMAssetCollectionViewCell* cell = [AMAssetCollectionViewCell cellWithCollectionView:collectionView andIndexPath:indexPath];
    cell.identifier = asst.localIdentifier;
    return cell;
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
