//
//  MDDDownloadImageTool.h
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Single.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDDDownloadImageTool : NSObject
shareInstance(MDDDownloadImageTool);
-(void)downloadImage:(NSURL *)imageURL completion:(void(^)(UIImage * __nullable image,NSError * __nullable error))block;
@end

NS_ASSUME_NONNULL_END
