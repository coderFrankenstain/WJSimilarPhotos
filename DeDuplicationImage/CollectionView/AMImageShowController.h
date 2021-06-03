//
//  AMImageShowController.h
//  DeDuplicationImage
//
//  Created by mac on 2021/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PHAsset;
@interface AMImageShowController : UIViewController
@property(strong,nonatomic) NSArray<PHAsset*>* assets;
@end

NS_ASSUME_NONNULL_END
