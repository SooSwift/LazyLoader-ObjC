//
//  ContentManager.h
//  LazyLoader
//
//  Created by Sachin Sawant on 24/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

@interface ContentManager : NSObject

+ (void) getContentFromJSONFeedAtURL:(NSString*) urlString withCompletion:(void (^)(BOOL success, Content *jsonContent))completion;


@end
