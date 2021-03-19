//
//  UIImageView+MDDCache.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "UIImageView+MDDCache.h"
#import "MDDDownloadImageTool.h"
@implementation UIImageView (MDDCache)
-(void)mdd_setImage:(NSURL *)imageURL placeholderImage:(UIImage * __nullable)placeholderImage completion:(void(^)(UIImage * __nullable image,NSError *__nullable error))block;{
    self.image = placeholderImage;
    [[MDDDownloadImageTool shareMDDDownloadImageTool]downloadImage:imageURL completion:^(UIImage * __nullable image, NSError * __nullable error) {
        if (image) {
            self.image = image;
        }
        if (block) {
            block(image,error);
        }
    }];
}
@end
