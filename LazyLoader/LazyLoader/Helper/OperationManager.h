//
//  OperationManager.h
//  LazyLoader
//
//  Created by Sachin Sawant on 26/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationManager : NSObject

@property (nonnull, atomic, strong) NSOperationQueue *operationQueue;
@property (nonnull, atomic, strong) NSMutableDictionary *ongoingOperations;

-(void) reset;

@end
