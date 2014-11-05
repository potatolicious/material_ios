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

- (id)init {
    self = [super init];
    if (self) {
        _matFrame = JJRect3Make(0, 0, 1, 0, 0, 1);
        [self sharedInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _matFrame = JJRect3Make(frame.origin.x, frame.origin.y, 1, frame.size.width, frame.size.height, 1);
        [self sharedInit];
    }
    return self;
}

- (id)initWithMatFrame:(JJRect3)matFrame {
    self = [super initWithFrame:CGRectMake(matFrame.origin.x, matFrame.origin.y, matFrame.size.width, matFrame.size.height)];
    if (self) {
        _matFrame = matFrame;
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit {
    self.layer.zPosition = _matFrame.origin.z;
    
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contentView];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self willChangeValueForKey:@"matFrame"];
    _matFrame.origin.x = frame.origin.x;
    _matFrame.origin.y = frame.origin.y;
    _matFrame.size.width = frame.size.width;
    _matFrame.size.height = frame.size.height;
    self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
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
    [self needsShadowCheck];
    [self needsZOrderCheck];
}

- (JJMaterialCanvas *)parentCanvas {
    return (JJMaterialCanvas *)self.superview;
}

- (void)needsZOrderCheck {
    
}

- (void)needsShadowCheck {
    
}

@end
