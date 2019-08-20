//
//  UIView+DSHybrid.m
//  DSHybridApp
//
//  Created by Sanghong Han on 04/05/2019.
//  Copyright © 2019 directionsoft. All rights reserved.
//

#import "UIView+Shop.h"

@implementation UIView (Shop)

- (UIViewController *)parentViewController
{
    /// Finds the view's view controller.
    // Take the view controller class object here and avoid sending the same message iteratively unnecessarily.
    Class vcc = [UIViewController class];
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: vcc])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

@end
