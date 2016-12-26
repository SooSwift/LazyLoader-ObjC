//
//  ViewController.h
//  LazyLoader
//
//  Created by Sachin Sawant on 24/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"

@interface ViewController : UIViewController

@property (nonnull, atomic, strong) Content *feedContent;

@end

