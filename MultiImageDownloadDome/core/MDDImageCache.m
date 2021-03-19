//
//  MDDImageCache.m
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//

#import "MDDImageCache.h"
#import "NSString+Base64.h"
#define IMG_CACHE_NAME @"MDDImgCache"
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
    if (!(key&&self.imageDic[key])&&image) {
        @synchronized (self.imageDic) {
            self.imageDic[key] = image;
        }
        
        
    }
}
+(void)clearDisk{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDic = [NSString stringWithFormat:@"%@/",[[self  cachePaht] stringByAppendingPathComponent:IMG_CACHE_NAME]];
    NSError *error;
    if (![fileManager removeItemAtPath:cacheDic error:&error]) {
        NSLog(@"%@",error);
    }
}
-(void)clearMemory{
    @synchronized (self) {
        [self.imageDic removeAllObjects];
    }
}
+(void)clearMemory{
    [[self shareMDDImageCache]clearMemory];
}
+(void)saveImageData:(NSData *)data url:(NSURL *)url{
    [[MDDImageCache shareMDDImageCache]saveImageData:data url:url];
}
-(void)saveImageData:(NSData *)data url:(NSURL *)url
{
    if (data&&url) {
        NSString *name = [[url absoluteString]base64];
        NSString *cacheDic = [[[self class] cachePaht] stringByAppendingPathComponent:IMG_CACHE_NAME];
        NSString *path = [cacheDic stringByAppendingPathComponent:name];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:cacheDic isDirectory:nil]) {
            
            @synchronized (self) {
                NSError *error;
                BOOL flag=[fileManager createDirectoryAtPath:cacheDic withIntermediateDirectories:NO attributes:nil error:&error];
                if (!flag) {
                    NSLog(@"创建文件夹失败 error  = %@",error);
                }
            }
                
            
        }
        if (![fileManager fileExistsAtPath:path]) {
            NSError *error;
            BOOL flag= [fileManager createFileAtPath:path contents:data attributes:@{NSFileGroupOwnerAccountName:@"MDD"}];
                if (!flag) {
                    NSLog(@"写入文件失败 %@",error);
                }
        }
    }
}
    
+(NSString *)cachePaht{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);;
    NSString *path = [paths firstObject];
    return path;
}
-(UIImage *)imageWithURL:(NSURL *)url{
    
    NSString *key = [self keyWithURL:url];
    UIImage *image = self.imageDic[key];
    if (!image) {
        NSString *cacheDic = [[[self class] cachePaht] stringByAppendingPathComponent:IMG_CACHE_NAME];
        NSString *path = [cacheDic stringByAppendingPathComponent:key];
        NSError *error;
        NSData *imgData = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached
 error:&error];
        if (imgData) {
            image=[UIImage imageWithData:imgData];
            @synchronized (self) {
                self.imageDic[key] = image;
            }
            
        }
        if (error) {
            
        }
    }
    return image;
}
-(NSString *)keyWithURL:(NSURL *)url{
    NSString *urlStr = [url absoluteString];
    NSString *key = [urlStr base64];
    return key;
}

@end
