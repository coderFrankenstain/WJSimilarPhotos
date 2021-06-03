//
//  AMPhashAssetsCompare.m
//  DeDuplicationImage
//
//  Created by mac on 2021/3/9.
//

#import "AMPhashAssetsCompare.h"
#include "opencv2/core.hpp"
#include "opencv2/imgproc.hpp"
//#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgcodecs/ios.h"
using namespace cv;

@implementation AMPhashAssetsCompare

//- (int) handleImage:(UIImage*) originImage withImage:(UIImage*) comapreImage
//{
//    std::vector<uchar> arry1 = [self phash:originImage];
//    std::vector<uchar> arry2 = [self phash:comapreImage];
//    int distance = [self hashDistance:arry1 withArry:arry2];
//    return distance;
//}
//
//
//- (int) hashDistance:(std::vector<uchar>) arry1 withArry:(std::vector<uchar>) arry2
//{
//    
//    //迭代器元素为空,终止判断
//    if (arry1.empty() || arry2.empty()) {
//        return -1;
//    }
//    
//    //长度不一致，终止判断
//    if (arry1.size() != arry2.size()) {
//        return -1;
//    }
//    int distance = 0;
//    for(int i = 0;i < arry1.size();i++){
//        
//        if (arry1[i] != arry2[i]) {
//            distance++;
//        }
//    }
//    return distance;
//}
//
//
//- (std::vector<uchar>) phash:(UIImage*) image
//{
//    //RGB转灰度矩阵
//    Mat src = [self rgbToGray:image];
//    //矩阵离散余弦变化
//    src = [self dctMat:src];
//    
//    //取左上角8x8区域
//    cv::Rect rect(0, 0,8,8);
//    Mat mat = src(rect);
////    Scalar ss = cv::sum(mat);
//    //将二维数组转化为一维数组并求和，求平均数
//    double mean = sumMat(mat);
////    NSLog(@"average %lf",mean);
//    //判断数组里面每个元素和平均数的大小，大于平均数设置1，小于平均数设置0
//    averageArray(mat,mean);
//    
//    std::vector<uchar> array;
//    for (int i = 0; i < mat.rows; ++i) {
//        array.insert(array.end(), mat.ptr<uchar>(i), mat.ptr<uchar>(i)+mat.cols);
//      }
//    return array;
//}
//
//double sumMat(Mat& inputImg)
//{
//    double sum = 0.0;
//    double mean = 0.0;
//    int rowNumber = inputImg.rows;
//    int colNumber = inputImg.cols * inputImg.channels();
//    for (int i = 0; i < rowNumber;i++)
//    {
//        uchar* data = inputImg.ptr<uchar>(i);
//        for (int j = 0; j < colNumber; j++)
//        {
//            sum = data[j] + sum;
//        }
//    }
//    mean = sum / (rowNumber * inputImg.cols*1.0);
//   return  mean;
//}
//
//void averageArray(Mat&  mat,double mean)
//{
//    int rowNumber = mat.rows;
//    int colNumber = mat.cols * mat.channels();
//    std::vector<uchar> array;
//    for (int i = 0; i < rowNumber;i++) {
//        uchar* data = mat.ptr<uchar>(i);
//        for (int j = 0; j < colNumber; j++)
//        {
//            if(data[j] > mean) {
//                data[j] = 1;
//            }
//            else {
//                data[j] = 0;
//            }
//        }
//    }
//   
//}
//
//- (Mat) rgbToGray:(UIImage*) rgbImage
//{
//    
//    Mat mat_image_gray;
//    UIImageToMat(rgbImage, mat_image_gray);
//    
//    //第二步:将C++的彩色图片转成灰度图片
//    //参数1:数据源(原图片)
//    //参数2:目标数据(目标图片)
//    //参数3:转换类型(图片格式)
//    //COLOR_BGR2GRAY :将彩色图片转成灰度图片
//    Mat mat_image_dst;
//    cvtColor(mat_image_gray, mat_image_dst, COLOR_RGB2GRAY);
//    
//    return mat_image_dst;
//}
//
//- (Mat) dctMat:(Mat) src
//{
//    //变为32X32的图片
//    cv::resize(src, src,cv::Size(32,32));
//    //缩放到1.0/255为了转化为单通道深度为一的矩阵(位图)
//    src.convertTo(src, CV_32F,1.0/255);
//
//    //输出矩阵
//    Mat outDst;
//    //DCT离散余弦变换
//    dct(src, outDst);
//    //转化为8位正整数矩阵单通道输出
//    outDst.convertTo(outDst,CV_8SC1);
//    return outDst;
//}
@end
