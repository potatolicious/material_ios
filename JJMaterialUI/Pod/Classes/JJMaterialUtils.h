//
//  JJMaterialUtils.h
//  Pods
//
//  Created by Jerry Wong on 11/4/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

struct JJSize {
    CGFloat width;
    CGFloat height;
    CGFloat depth;
};
typedef struct JJSize JJSize;

static inline JJSize JJSizeMake(CGFloat width, CGFloat height, CGFloat depth) {
    JJSize size; size.width = width; size.height = height; size.depth = depth; return size;
}

struct JJVec3 {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};
typedef struct JJVec3 JJVec3;

static inline JJVec3 JJVec3Make(CGFloat x, CGFloat y, CGFloat z) {
    JJVec3 vec; vec.x = x; vec.y = y; vec.z = z; return vec;
}

struct JJRect3 {
    JJVec3 origin;
    JJSize size;
};
typedef struct JJRect3 JJRect3;

static inline JJRect3 JJRect3Make(CGFloat x, CGFloat y, CGFloat z, CGFloat width, CGFloat height, CGFloat depth) {
    JJRect3 rect; rect.origin.x = x; rect.origin.y = y; rect.origin.z = z; rect.size.width = width; rect.size.height = height; rect.size.depth = depth; return rect;
}