//
//  JJMaterialException.h
//  Pods
//
//  Created by Jerry Wong on 11/4/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, JJMaterialExceptionType) {
    JJMaterialExceptionTypeIllegalOperation = 1000
};

@interface JJMaterialException : NSException

+ (JJMaterialException *)exceptionWithType:(JJMaterialExceptionType)type;

@end
