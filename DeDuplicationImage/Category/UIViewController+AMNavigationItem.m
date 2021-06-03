//
//  UIViewController+AMNavigationItem.m
//  mBackup
//
//  Created by mac on 2021/2/2.
//  Copyright © 2021 mac. All rights reserved.
//

#import "UIViewController+AMNavigationItem.h"
#import "NSString+Extension.h"
@implementation UIViewController (AMNavigationItem)

#pragma 设置导航栏按钮

- (void) setNavLeftBarItem:(SEL) btnSel  imageName:(NSString *)imageName frame:(CGRect)buttonFrame {
    self.navigationItem.leftBarButtonItems = [self navItems:[self navButton:btnSel imageName:imageName frame:buttonFrame]];
}

- (void) setNavRightBarItem:(SEL) btnSel imageName:(NSString *)imageName frame:(CGRect)buttonFrame {
    self.navigationItem.rightBarButtonItems = [self navItems:[self navButton:btnSel imageName:imageName frame:buttonFrame]];
}

- (void) setNavLeftBarItem:(SEL) btnSel title:(NSString*) title color:(UIColor*) itemColor {
    self.navigationItem.leftBarButtonItems = [self navItems:[self navButton:btnSel title:title color:itemColor]];
}

- (void) setNavRightBarItem:(SEL) btnSel title:(NSString*) title color:(UIColor*) itemColor {
    self.navigationItem.rightBarButtonItems = [self navItems:[self navButton:btnSel title:title color:itemColor]];
}

- (NSArray*) navItems:(UIButton*) button {

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7) {
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        return @[negativeSpacer, buttonItem];
        
    }else{
        return @[buttonItem];
    }
}

- (UIButton*) navButton:(SEL)selector imageName:(NSString*) imageName frame:(CGRect) buttonFrame {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setFrame:buttonFrame];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton*) navButton:(SEL)selector title:(NSString*) title color:(UIColor*) color {
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60,60)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    CGSize  contentSize = [title sizeWithFontNumber:button.titleLabel.font];
    [button setFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma 设置titleView
-(void) setTitleView:(NSString *)title Color:(UIColor *)navItemColor {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = navItemColor;
    nameLabel.text = title;
    nameLabel.font = [UIFont systemFontOfSize:17.0f];
    CGSize size = [nameLabel.text sizeWithAttributes:@{
                                                       NSFontAttributeName:nameLabel.font
                                            }];
    [nameLabel setFrame:CGRectMake(0, 0, size.width, size.height)];
    self.navigationItem.titleView = nameLabel;
}

-(void) setTitleView:(NSString *)title Color:(UIColor *)navItemColor Font:(CGFloat) fontNumber {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = navItemColor;
    nameLabel.text = title;
    nameLabel.font = [UIFont systemFontOfSize:fontNumber];
    CGSize size = [nameLabel.text sizeWithAttributes:@{
                                                       NSFontAttributeName:nameLabel.font
                                                       }];
    [nameLabel setFrame:CGRectMake(0, 0, size.width, size.height)];
    self.navigationItem.titleView = nameLabel;
}

-(void) setTitle:(NSString *)iconName {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    
    self.navigationItem.titleView = imageView;
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) dismissVC:(void(^)(void)) block {
    [self.navigationController dismissViewControllerAnimated:YES completion:block];
}

@end
