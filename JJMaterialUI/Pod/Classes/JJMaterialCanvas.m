//
//  JJMaterialCanvas.m
//  Pods
//
//  Created by Jerry Wong on 11/5/14.
//
//

#import "JJMaterialCanvas.h"

// JJMaterialCanvas is a special case of JJMaterialView that is guaranteed to have its
// top surface be at z=0

@implementation JJMaterialCanvas

- (id)init {
    self = [super init];
    if (self) {
        self.matFrame = JJRect3Make(0, 0, 0, 0, 0, 1);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.matFrame = JJRect3Make(frame.origin.x, frame.origin.y, 0, frame.size.width, frame.size.height, 1);
    }
    return self;
}

- (id)initWithMatFrame:(JJRect3)matFrame {
    matFrame.origin.z = 0.0;
    self = [super initWithMatFrame:matFrame];
    if (self) {
        
    }
    return self;
}

- (JJMaterialView *)parentMaterialView {
    return nil;
}

@end
