//
//  UIView+Progress.m
//  LazyLoader
//
//  Created by Sachin Sawant on 26/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Progress.h"

@implementation UIView (Progress)

- (UIActivityIndicatorView*) showProgressView {
    UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    progressView.center = self.center;
    [progressView startAnimating];
    [self addSubview:progressView];
    return progressView;
}

- (void) hideProgressView:(UIActivityIndicatorView*) progressView {
    [progressView stopAnimating];
    [progressView removeFromSuperview];
}



@end