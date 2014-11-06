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

static inline BOOL JJSizeEqual(JJSize s1, JJSize s2) {
    return (s1.width == s2.width && s1.height == s2.height && s1.depth == s2.depth);
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

static inline BOOL JJVec3Equal(JJVec3 v1, JJVec3 v2) {
    return (v1.x == v2.x && v1.y == v2.y && v1.z == v2.z);
}

struct JJRect3 {
    JJVec3 origin;
    JJSize size;
};
typedef struct JJRect3 JJRect3;

static inline JJRect3 JJRect3Make(CGFloat x, CGFloat y, CGFloat z, CGFloat width, CGFloat height, CGFloat depth) {
    JJRect3 rect; rect.origin.x = x; rect.origin.y = y; rect.origin.z = z; rect.size.width = width; rect.size.height = height; rect.size.depth = depth; return rect;
}

static inline BOOL JJRect3FullyOverlaps(JJRect3 container, JJRect3 rect) {
    return CGRectContainsRect(CGRectMake(container.origin.x, container.origin.y, container.size.width, container.size.height), CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
}

static inline NSString *NSStringFromJJRect3(JJRect3 rect) {
    return [NSString stringWithFormat:@"(%g %g %g; %g %g %g)", rect.origin.x, rect.origin.y, rect.origin.z, rect.size.width, rect.size.height, rect.size.depth];
}