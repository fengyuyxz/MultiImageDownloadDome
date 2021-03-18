//
//  MDDItemModel.h
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDDItemModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *image;
+(instancetype)shareMDDItemModel:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
