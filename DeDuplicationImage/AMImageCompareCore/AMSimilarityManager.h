//
//  AMSimilarityManager.h
//  DeDuplicationImage
//
//  Created by mac on 2021/4/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PHAsset;
@interface AMSimilarityManager : NSObject
//输入为以天为单位的(PHAsset)数组
+ (NSArray*) similarityGroup:(NSArray<PHAsset*>*) array;
@end

NS_ASSUME_NONNULL_END
