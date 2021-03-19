//
//  MDDImageCache.h
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Single.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDDImageCache : NSObject
shareInstance(MDDImageCache);
-(UIImage *)imageWithURL:(NSURL *)url;

-(void)cacheImage:(UIImage *)image url:(NSURL *)url;
+(void)saveImageData:(NSData *)data url:(NSURL *)url;
+(void)clearDisk;
+(void)clearMemory;
@end

NS_ASSUME_NONNULL_END
