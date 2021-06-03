//
//  AMHistogramCompare.h
//  DeDuplicationImage
//
//  Created by mac on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIImage;
@interface AMHistogramCompare : NSObject
//- (void) handleImage:(UIImage*) image1 withImage:(UIImage*) image2;
- (double) handleImage:(UIImage*) image1 withImage:(UIImage*) image2;
@end

NS_ASSUME_NONNULL_END
