//
//  AMPhashAssetsCompare.h
//  DeDuplicationImage
//
//  Created by mac on 2021/3/9.
//

#import <Foundation/Foundation.h>
@class UIImage;
NS_ASSUME_NONNULL_BEGIN

@interface AMPhashAssetsCompare : NSObject
- (int) handleImage:(UIImage*) originImage withImage:(UIImage*) comapreImage;
@end

NS_ASSUME_NONNULL_END
