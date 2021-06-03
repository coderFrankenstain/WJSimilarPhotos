//
//  AMAssetCollectionViewCell.h
//  DeDuplicationImage
//
//  Created by mac on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMAssetCollectionViewCell : UICollectionViewCell
+ (instancetype) cellWithCollectionView:(UICollectionView*) collectionView andIndexPath:(NSIndexPath *)indexPath;
@property(copy,nonatomic) NSString* identifier;
@end

NS_ASSUME_NONNULL_END
