//
//  UIImageView+MDDCache.h
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (MDDCache)
-(void)mdd_setImage:(NSURL *)imageURL placeholderImage:(UIImage * __nullable)placeholderImage completion:(void(^)(UIImage * __nullable image,NSError * __nullable error))block;
@end

NS_ASSUME_NONNULL_END
