//
//  LazyDownloader.m
//  LazyLoader
//
//  Created by Sachin Sawant on 26/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import "LazyDownloader.h"

@implementation LazyDownloader

- (instancetype)initWithTarget:(ImageElement*)target
{
    self = [super init];
    if (self) {
        self.downloadTarget = target;
    }
    return self;
}

-(void) main {
    if(self.isCancelled) {return;}
    
    if(self.downloadTarget.downloadStatus == DownloadStatus_Completed) {
        return;
    }
    
    // Check if URL is valid
    NSURL *url = [NSURL URLWithString:self.downloadTarget.imageURL];
    if(url == nil) {
        NSLog(@"Failed to create URL");
        self.downloadTarget.downloadStatus = DownloadStatus_Failed;
        return;
    }
    
    if(self.isCancelled) {return;}
    
    NSLog(@"Downloading image for title %@", self.downloadTarget.name);
    
    // Download Image
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data == nil) {
        NSLog(@"Failed to get image for title %@",self.downloadTarget.name);
        self.downloadTarget.downloadStatus = DownloadStatus_Failed;
        return;
    }
    
    UIImage *downloadedImage = [UIImage imageWithData:data];
    if(downloadedImage == nil) {
        NSLog(@"Failed to create image from data for title %@", self.downloadTarget.name);
        self.downloadTarget.downloadStatus = DownloadStatus_Failed;
        return;
    }
    
    if(self.isCancelled) {return;}
    
    self.downloadTarget.downloadStatus = DownloadStatus_Completed;
    self.downloadTarget.image = downloadedImage;
    return;
    
}

@end
