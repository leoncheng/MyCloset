//
//  MCFoundation.h
//  MyCloset
//
//  Created by mmcl on 11-9-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMath.h"

#define MC_DECLARE_AS_SINGLETON(interfaceName)                          \
+ (interfaceName*)SharedInstance;                                               \
+ (void)DestroyInstance;


#define MC_DEFINE_SINGLETON(interfaceName)								\
static interfaceName* interfaceName##Instance = nil;                            \
+ (interfaceName*) SharedInstance												\
{                                                                               \
if (interfaceName##Instance == nil)                                         \
interfaceName##Instance = [[interfaceName alloc] init];                 \
return interfaceName##Instance;												\
}																				\
\
+ (void)DestroyInstance                                                         \
{																				\
if (interfaceName##Instance != nil)                                         \
{                                                                           \
[interfaceName##Instance release];                                      \
interfaceName##Instance = nil;                                          \
}                                                                           \
}

#define MCSAFERELEASE(p)  \
if (p != nil)        \
{                    \
[p release];     \
p = nil;         \
}

@interface MCFoundation : NSObject {

}

@end
