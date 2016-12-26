//
//  Content.h
//  LazyLoader
//
//  Created by Sachin Sawant on 24/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum DownloadStatus {
    DownloadStatus_Default,
    DownloadStatus_Completed,
    DownloadStatus_Failed
};

// Image with relative data and state
@interface ImageElement : NSObject

@property (strong, nonnull) NSString *name;
@property (strong, nonnull) NSString *desc;
@property (strong, nonnull) NSString *imageURL;
@property (strong, nonnull) UIImage *image;
@property (assign) enum DownloadStatus downloadStatus;

- (nonnull instancetype)initWithName:(nonnull NSString*)name Description:(nonnull NSString*)desc ImageURL:(nonnull NSString*)imageURL;

@end

// Content fetched from web having title and image collection
@interface Content:NSObject

@property (nonnull, strong) NSString *title;
@property (nonnull, strong) NSArray *images;

-(nonnull instancetype)initWithTitle:(nonnull NSString*)title images:(nonnull NSArray*)images;

@end
