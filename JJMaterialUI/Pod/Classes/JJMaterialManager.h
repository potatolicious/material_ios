//
//  JJMaterialManager.h
//  Pods
//
//  Created by Jerry Wong on 11/5/14.
//
//

#import <Foundation/Foundation.h>

@interface JJMaterialManager : NSObject

@property (nonatomic, assign) CGSize keyLightDirection;

+ (JJMaterialManager *)sharedManager;

@end
