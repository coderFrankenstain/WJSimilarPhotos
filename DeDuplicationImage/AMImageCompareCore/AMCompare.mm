//
//  AMCompare.m
//  DeDuplicationImage
//
//  Created by mac on 2021/4/20.
//

#import "AMCompare.h"
#include "opencv2/core.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs/ios.h"
#include "opencv2/core/cvstd_wrapper.hpp"
#include "opencv2/features2d.hpp"
#import "AMPhotoManager.h"


#define MaxHamming 10
#define MaxHis 0.6
#define MaxOrb 0.15

#define HighLevelSize CGSizeMake(224,224)
#define LowLevelSize CGSizeMake(64,64)

using namespace cv;
using namespace std;

@interface AMCompare()
{
    Mat originMat;
    Mat compareMat;
}
@end


@implementation AMCompare
//处理图片矩阵
- (void) handleHighLevelImage:(PHAsset*) representObjct withImage:(PHAsset*) challengeObject
{
    
    UIImage* image1 =  [AMPhotoManager syncRequestImage:representObjct targetSize:HighLevelSize];
    UIImage* image2 = [AMPhotoManager syncRequestImage:challengeObject targetSize:HighLevelSize];
    
    UIImageToMat(image1,originMat);
    UIImageToMat(image2, compareMat);
}

- (void) handleLowLevelImage:(PHAsset*) representObjct withImage:(PHAsset*) challengeObject
{
    
    UIImage* image1 =  [AMPhotoManager syncRequestImage:representObjct targetSize:LowLevelSize];
    UIImage* image2 = [AMPhotoManager syncRequestImage:challengeObject targetSize:LowLevelSize];
    
    UIImageToMat(image1,originMat);
    UIImageToMat(image2, compareMat);
}

//直方图颜色分布区分
- (BOOL) histogramCompare
{
//    :(Mat) base andMat:(Mat) compare
    Mat base = originMat;
    Mat compare = compareMat;
    
    Mat hsvbase,hsvcompare;
    cvtColor(base, hsvbase, COLOR_BGR2HSV);
    cvtColor(compare, hsvcompare, COLOR_BGR2HSV);
    
    //h通道的bin个数为50个，那么h通道每一个bin的宽度也就是 180 / 50 因为h取值范围是0到180
    //s通道的bin个数为60个，那么s通道每一个bin的宽度也就是 256 / 60 因为s取值范围是0到256
    int h_bins = 50; int s_bins = 60;
    int histSize[] = { h_bins, s_bins };
    // hue varies from 0 to 179, saturation from 0 to 255
    //h通道维度的横轴取值范围是0到180
    //s通道维度的横轴取值范围是0到256
    float h_ranges[] = { 0, 180 };
    float s_ranges[] = { 0, 256 };
    const float* ranges[] = { h_ranges, s_ranges };
    // Use the o-th and 1-st channels
    int channels[] = { 0, 1 };
    
    MatND hist_base;
    MatND hist_compare;
    
    calcHist(&hsvbase, 1, channels, Mat(), hist_base, 2, histSize, ranges,true, false);
    calcHist(&hsvcompare, 1, channels, Mat(), hist_compare, 2, histSize, ranges, true, false);
    
    normalize(hist_base, hist_base,0, 1, NORM_MINMAX, -1, Mat());
    normalize(hist_compare, hist_compare, 0, 1, NORM_MINMAX, -1, Mat());
    
    return  compareHist(hist_base, hist_compare, HISTCMP_CORREL) >= MaxHis ? YES : NO;
    
}

//ORB特征提取
- (BOOL) orbCompare {
    
    Mat img_1 = originMat;
    Mat img_2 = compareMat;
    
    cv::Ptr<ORB> orb = ORB::create();
    std::vector<KeyPoint> keypoints_1,keypoints_2;
    Mat descriptors_1, descriptors_2;


    orb->detectAndCompute(img_1, Mat(), keypoints_1, descriptors_1);
    orb->detectAndCompute(img_2, Mat(), keypoints_2, descriptors_2);

    if (keypoints_1.size() <= 0 || keypoints_2.size() <= 0) {
        //无法判断相似 特征提取失败
        return 0;
    }
    
    BFMatcher matcher(NORM_HAMMING);
    std::vector<vector<DMatch> > matches;
    matcher.knnMatch(descriptors_1, descriptors_2, matches,2);
    

    vector<double> good;
    for(int i = 0; i < matches.size();i++) {
        
        vector<DMatch> matchesValue = matches[i];
        double m = matchesValue[0].distance;
        double n = matchesValue[1].distance * 0.75;
        if (m < n) {
            good.insert(good.end(), m);
        }
    }
 
    return matches.size() == 0 ? NO :good.size()*1.0/(matches.size()*1.0) >= MaxOrb ? YES : NO ;
}

//phash轮廓匹配
- (BOOL) phashCompare
{
    std::vector<uchar> arry1 = [self phash:originMat];
    std::vector<uchar> arry2 = [self phash:compareMat];
    
    return [self hashDistance:arry1 withArry:arry2] < MaxHamming ? YES : NO;
}


- (int) hashDistance:(vector<uchar>) arry1 withArry:(vector<uchar>) arry2
{
    
    //迭代器元素为空,终止判断
    if (arry1.empty() || arry2.empty()) {
        return -1;
    }
    
    //长度不一致，终止判断
    if (arry1.size() != arry2.size()) {
        return -1;
    }
    int distance = 0;
    for(int i = 0;i < arry1.size();i++){
        
        if (arry1[i] != arry2[i]) {
            distance++;
        }
    }
    return distance;
}


- (vector<uchar>) phash:(Mat) originMat
{
    //RGB转灰度矩阵
    Mat src = [self rgbToGray:originMat];
    //矩阵离散余弦变化
    src = [self dctMat:src];
    
    //取左上角8x8区域
    cv::Rect rect(0, 0,8,8);
    Mat mat = src(rect);
//    Scalar ss = cv::sum(mat);
    //将二维数组转化为一维数组并求和，求平均数
    double mean = sumMat(mat);
//    NSLog(@"average %lf",mean);
    //判断数组里面每个元素和平均数的大小，大于平均数设置1，小于平均数设置0
    averageArray(mat,mean);
    
    vector<uchar> array;
    for (int i = 0; i < mat.rows; ++i) {
        array.insert(array.end(), mat.ptr<uchar>(i), mat.ptr<uchar>(i)+mat.cols);
      }
    return array;
}

double sumMat(Mat& inputImg)
{
    double sum = 0.0;
    double mean = 0.0;
    int rowNumber = inputImg.rows;
    int colNumber = inputImg.cols * inputImg.channels();
    for (int i = 0; i < rowNumber;i++)
    {
        uchar* data = inputImg.ptr<uchar>(i);
        for (int j = 0; j < colNumber; j++)
        {
            sum = data[j] + sum;
        }
    }
    mean = sum / (rowNumber * inputImg.cols*1.0);
   return  mean;
}

void averageArray(Mat&  mat,double mean)
{
    int rowNumber = mat.rows;
    int colNumber = mat.cols * mat.channels();
    vector<uchar> array;
    for (int i = 0; i < rowNumber;i++) {
        uchar* data = mat.ptr<uchar>(i);
        for (int j = 0; j < colNumber; j++)
        {
            if(data[j] > mean) {
                data[j] = 1;
            }
            else {
                data[j] = 0;
            }
        }
    }
   
}

- (Mat) rgbToGray:(Mat) rgbMat
{
        
    //第二步:将C++的彩色图片转成灰度图片
    //参数1:数据源(原图片)
    //参数2:目标数据(目标图片)
    //参数3:转换类型(图片格式)
    //COLOR_BGR2GRAY :将彩色图片转成灰度图片
    Mat mat_image_dst;
    cvtColor(rgbMat, mat_image_dst, COLOR_RGB2GRAY);
    
    return mat_image_dst;
}

- (Mat) dctMat:(Mat) src
{
    //变为32X32的图片
    resize(src, src,cv::Size(32,32));
    //缩放到1.0/255为了转化为单通道深度为一的矩阵(位图)
    src.convertTo(src, CV_32F,1.0/255);

    //输出矩阵
    Mat outDst;
    //DCT离散余弦变换
    dct(src, outDst);
    //转化为8位正整数矩阵单通道输出
    outDst.convertTo(outDst,CV_8SC1);
    return outDst;
}



@end
