//
//  Componts.h
//  UIWebView
//
//  Created by 郑天昊 on 16/8/3.
//  Copyright © 2016年 rmitec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^BlockType)(UIColor *Color);

@interface ComponentBlock : NSObject

- (void)runBlock:(BlockType )block;
@end
