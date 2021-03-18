//
//  MDDImageCache.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "MDDImageCache.h"
@interface MDDImageCache()
@property(nonatomic,strong)NSMutableDictionary *imageDic;
@end
@implementation MDDImageCache
-(void)dealloc{
    
}
share(MDDImageCache)
-(NSMutableDictionary *)imageDic{
    if (!_imageDic) {
        @synchronized (self) {
            _imageDic = [[NSMutableDictionary alloc]init];
        }
        
    }
    return _imageDic;
}
-(void)cacheImage:(UIImage *)image url:(NSURL *)url{
    NSString *key = [self keyWithURL:url];
    if (!(key&&self.imageDic[key])) {
        @synchronized (self.imageDic) {
            self.imageDic[key] = image;
        }
        
    }
}
-(UIImage *)imageWithURL:(NSURL *)url{
    
    NSString *key = [self keyWithURL:url];
    
    return self.imageDic[key];
}
-(NSString *)keyWithURL:(NSURL *)url{
    NSString *urlStr = [url absoluteString];
    NSString *key = [self base64:urlStr];
    return key;
}
-(NSString *)base64:(NSString *)data
{
       NSData *sData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSData *base64Data = [sData base64EncodedDataWithOptions:0];
        NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
  
    return baseString;
}
@end
