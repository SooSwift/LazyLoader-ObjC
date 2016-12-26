//
//  LazyDownloader.h
//  LazyLoader
//
//  Created by Sachin Sawant on 26/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

@interface LazyDownloader : NSOperation

@property (nonnull, strong) ImageElement *downloadTarget;

- (nonnull instancetype)initWithTarget:(nonnull ImageElement*)target;
@end
