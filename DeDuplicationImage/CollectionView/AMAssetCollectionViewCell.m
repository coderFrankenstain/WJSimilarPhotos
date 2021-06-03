//
//  AMAssetCollectionViewCell.m
//  DeDuplicationImage
//
//  Created by mac on 2021/3/10.
//

#import "AMAssetCollectionViewCell.h"
#import "AMPhotoManager.h"

@interface AMAssetCollectionViewCell()
@property(strong,nonatomic) UIImageView* imageView;
@end

@implementation AMAssetCollectionViewCell
+ (instancetype) cellWithCollectionView:(UICollectionView*) collectionView andIndexPath:(NSIndexPath *)indexPath {
    
    return [[self alloc] initWithCollectionView:collectionView andIndexPath:indexPath];
}

- (instancetype) initWithCollectionView:(UICollectionView*) collectionView andIndexPath:(NSIndexPath *)indexPath {
    
    AMAssetCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMAssetCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
    
}

- (void)setIdentifier:(NSString *)identifier {
    
    _identifier = identifier;
    if (self.imageView == nil) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView setImage:[UIImage imageNamed:@"defaultImage"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:imageView];

        self.imageView = imageView;
    }
    [AMPhotoManager asyncRequestImageWithIdentifier:identifier size:CGSizeMake(self.contentView.bounds.size.width*2, self.contentView.bounds.size.width*2) block:^(UIImage * _Nonnull image) {
        [self.imageView setImage:image];
    }];
   
}


@end
