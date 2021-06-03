//
//  UIViewController+AMNavigationItem.h
//  mBackup
//
//  Created by mac on 2021/2/2.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AMNavigationItem)
//设置导航栏左右按钮
/// 设置左边带图片的按钮
/// @param btnSel 响应的方法编号
/// @param imageName 按钮图片名称
/// @param buttonFrame 图片的尺寸
- (void) setNavLeftBarItem:(SEL) btnSel  imageName:(NSString *)imageName frame:(CGRect)buttonFrame;

/// 设置右边带图片的按钮
/// @param btnSel 响应的方法编号
/// @param imageName 按钮图片名称
/// @param buttonFrame 图片的尺寸
- (void) setNavRightBarItem:(SEL) btnSel imageName:(NSString *)imageName frame:(CGRect)buttonFrame;


/// 设置左边文字按钮
/// @param btnSel 响应方法编号
/// @param title 按钮的文字
/// @param itemColor 按钮文字的颜色
- (void) setNavLeftBarItem:(SEL) btnSel title:(NSString*) title color:(UIColor*) itemColor;

/// 设置右边文字按钮
/// @param btnSel 响应的方法编号
/// @param title 按钮的文字
/// @param itemColor 按钮文字的颜色
- (void) setNavRightBarItem:(SEL) btnSel title:(NSString*) title color:(UIColor*) itemColor;

//设置导航栏中间视图

/// 设置导航栏中间文字,颜色
/// @param title 文字
/// @param navItemColor 文字颜色
-(void) setTitleView:(NSString *)title Color:(UIColor *)navItemColor;


/// 设置导航栏中间文字,颜色,字号
/// @param title 文字
/// @param navItemColor 颜色
/// @param fontNumber 字号
-(void) setTitleView:(NSString *)title Color:(UIColor *)navItemColor Font:(CGFloat) fontNumber;


/// 设置导航中部为图片
/// @param iconName 图片名称
-(void) setTitle:(NSString *)iconName;


/// 导航栏弹出视图
- (void) popVC;


/// 注销当前导航栏
- (void) dismissVC;


/// 注销当前导航栏并且接收完成回调
/// @param block 注销完成回调
- (void) dismissVC:(void(^)(void)) block;
@end

NS_ASSUME_NONNULL_END
