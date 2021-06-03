//
//  AMPhotoManager.m
//  DeDuplicationImage
//
//  Created by mac on 2021/3/5.
//

#import "AMPhotoManager.h"
#import "AMSimilarityManager.h"

@implementation AMPhotoManager
+ (PHFetchOptions*) options:(NSString*) key  ascending:(BOOL) ascending{
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
    return options;
}
 
+ (PHAsset*) requestAssetWithIdentifier:(NSString*) identifier {
    PHFetchOptions* options = [[PHFetchOptions alloc] init];
    PHFetchResult*  result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:options];
    PHAsset* asset = result.firstObject;
    return asset;
}

#pragma 获取Image
+ (void) asyncRequestImageWithIdentifier:(NSString*) identifier size:(CGSize) targetSize  block:(void(^)(UIImage* image)) block {
    PHAsset* asset = [self requestAssetWithIdentifier:identifier];
//    NSLog(@"cell date %@",[asset.creationDate stringWithFormat:@"yyyy-MM-dd hh:mm:ss"]);
    [self requestImage:asset targetSize:targetSize synchronous:NO block:^(UIImage * _Nonnull image) {
        block(image);
    }];
}


+ (void) syncRequestImage:(PHAsset*) asset targetSize:(CGSize) size block:(void(^)(UIImage* image)) block {

    [self requestImage:asset targetSize:size synchronous:YES block:^(UIImage *image) {
        block(image);
    }];
}

+ (UIImage*) syncRequestImage:(PHAsset*) asset targetSize:(CGSize) size {
    __block UIImage* repImage = nil;
    
    [self syncRequestImage:asset targetSize:size block:^(UIImage *image) {
        repImage = image;
    }];
    
    return repImage;
}

+ (void) requestImage:(PHAsset*) asset targetSize:(CGSize)targetSize synchronous:(BOOL) isSync block:(void(^)(UIImage* image)) block  {
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
    options.synchronous = isSync;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;

    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        block(result);
    }];
}

#pragma 获取asset资源文件
+ (NSArray*) getAlbumPhotos {
    NSMutableArray* photos = [NSMutableArray array];

    PHFetchResult *recentAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [recentAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //资源集合类型检测
        if (![obj isKindOfClass:PHAssetCollection.class]) return;
        PHAssetCollection* collection = (PHAssetCollection*) obj;
        
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        PHFetchResult* assetsReuslt = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        [assetsReuslt enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //资源图片检测
            if (![obj isKindOfClass:[PHAsset class]])return;

            PHAsset* asset = (PHAsset*) obj;
            [photos addObject:asset.localIdentifier];
        }];

    }];
  
    return photos;
}

+ (NSArray*) fectchSimilarArray {
    
    NSMutableArray* outputArray = [NSMutableArray array];
    //设置筛选条件
    PHFetchOptions *momentOptions = [self options:@"startDate" ascending:NO];
    PHFetchOptions *asstsOptions = [self options:@"creationDate" ascending:NO];
    
    PHFetchResult* collectionList = [PHCollectionList  fetchCollectionListsWithType:PHCollectionListTypeMomentList subtype:PHCollectionListSubtypeMomentListCluster options:momentOptions];
    
    [collectionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建一个时刻存放数组
        PHCollectionList* moment = (PHCollectionList*) obj;
 
        //获取时刻里面的Asset集合
        PHFetchResult<PHAssetCollection*>* result = [PHAssetCollection fetchMomentsInMomentList:moment options:momentOptions];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取的时刻时刻
            PHAssetCollection* collection = (PHAssetCollection*) obj;
            
            //获取以天为单位的资源集合
            PHFetchResult<PHAsset*>* daysResults = [PHAsset fetchAssetsInAssetCollection:collection options:asstsOptions];
            
            //天组中张数大于1才可以进入相似度判断
            if (daysResults.count > 1) {
                //转换数组对象
                NSMutableArray<PHAsset*>* assts = [NSMutableArray array];
                
                //筛选媒体类型，只留照片类型
                [daysResults enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (obj.mediaType == PHAssetMediaTypeImage) {
                        [assts addObject:obj];
                    }
                }];
                
                //以小时为单位分离数组 检测相似度
                NSArray* disArray = [AMSimilarityManager similarityGroup:assts];
                
                if (disArray.count > 0) {
                    
                    [outputArray addObjectsFromArray:disArray];
                }
                
            }
        }];
        
    }];
    return outputArray;
}

@end
