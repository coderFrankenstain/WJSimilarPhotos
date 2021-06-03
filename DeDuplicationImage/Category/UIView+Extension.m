//
//  UIView+Extension.m
//  readWirteDemo
//
//  Created by mac on 2019/5/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
-(void) setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void) setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void) setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void) setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void) setMaxX:(CGFloat)maxX {
   self.maxX = maxX;
}


- (void)setMaxY:(CGFloat)maxY {
    self.maxY = maxY;
}

- (CGFloat) x
{
    return self.frame.origin.x;
}

- (CGFloat) maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat) maxY {
    return CGRectGetMaxY(self.frame);
    
}

-(CGFloat) y
{
    return self.frame.origin.y;
}

-(CGFloat) width
{
    return self.frame.size.width;
}

-(CGFloat) height
{
    return self.frame.size.height;
}

@end
