//
//  MDDDownloadImageTool.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "MDDDownloadImageTool.h"
#import "MDDImageCache.h"
@interface MDDDownloadImageTool();
@property(nonatomic,strong)NSOperationQueue *queue;
@end
@implementation MDDDownloadImageTool
-(NSOperationQueue *)queue{
    if (!_queue) {
        @synchronized (self) {
            _queue=[[NSOperationQueue alloc]init];
        }
        
    }
    return _queue;
}
share(MDDDownloadImageTool)

-(void)downloadImage:(NSURL *)imageURL completion:(void(^)(UIImage *__nullable image,NSError *__nullable error))block{
    if (!imageURL) {
        if (block) {
            NSError *error = [NSError errorWithDomain:@"url empty" code:10000 userInfo:@{@"info":@"图片地址为空"}];
            block(nil,error);
        }
        return;
    }
    UIImage *image = [[MDDImageCache shareMDDImageCache]imageWithURL:imageURL];
    if (image) {
        if (block) {
            block(image,nil);
        }
        return;
    }
    NSBlockOperation *downloadOpt = [NSBlockOperation blockOperationWithBlock:^{
        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:imageURL options:NSDataReadingUncached
 error:&error];
        UIImage *image = [UIImage imageWithData:data];
        [[MDDImageCache shareMDDImageCache] cacheImage:image url:imageURL];
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"%f - %@",end-start,[NSThread currentThread]);
        if (block) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            block(image,error);
            }];
            
        }
    }];
    [self.queue addOperation:downloadOpt];
}
@end
