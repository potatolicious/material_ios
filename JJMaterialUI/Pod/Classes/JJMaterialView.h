//
//  JJMaterialView.h
//  Pods
//
//  Created by Jerry Wong on 11/4/14.
//
//

#import <UIKit/UIKit.h>
#import "JJMaterialUtils.h"

typedef NS_ENUM(int, JJMaterialViewOutlineType) {
    JJMaterialViewOutlineTypeRect,
    JJMaterialViewOutlineTypeRoundedRect,
    JJMaterialViewOutlineTypeEllipse,
    JJMaterialViewOutlineTypeCustom
};

@interface JJMaterialView : UIView

@property (nonatomic, assign) JJRect3 matFrame;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) JJMaterialViewOutlineType outlineType;
@property (nonatomic, assign) CGFloat outlineRadius;
@property (nonatomic, strong) UIBezierPath *customOutlinePath;

- (id)initWithMatFrame:(JJRect3)matFrame;
- (id)initWithMatFrame:(JJRect3)matFrame outlineType:(JJMaterialViewOutlineType)outlineType;

- (void)setOutlineRadius:(CGFloat)outlineRadius animated:(BOOL)animated duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;

- (JJMaterialView *)parentMaterialView;

@end
