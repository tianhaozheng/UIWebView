//
//  Componts.m
//  UIWebView
//
//  Created by 郑天昊 on 16/8/3.
//  Copyright © 2016年 rmitec. All rights reserved.
//

#import "ComponentBlock.h"
@implementation ComponentBlock

- (void)runBlock:(BlockType)block
{
    UIColor *corlor = [UIColor redColor];
    block(corlor);
}
@end
