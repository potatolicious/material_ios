//
//  JJMaterialManager.m
//  Pods
//
//  Created by Jerry Wong on 11/5/14.
//
//

#import "JJMaterialManager.h"

@implementation JJMaterialManager

+ (JJMaterialManager *)sharedManager {
    static JJMaterialManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JJMaterialManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.keyLightDirection = CGSizeMake(0, 2);
    }
    return self;
}

@end