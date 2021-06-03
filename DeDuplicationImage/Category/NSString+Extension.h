//
//  NSString+Extension.h
//  mBackup
//
//  Created by mac on 2021/1/14.
//  Copyright © 2021 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)
+ (NSString *)getCountNumber:(NSInteger)count;
+ (NSString *) ConvertMessageTime:(long long)secs;
+ (NSString *)fileSizeWithInterge:(NSInteger)size;

-(CGSize)sizeWithSize:(CGSize)stringSize andFont:(UIFont*)font;
-(CGSize)sizeWithFontNumber:(UIFont*)font;

- (NSString *)getMd5_32Bit;
- (NSString*) SHA256;
- (NSString*) getUniteWithString;
- (NSMutableAttributedString*) stringWithLine:(CGFloat) line;
-(CGFloat) getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withSize:(CGSize)wordSize;
- (NSString *)URLDecodedString;
-(BOOL)checkNumber;
- (BOOL) myContainString:(NSString*) string;
- (BOOL)isEmpty;
- (NSDictionary*) toJsonDic;
@end

NS_ASSUME_NONNULL_END
