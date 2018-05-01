//
//  BaseController.m
//  ShopCommon
//
//  Created by Sanghong Han on 2018. 5. 1..
//  Copyright © 2018년 pionnet. All rights reserved.
//

#import "BaseController.h"

@interface BaseController () <UIGestureRecognizerDelegate>

@end

@implementation BaseController

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
