//
//  NSString+Base64.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)
-(NSString *)base64
{
       NSData *sData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSData *base64Data = [sData base64EncodedDataWithOptions:0];
        NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
  
    return baseString;
}
@end
