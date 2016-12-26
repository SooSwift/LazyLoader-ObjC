//
//  UIView+Progress.h
//  LazyLoader
//
//  Created by Sachin Sawant on 26/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#ifndef UIView_Progress_h
#define UIView_Progress_h

#import <UIKit/UIKit.h>

@interface UIView (Progress)

- (UIActivityIndicatorView*) showProgressView;
- (void) hideProgressView:(UIActivityIndicatorView*) progressView;

@end

#endif /* UIView_Progress_h */
