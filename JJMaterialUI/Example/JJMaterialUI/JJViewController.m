//
//  JJViewController.m
//  JJMaterialUI
//
//  Created by Jerry Wong on 11/04/2014.
//  Copyright (c) 2014 Jerry Wong. All rights reserved.
//

#import "JJMaterialUI.h"
#import "JJViewController.h"

@interface JJViewController ()

@property (nonatomic, strong) JJMaterialCanvas *canvas;
@property (nonatomic, strong) NSMutableArray *subMatViews;

@end

@implementation JJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.canvas = [[JJMaterialCanvas alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.canvas];
    
    self.subMatViews = [[NSMutableArray alloc] init];
    
    JJMaterialView *view = [[JJMaterialView alloc] initWithMatFrame:JJRect3Make(140, 140, 3, 100, 100, 1) outlineType:JJMaterialViewOutlineTypeRoundedRect];
    view.outlineRadius = 6.0;
    view.contentView.backgroundColor = [UIColor redColor];
    [self.canvas addSubview:view];
    [self.subMatViews addObject:view];
    
    view = [[JJMaterialView alloc] initWithMatFrame:JJRect3Make(140, 10, 10, 100, 100, 1)];
    view.contentView.backgroundColor = [UIColor greenColor];
    [self.canvas addSubview:view];
    [self.subMatViews addObject:view];
    
    view = [[JJMaterialView alloc] initWithMatFrame:JJRect3Make(10, 10, 1, 100, 100, 1) outlineType:JJMaterialViewOutlineTypeRoundedRect];
    view.outlineRadius = 6.0;
    view.contentView.backgroundColor = [UIColor blueColor];
    [self.canvas addSubview:view];
    [self.subMatViews addObject:view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animate];
}

- (void)animate {
    JJMaterialView *view = self.subMatViews[0];
    JJRect3 f = view.matFrame;
    if (f.origin.z == 1.0)
        f.origin.z = 5.0;
    else
        f.origin.z = 1.0;
    CGFloat radius = (view.outlineRadius == 6.0) ? 50.0 : 6.0;
    
    JJMaterialView *view2 = self.subMatViews[1];
    JJRect3 f2 = view2.matFrame;
    if (f2.origin.z == 10.0)
        f2.origin.z = 3.0;
    else
        f2.origin.z = 10.0;

    [UIView animateWithDuration:1.0 animations:^{
        view.matFrame = f;
        view2.matFrame = f2;
        [view setOutlineRadius:radius animated:YES duration:0.5 delay:0.0 options:0 completion:^(BOOL finished) {
            // nop
        }];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animate];
        });
    }];
}

@end
