//
//  ViewController.m
//  DeDuplicationImage
//
//  Created by mac on 2021/3/3.
//

#import "ViewController.h"
#import "AMPhotoManager.h"
#import <Photos/Photos.h>
//using namespace cv;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    [self imageData];
    // Do any additional setup after loading the view.
    
}

- (void) setupTableViews {
    UITableView* tableViews = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped ];
    [self.view addSubview:tableViews];
    
}

- (void) imageData {
//    NSArray* dataArray = [AMPhotoManager pHashSimilarArray];
    
}



@end
