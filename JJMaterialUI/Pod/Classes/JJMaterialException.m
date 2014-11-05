//
//  JJMaterialException.m
//  Pods
//
//  Created by Jerry Wong on 11/4/14.
//
//

#import "JJMaterialException.h"

@implementation JJMaterialException

+ (NSString *)exceptionNameForType:(JJMaterialExceptionType) type {
    switch (type) {
        case JJMaterialExceptionTypeIllegalOperation:
            return @"IllegalOperation";
            break;
            
        default:
            return nil;
            break;
    }
}

+ (JJMaterialException *)exceptionWithType:(JJMaterialExceptionType)type {
    NSString *name = [JJMaterialException exceptionNameForType:type];
    JJMaterialException *exc = [[JJMaterialException alloc] initWithName:name reason:nil userInfo:nil];
    return exc;
}

@end
