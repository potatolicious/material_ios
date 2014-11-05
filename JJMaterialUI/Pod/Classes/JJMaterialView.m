//
//  JJMaterialView.m
//  Pods
//
//  Created by Jerry Wong on 11/4/14.
//
//

#import <QuartzCore/QuartzCore.h>
#import "JJMaterialView.h"
#import "JJMaterialException.h"
#import "JJMaterialCanvas.h"

@implementation JJMaterialView

- (id)initWithMatFrame:(JJRect3)matFrame {
    self = [super initWithFrame:CGRectMake(matFrame.origin.x, matFrame.origin.y, matFrame.size.width, matFrame.size.height)];
    if (self) {
        _matFrame = matFrame;
        self.layer.zPosition = _matFrame.origin.z;
        [self needsShadowCheck];
        [self needsZOrderCheck];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self willChangeValueForKey:@"matFrame"];
    _matFrame.origin.x = frame.origin.x;
    _matFrame.origin.y = frame.origin.y;
    _matFrame.size.width = frame.size.width;
    _matFrame.size.height = frame.size.height;
    [self didChangeValueForKey:@"matFrame"];
}

- (void)setMatFrame:(JJRect3)matFrame {
    BOOL zChanged = matFrame.origin.z != _matFrame.origin.z;
    [self willChangeValueForKey:@"matFrame"];
    _matFrame = matFrame;
    self.frame = CGRectMake(_matFrame.origin.x, _matFrame.origin.y, _matFrame.size.width, _matFrame.size.height);
    self.layer.zPosition = _matFrame.origin.z;
    [self didChangeValueForKey:@"matFrame"];
    [self needsShadowCheck];
    if (zChanged)
        [self needsZOrderCheck];
}

- (void)didMoveToSuperview {
    if (![self.superview isKindOfClass:[JJMaterialCanvas class]]) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"JJMaterialView may only be inserted into JJMaterialCanvas objects" userInfo:nil];
    }
}

- (JJMaterialCanvas *)parentCanvas {
    return (JJMaterialCanvas *)self.superview;
}

- (void)needsZOrderCheck {
    
}

- (void)needsShadowCheck {
    
}

@end
