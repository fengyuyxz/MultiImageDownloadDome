//
//  Single.h
//  MultiImageDownloadDome
//
//  Created by 颜学宙 on 2021/3/18.
//
#define shareInstance(name) +(instancetype)share##name


#define share(name) +(instancetype)share##name{\
return [[self alloc] init];\
}\
\
static id _instanceManager##name;\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    \
    dispatch_once(&onceToken, ^{\
        _instanceManager##name=[super allocWithZone:zone];\
    });\
    return _instanceManager##name;\
}\
-(id)copy{\
    return _instanceManager##name;\
}\
-(id)mutableCopy{\
    return _instanceManager##name;\
}

