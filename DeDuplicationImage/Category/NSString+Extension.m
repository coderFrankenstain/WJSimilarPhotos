//
//  NSString+Extension.m
//  mBackup
//
//  Created by mac on 2021/1/14.
//  Copyright © 2021 mac. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
+ (NSString *)getCountNumber:(NSInteger)count {
    
    //判断时  3600
    NSString* result = @"00:00:00";
    NSString* hourString = @"00";
    NSString* minString = @"00";
    NSString* secondString =@"00";
    int hours = count / 3600;
    int res = count % 3600;
    
    if(hours > 0) {
        if (hours > 10) {
            hourString = [NSString stringWithFormat:@"%d",hours];
        }
        else {
            hourString = [NSString stringWithFormat:@"0%d",hours];
        }
    }
    else {
        hourString = @"00";
    }
    
    int min = res / 60;
    res = res % 60;
    
    if(min > 0) {
        if(min > 10) {
            minString = [NSString stringWithFormat:@"%d",min];
        }else {
            minString = [NSString stringWithFormat:@"0%d",min];
            
        }
    }
    else {
        minString = @"00";
    }
    
    int second = res;
    
    if(second > 0) {
        if(second > 10) {
            secondString = [NSString stringWithFormat:@"%d",second];
        }
        else {
            secondString = [NSString stringWithFormat:@"0%d",second];
            
        }
    }
    else {
        secondString = @"00";
    }
    result = [NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secondString];
    
    return result;
    
    //判断秒
}


- (NSString*) getUniteWithString {
    
    NSMutableString* muString =[[NSMutableString alloc] initWithString:self];
    
    return [muString substringWithRange:NSMakeRange(0, self.length-1)];
}

-(BOOL)checkNumber {
    NSString *pattern = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}

- (CGSize)sizeWithSize:(CGSize)stringSize andFont:(UIFont*)font {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraph};
    
    CGSize contentSize = [self  boundingRectWithSize:stringSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return  contentSize;
}

-(CGFloat) getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withSize:(CGSize)wordSize {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace-(font.lineHeight - font.pointSize);
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, };
    CGSize size = [self boundingRectWithSize:wordSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


-(CGSize)sizeWithFontNumber:(UIFont*)font {
    return  [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (BOOL) myContainString:(NSString*) string {
    NSString *str1 = self;
    NSString *str2 = string;
    if ([str1 rangeOfString:str2].location != NSNotFound) {
        return YES ;
    }
    else{
        return NO;
    }
    
}

+ (NSString *) ConvertMessageTime:(long long)secs {
    NSString *timeText = nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];
    //    DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);
        //[formatter setDateFormat:@"HH:mm"];
    }
    
    if (nil != _yesterday) {
        timeText = _yesterday; //[_yesterday stringByAppendingFormat:@" %@", timeText];
    } else {
        timeText = [formatter stringFromDate:messageDate];
    }
    
    return timeText;
}

- (NSString *)trimWhitespace {
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty
{
    return [[self trimWhitespace] isEqualToString:@""];
}

- (NSMutableAttributedString*) stringWithLine:(CGFloat) line {
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:line];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self length])];
    return attributedString1;
    
}

+ (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

- (NSString *)getMd5_32Bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [result appendFormat:@"%02x", digest[i]];
    return result;
}

- (NSString *)SHA256
{
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}



- (NSString *)URLDecodedString {
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    return [result stringByRemovingPercentEncoding];
}

- (NSDictionary*) toJsonDic {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return tempDictQueryDiamond;
}

@end
