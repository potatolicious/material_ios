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

#pragma mark - Initializers

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

#pragma mark - Overrides from UIView

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
    if (zChanged)
        [self needsZOrderCheck];
    [self willChangeValueForKey:@"matFrame"];
    _matFrame = matFrame;
    self.frame = CGRectMake(_matFrame.origin.x, _matFrame.origin.y, _matFrame.size.width, _matFrame.size.height);
    self.layer.zPosition = _matFrame.origin.z;
    [self didChangeValueForKey:@"matFrame"];
    [self needsShadowCheck];
}

- (void)didMoveToSuperview {
    // JJMaterialCanvas is immune to this check
    if (![self isKindOfClass:[JJMaterialCanvas class]] && ![self.superview isKindOfClass:[JJMaterialView class]]) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"JJMaterialView may only be inserted into JJMaterialCanvas or other JJMaterialViews" userInfo:nil];
    }
    [self needsShadowCheck];
    [self needsZOrderCheck];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.parentMaterialView didRemoveSubview:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; matFrame = %@>", NSStringFromClass([self class]), self, NSStringFromJJRect3(self.matFrame)];
}

#pragma mark - Layering and ordering

- (JJMaterialView *)parentMaterialView {
    return (JJMaterialView *)self.superview;
}

- (void)needsZOrderCheck:(JJMaterialView *)view; {
    BOOL passesZOrderCheck = YES;
    NSUInteger idx = [self.subviews indexOfObject:view];
    if (idx > 1) {
        JJMaterialView *prevView = (JJMaterialView *)[self.subviews objectAtIndex:idx - 1];
        passesZOrderCheck = prevView.matFrame.origin.z <= view.matFrame.origin.z;
    }
    if (passesZOrderCheck && idx < [self.subviews count] - 1) {
        JJMaterialView *nextView = (JJMaterialView *)[self.subviews objectAtIndex:idx + 1];
        passesZOrderCheck = nextView.matFrame.origin.z >= view.matFrame.origin.z;
    }
    if (!passesZOrderCheck) {
        NSArray *sorted = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(JJMaterialView *v1, JJMaterialView *v2) {
            if (![v1 isKindOfClass:[JJMaterialView class]] && [v2 isKindOfClass:[JJMaterialView class]])
                return NSOrderedAscending;
            else if (![v2 isKindOfClass:[JJMaterialView class]] && [v1 isKindOfClass:[JJMaterialView class]])
                return NSOrderedDescending;
            if (v2.matFrame.origin.z > v1.matFrame.origin.z)
                return NSOrderedAscending;
            else if (v2.matFrame.origin.z < v1.matFrame.origin.z)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
        for (int i = 0 ; i < [sorted count] ; i++) {
            JJMaterialView *view = sorted[i];
            [self insertSubview:view atIndex:i];
        }
    }
}

- (void)needsZOrderCheck {
    [self.parentMaterialView needsZOrderCheck:self];
}

- (void)needsShadowCheck:(JJMaterialView *)view {
    
}

- (void)needsShadowCheck {
    [self.parentMaterialView needsShadowCheck:self];
}

- (void)didRemoveSubview:(UIView *)view {
    // TODO? Do we need this?
}

@end
