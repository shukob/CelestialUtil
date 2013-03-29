#import "CMBasicSingleton.h"

static NSMutableDictionary *objectDictionary;
static NSMutableDictionary *lockDictionary;
@implementation CMBasicSingleton
+(void)lock{
	@synchronized(self){
		DLog(@"Locking %@", NSStringFromClass(self));
		[[lockDictionary objectForKey:NSStringFromClass(self)] lock];
	}
}
+(void)unlock{
	@synchronized(self){
		DLog(@"Unlocking %@", NSStringFromClass(self));
		[[lockDictionary objectForKey:NSStringFromClass(self)] unlock];
	}
}
+(id)instance{
	@synchronized(self){
        @synchronized(objectDictionary){
            if (!objectDictionary) {
                objectDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
            }
            if (![objectDictionary objectForKey:NSStringFromClass(self)]) {
                id this = [[self alloc]init];
                [objectDictionary setValue:this forKey:NSStringFromClass(self)];
                [this release];
            }
            
        }
        @synchronized(lockDictionary){
            if (!lockDictionary) {
                lockDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
            }
            if (![lockDictionary objectForKey:NSStringFromClass(self)]){
                NSRecursiveLock *lock = [[NSRecursiveLock alloc]init];
                [lockDictionary setValue:lock forKey:NSStringFromClass(self)];
                [lock release];
            }
        }
	}
    id res = [objectDictionary objectForKey:NSStringFromClass(self)];
    [res instanceCallback];
	return [objectDictionary objectForKey:NSStringFromClass(self)];
}

+(id)reInitialize{
    if ([objectDictionary objectForKey:NSStringFromClass(self)]) {
        [objectDictionary removeObjectForKey:NSStringFromClass(self)];
    }
    if ([lockDictionary objectForKey:NSStringFromClass(self)]){
        [lockDictionary removeObjectForKey:NSStringFromClass(self)];
    }
    return [self instance];
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if ([objectDictionary objectForKey:NSStringFromClass(self)] == nil) {
			id instance = [super allocWithZone:zone];
			if ([objectDictionary count] == 0) {
				objectDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
			}
			[objectDictionary setObject:instance forKey:NSStringFromClass(self)];
			return instance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)returnCount {
	return UINT_MAX;
}

- (oneway void)release {
  
}

- (id)autorelease {
	return self;
}

-(void)dealloc{
    [objectDictionary release];
    [lockDictionary release];
	[super dealloc];
}

-(void)instanceCallback{
    
}
@end
