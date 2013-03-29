#import <Foundation/Foundation.h>

#define CMBasicSingletonPerformanceHack static id _______actualInstance; \
+(id)instance{ \
@synchronized(self){ \
    if (!_______actualInstance) { \
        _______actualInstance = [super instance]; \
    } \
    return _______actualInstance; \
}\
} \

@interface CMBasicSingleton : NSObject {

}
-(void)instanceCallback;
+(id)instance;
+(void)lock;
+(void)unlock;
+(id)reInitialize;
@end
