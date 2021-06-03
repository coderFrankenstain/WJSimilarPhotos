//
//  AMPhotoManager.h
//  DeDuplicationImage
//
//  Created by mac on 2021/3/5.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN
@class UIImage,PHAsset;
@interface AMPhotoManager : NSObject
+ (NSArray*) getAlbumPhotos;
+ (NSArray*) fectchSimilarArray;


+ (void) requestImage:(PHAsset*) asset targetSize:(CGSize)targetSize synchronous:(BOOL) isSync block:(void(^)(UIImage* image)) block;
+ (PHAsset*) requestAssetWithIdentifier:(NSString*) identifier;


+ (void) asyncRequestImageWithIdentifier:(NSString*) identifier size:(CGSize) targetSize  block:(void(^)(UIImage* image)) block;

+ (void) syncRequestImage:(PHAsset*) asset targetSize:(CGSize) size block:(void(^)(UIImage* image)) block;
+ (UIImage*) syncRequestImage:(PHAsset*) asset targetSize:(CGSize) size;

@end

NS_ASSUME_NONNULL_END
