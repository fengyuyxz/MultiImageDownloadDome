//
//  MDDDownloadImageTool.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "MDDDownloadImageTool.h"
#import "MDDImageCache.h"
#import "NSString+Base64.h"
@interface MDDDownloadImageTool();
@property(nonatomic,strong)NSOperationQueue *queue;
@property(nonatomic,strong)NSMutableDictionary *currentDownloadDic;
@end
@implementation MDDDownloadImageTool
-(NSOperationQueue *)queue{
    if (!_queue) {
        @synchronized (self) {
            _queue=[[NSOperationQueue alloc]init];
            _queue.maxConcurrentOperationCount = 5;
        }
        
    }
    return _queue;
}
-(NSMutableDictionary *)currentDownloadDic{
    if (!_currentDownloadDic) {
        _currentDownloadDic = [NSMutableDictionary dictionary];
    }
    return _currentDownloadDic;
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
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[MDDImageCache shareMDDImageCache]imageWithURL:imageURL];

        if (image) {
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(image,nil);
                });
                
            }
            return;
        }
        
        NSString *urlKey = [[imageURL absoluteString] base64];
        if (self.currentDownloadDic[urlKey]) {
            
            return;
        }
        
        NSBlockOperation *downloadOpt = [NSBlockOperation blockOperationWithBlock:^{
            
            CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    //        [NSThread sleepForTimeInterval:2];
            NSError *error;
            NSData *data = [NSData dataWithContentsOfURL:imageURL options:NSDataReadingUncached
     error:&error];
            UIImage *image = data?[UIImage imageWithData:data]:nil;
            [[MDDImageCache shareMDDImageCache] cacheImage:image url:imageURL];
            CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
            NSLog(@"%f -- %@",end-start,[NSThread currentThread]);
            
            [weakSelf.currentDownloadDic removeObjectForKey:urlKey];
            if (block) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                block(image,error);
                }];
            }
            [MDDImageCache saveImageData:data url:imageURL];
        }];
        weakSelf.currentDownloadDic[urlKey]=downloadOpt;
        [weakSelf.queue addOperation:downloadOpt];
    });
    
}
@end
