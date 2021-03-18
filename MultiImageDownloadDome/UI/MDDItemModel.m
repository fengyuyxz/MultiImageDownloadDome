//
//  MDDItemModel.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "MDDItemModel.h"

@implementation MDDItemModel
+(instancetype)shareMDDItemModel:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.image=dic[@"image"];
        self.name=dic[@"name"];
    }
    return self;
}
@end
