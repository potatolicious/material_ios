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
#import "JJMaterialManager.h"

@interface JJMaterialView ()
@property (nonatomic, strong) UIBezierPath *shadowPath;
@property (nonatomic, strong) CAShapeLayer *contentClipLayer;
@property (nonatomic, strong) CALayer *keyShadowLayer;
@property (nonatomic, strong) CALayer *ambientShadowLayer;
@end

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
    return [self initWithMatFrame:matFrame outlineType:JJMaterialViewOutlineTypeRect];
}

- (id)initWithMatFrame:(JJRect3)matFrame outlineType:(JJMaterialViewOutlineType)outlineType {
    self = [super initWithFrame:CGRectMake(matFrame.origin.x, matFrame.origin.y, matFrame.size.width, matFrame.size.height)];
    if (self) {
        _matFrame = matFrame;
        [self sharedInit];
        self.outlineType = outlineType;
    }
    return self;
}

- (void)sharedInit {
    self.outlineType = JJMaterialViewOutlineTypeRect;
    
    self.contentClipLayer = [[CAShapeLayer alloc] init];
    
    self.keyShadowLayer = [[CALayer alloc] init];
    self.keyShadowLayer.shadowColor = [UIColor blackColor].CGColor;
    self.ambientShadowLayer = [[CALayer alloc] init];
    self.ambientShadowLayer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.layer addSublayer:self.keyShadowLayer];
    [self.layer addSublayer:self.ambientShadowLayer];
    
    self.layer.zPosition = _matFrame.origin.z;
    
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.mask = self.contentClipLayer;
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
    [self didChangeValueForKey:@"matFrame"];
}

- (void)setMatFrame:(JJRect3)matFrame {
    BOOL zChanged = matFrame.origin.z != _matFrame.origin.z;
    BOOL sizeChanged = !JJSizeEqual(matFrame.size, _matFrame.size);
    [self willChangeValueForKey:@"matFrame"];
    _matFrame = matFrame;
    self.frame = CGRectMake(_matFrame.origin.x, _matFrame.origin.y, _matFrame.size.width, _matFrame.size.height);
    self.layer.zPosition = _matFrame.origin.z;
    [self didChangeValueForKey:@"matFrame"];
    if (sizeChanged)
        [self updateShadowShape];
    if (zChanged)
        [self updateShadowExtent];
}

- (void)didMoveToSuperview {
    // JJMaterialCanvas is immune to this check
    if (![self isKindOfClass:[JJMaterialCanvas class]] && ![self.superview isKindOfClass:[JJMaterialView class]]) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"JJMaterialView may only be inserted into JJMaterialCanvas or other JJMaterialViews" userInfo:nil];
    }
    [self updateShadowShape];
    [self updateShadowExtent];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; matFrame = %@>", NSStringFromClass([self class]), self, NSStringFromJJRect3(self.matFrame)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    self.keyShadowLayer.frame = self.bounds;
    self.ambientShadowLayer.frame = self.bounds;
}

#pragma mark - Layering and ordering

- (void)didChangeSize {
    [self updateShadowShape];
    [self updateShadowExtent];
}

- (void)didChangeElevation {
    [self.parentMaterialView needsZOrderCheckForChild:self];
    [self updateShadowExtent];
}

- (JJMaterialView *)parentMaterialView {
    return (JJMaterialView *)self.superview;
}

- (void)needsZOrderCheckForChild:(JJMaterialView *)view; {
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

#pragma mark - Shadowing

- (void)updateShadowShape {
    self.shadowPath = [self outlinePath];
    self.contentClipLayer.path = self.shadowPath.CGPath;
    self.keyShadowLayer.shadowPath = self.shadowPath.CGPath;
    self.ambientShadowLayer.shadowPath = self.shadowPath.CGPath;
}

- (void)updateShadowExtent {
    CGFloat altitude = self.matFrame.origin.z; // TODO real altitude here
    
    CGFloat baseKeyRadius = 1.0;
    CGFloat baseAmbientRadius = 1.0;
    CGFloat baseKeyOpacity = 0.45;
    CGFloat baseAmbientOpacity = 0;
    
    CGSize keyOffset = [JJMaterialManager sharedManager].keyLightDirection;
    keyOffset.width *= altitude * 2.0;
    keyOffset.height *= altitude * 2.0;
    
    self.keyShadowLayer.shadowOffset = keyOffset;
    self.keyShadowLayer.shadowOpacity = baseKeyOpacity;
    self.keyShadowLayer.shadowRadius = baseKeyRadius * (altitude * 1.5);
    
    self.ambientShadowLayer.shadowOffset = CGSizeZero;
    self.ambientShadowLayer.shadowOpacity = baseAmbientOpacity;
    self.ambientShadowLayer.shadowRadius = baseAmbientRadius * altitude;
}


- (void)setOutlineType:(JJMaterialViewOutlineType)outlineType {
    _outlineType = outlineType;
    [self updateShadowShape];
}

- (void)setOutlineRadius:(CGFloat)outlineRadius {
    _outlineRadius = outlineRadius;
    [self updateShadowShape];
}

- (void)setCustomOutlinePath:(UIBezierPath *)customOutlinePath {
    _customOutlinePath = customOutlinePath;
    if (self.outlineType == JJMaterialViewOutlineTypeCustom)
        [self updateShadowShape];
}

- (UIBezierPath *)outlinePath {
    switch (self.outlineType) {
        case JJMaterialViewOutlineTypeRect:
            return [UIBezierPath bezierPathWithRect:self.bounds];
        case JJMaterialViewOutlineTypeEllipse:
            return [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        case JJMaterialViewOutlineTypeRoundedRect:
            return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.outlineRadius];
        case JJMaterialViewOutlineTypeCustom:
            return self.customOutlinePath;
    }
}

@end
