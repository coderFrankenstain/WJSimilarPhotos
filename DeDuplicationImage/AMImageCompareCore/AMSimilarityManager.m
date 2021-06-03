//
//  AMSimilarityManager.m
//  DeDuplicationImage
//
//  Created by mac on 2021/4/13.
//

#import "AMSimilarityManager.h"
#import "AMPhashAssetsCompare.h"
#import "AMHistogramCompare.h"
#import "AMOrbAssetsCompare.h"
#import "AMPhotoManager.h"
#import "AMCompare.h"

#define MaxTimeGap 3600*3  //三小时最大分组间隔
#define MaxHamming 10
#define MaxHis 0.6
#define MaxOrb 0.15
#define ORBCompareSize CGSizeMake(224,224)
#define HSVCompareSize CGSizeMake(224,224)
#define PHASHCompareSize CGSizeMake(64,64)
@implementation AMSimilarityManager
//以一小时为单位分离数组
+ (NSArray*) similarityGroup:(NSArray<PHAsset*>*) array{
    NSMutableArray* inputArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray* outputArray = [NSMutableArray array];
    int i = 0;
    int j = 0;
    
    //理论上会根据输入数组的个数，创建相应的分类数组
    while(i < inputArray.count) {
        //取出代表元素
        //添加自动释放池，处理临时变量
        @autoreleasepool {

            PHAsset* representObjct = inputArray[i];
            //初始化一个离群数组，并且放入代表元素
            NSMutableArray* disGroupArray = [NSMutableArray arrayWithObject:representObjct];
            j = i + 1;

            while (j < inputArray.count) {
                //添加自动释放池，处理临时变量
                @autoreleasepool {
                    //获取对比对象
                    PHAsset* challengeObject = inputArray[j];
                    //判断时间是否间隔小于一定的时间间隔
                    if ([self judgeTime:representObjct and:challengeObject]) {
                        //判断相似度
                        if ([self judge:representObjct and:challengeObject]) {
                            [disGroupArray addObject:challengeObject];
                        }
                        //继续，指向下一位
                        j++;
                    }
                    else {
                        //因为是升序的如果当前不等，则以后的都不等
                        break;
                    }
                }
            }

            if (disGroupArray.count > 1) {

                for (PHAsset* asset in disGroupArray) {
                    //从输入数组中，移除已经放入相似集合的数组
                    [inputArray removeObject:asset];
                }

                [outputArray addObject:disGroupArray];
            }
            else {
                i++;
            }
        }
    }
    return outputArray;
}

//相似度判断
+ (BOOL) judge:(PHAsset*) representObjct and:(PHAsset*) challengeObject {
    
    //初始化对比器
    AMCompare* compare = [[AMCompare alloc] init];
    [compare handleLowLevelImage:representObjct withImage:challengeObject];
    
    //感知哈希计算图片轮廓
    if ([compare phashCompare]) {
        //HSV灰度直方图判断图片色差orbCompare
        [compare handleHighLevelImage:representObjct withImage:challengeObject];
        if ([compare histogramCompare]) {
            //ORB匹配
            if ([compare orbCompare]) {
                return YES;
            }
            else {
                return NO;
            }
        }
        else {
            return NO;
        }

    }
    else {
        return NO;
    }
}

+ (BOOL) judgeTime:(PHAsset*) representObjct and:(PHAsset*) challengeObject{
        
    return [representObjct.creationDate timeIntervalSince1970] - [challengeObject.creationDate timeIntervalSince1970] <= MaxTimeGap ? YES : NO;
}


//图像过滤算法
+ (BOOL) phashCompare:(PHAsset*) representObjct and:(PHAsset*) challengeObject {
    //小于一小时则开始匹配图片相似度
    UIImage* repImage =  [AMPhotoManager syncRequestImage:representObjct targetSize:PHASHCompareSize];
    UIImage* chaImage = [AMPhotoManager syncRequestImage:challengeObject targetSize:PHASHCompareSize];
   

    AMPhashAssetsCompare* compare = [[AMPhashAssetsCompare alloc] init];
    //计算汉明距离
    int distance = [compare handleImage:repImage withImage:chaImage];
    
    if (distance < MaxHamming) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL) histogramCompare:(PHAsset*) representObjct and:(PHAsset*) challengeObject {
    //进行直方图HSV判断
    UIImage* repImage =  [AMPhotoManager syncRequestImage:representObjct targetSize:HSVCompareSize];
    UIImage* chaImage = [AMPhotoManager syncRequestImage:challengeObject targetSize:HSVCompareSize];

    AMHistogramCompare* compare = [[AMHistogramCompare alloc] init];
    double mean = [compare handleImage:repImage withImage:chaImage];
    
    if (mean >= MaxHis) {
        return YES;
    }
    else {
        
        return NO;
    }
}

+ (BOOL) orbCompare:(PHAsset*) representObjct and:(PHAsset*) challengeObject {
    UIImage* repImage = [AMPhotoManager syncRequestImage:representObjct targetSize:ORBCompareSize];
    UIImage* chaImage = [AMPhotoManager syncRequestImage:challengeObject targetSize:ORBCompareSize];

    AMOrbAssetsCompare* compare = [[AMOrbAssetsCompare alloc] init];
    double similary = [compare handleImage:repImage withImage:chaImage];

    if (similary >= MaxOrb) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
