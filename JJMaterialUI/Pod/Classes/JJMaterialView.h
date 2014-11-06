//
//  JJMaterialView.h
//  Pods
//
//  Created by Jerry Wong on 11/4/14.
//
//

#import <UIKit/UIKit.h>
#import "JJMaterialUtils.h"

@interface JJMaterialView : UIView

@property (nonatomic, assign) JJRect3 matFrame;
@property (nonatomic, strong) UIView *contentView;

- (id)initWithMatFrame:(JJRect3)matFrame;

- (JJMaterialView *)parentMaterialView;

- (void)needsZOrderCheck;
- (void)needsShadowCheck;

@end
