//
//  OperationManager.m
//  LazyLoader
//
//  Created by Sachin Sawant on 26/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import "OperationManager.h"

@implementation OperationManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ongoingOperations = [[NSMutableDictionary alloc] init];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 3; //Execute maximum 3 concurrent operations
    }
    return self;
}

- (void) reset {
    [self.operationQueue cancelAllOperations];
    [self.ongoingOperations removeAllObjects];
}

- (void) suspendAll {
    self.operationQueue.suspended = true;
}

- (void) resumeAll {
    self.operationQueue.suspended = false;
}

@end
