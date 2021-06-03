//
//  AMHistogramCompare.m
//  DeDuplicationImage
//
//  Created by mac on 2021/3/12.
//

#import "AMHistogramCompare.h"
#include "opencv2/core.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs/ios.h"
using namespace std;
using namespace cv;
@implementation AMHistogramCompare
- (double) handleImage:(UIImage*) image1 withImage:(UIImage*) image2 {
    Mat base,compare;
    UIImageToMat(image1,base);
    UIImageToMat(image2, compare);
    
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
    
    
    double basecompare =  compareHist(hist_base, hist_compare, HISTCMP_CORREL);
    
    return basecompare;
}
@end
