//
//  ViewController.h
//  LazyLoader
//
//  Created by Sachin Sawant on 24/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationManager.h"
#import "Content.h"

@interface ViewController : UIViewController <UITableViewDataSource>

@property (nullable, weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonnull, atomic, strong) Content *feedContent;
@property (nonnull, atomic, strong) OperationManager *downloadManager;

@end

