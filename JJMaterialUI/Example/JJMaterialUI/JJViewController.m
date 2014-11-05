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
    
    JJMaterialView *view = [[JJMaterialView alloc] initWithMatFrame:JJRect3Make(50, 50, 3, 100, 100, 1)];
    view.backgroundColor = [UIColor redColor];
    [self.canvas addSubview:view];
    [self.subMatViews addObject:view];
    
    view = [[JJMaterialView alloc] initWithMatFrame:JJRect3Make(100, 100, 5, 100, 100, 1)];
    view.backgroundColor = [UIColor greenColor];
    [self.canvas addSubview:view];
    [self.subMatViews addObject:view];
    
    view = [[JJMaterialView alloc] initWithMatFrame:JJRect3Make(10, 10, 1, 100, 100, 1)];
    view.backgroundColor = [UIColor blueColor];
    [self.canvas addSubview:view];
    [self.subMatViews addObject:view];
    
}

@end
