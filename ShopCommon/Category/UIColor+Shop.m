//
//  UIColor+Shop.m
//  ShopCommon
//
//  Created by HanSanghong on 2016. 8. 26..
//  Copyright © 2016년 pionnet. All rights reserved.
//

#import "UIColor+Shop.h"

@implementation UIColor (Shop)

- (UIImage *)createImage
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

@end
