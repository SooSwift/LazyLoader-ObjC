//
//  Content.m
//  LazyLoader
//
//  Created by Sachin Sawant on 24/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import "Content.h"

@implementation ImageElement

- (instancetype)initWithName:(NSString*)name Description:(NSString*)desc ImageURL:(NSString*)imageURL {

    self = [super init];
    if (self) {
        self.name = name;
        self.desc = desc;
        self.imageURL = imageURL;
        self.image = [UIImage imageNamed:@"placeholder"];
        self.downloadStatus = DownloadStatus_Default;
    }
    return self;
}

@end

@implementation Content

-(instancetype)initWithTitle:(NSString*)title images:(NSArray*)images {
    self = [super init];
    if (self) {
        self.title = title;
        self.images = images;
    }
    return self;
}

@end

