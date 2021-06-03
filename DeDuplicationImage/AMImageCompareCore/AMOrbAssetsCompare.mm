//
//  AMOrbAssetsCompare.m
//  DeDuplicationImage
//
//  Created by mac on 2021/4/6.
//

#import "AMOrbAssetsCompare.h"
#include "opencv2/core.hpp"
#include "opencv2/features2d.hpp"
#include "opencv2/imgcodecs/ios.h"
#include "opencv2/core/cvstd_wrapper.hpp"
using namespace cv;
using namespace std;

@implementation AMOrbAssetsCompare

- (double) handleImage:(UIImage*) image1 withImage:(UIImage*) image2{
//    ORB::create(100);orb = cv2.ORB_create()
    
    Mat img_1,img_2;
    Mat descriptors_1, descriptors_2;
    std::vector<KeyPoint> keypoints_1,keypoints_2;
    UIImageToMat(image1, img_1);
    UIImageToMat(image2, img_2);

    cv::Ptr<ORB> orb = ORB::create();

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
    for(int i = 0; i < matches.size();i++){
        vector<DMatch> matchesValue = matches[i];
        double m = matchesValue[0].distance;
        double n = matchesValue[1].distance * 0.75;
        if (m < n) {
            good.insert(good.end(), m);
        }
    }
    if (matches.size() == 0) {
        return 0;
    }
    else {
        double similary = good.size()*1.0/(matches.size()*1.0);
        return similary;
    }
    
    
}

//    match 匹配
//    BFMatcher matcher(NORM_HAMMING);
//    std::vector<DMatch> matches;
//    vector<DMatch> goodMatches;
//
//    matcher.match(descriptors_1, descriptors_2, matches);
//    float maxdist = 0;
//    for (unsigned int i = 0; i < matches.size(); ++i){
//        maxdist = max(maxdist, matches[i].distance);
//    }
//
//    for (unsigned int i = 0; i < matches.size(); ++i) {
//        if (matches[i].distance < maxdist*0.4){
//            goodMatches.push_back(matches[i]);
//        }
//    }
//    double similary = goodMatches.size()*1.0/(matches.size()*1.0);
//    return similary;

@end
