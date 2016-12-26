//
//  ContentManager.m
//  LazyLoader
//
//  Created by Sachin Sawant on 24/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import "ContentManager.h"
#import "Content.h"

@interface ContentManager (Private)
+(nullable Content*)parseContentObjectFromJSON:(NSDictionary*)jsonDictonary;
@end

@implementation ContentManager

+(void)getContentFromJSONFeedAtURL:(NSString *)urlString withCompletion:(void (^)(BOOL, Content *))completion {
    
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //check for http response
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if(httpResponse == nil || httpResponse.statusCode != 200) {
            NSLog(@"Unable to receive response from url : %@", urlString);
            completion(false, nil);
        }
        
        if(error != nil) {
            NSLog(@"Received error while fetching JSON data from url : %@", urlString);
            completion(false, nil);
        }
    
        if(data == nil) {
            NSLog(@"Failed to receive data from url : %@", urlString);
            completion(false, nil);
        }
        
        //INFO: This json feed is encoded with ISOLatin1. Convert it to UTF-8 before serialization to be successful
        NSString *latinEncodedString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        if(latinEncodedString == nil) {
            NSLog(@"Expecting ISOLatin1 encoded data but found otherwize");
            completion(false, nil);
        }
        NSData *utf8Data = [latinEncodedString dataUsingEncoding:NSUTF8StringEncoding];
        if(utf8Data == nil) {
            NSLog(@"Expecting ISOLatin1 encoded data but found otherwize");
            completion(false, nil);
        }
        
        //Parse JSON
        NSError *parseError;
        NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:utf8Data options:0 error:&parseError];
        if(jsonDictionary == nil) {
            NSLog(@"Error parsing json received from URL %@: error : %@", urlString, parseError);
            completion(false, nil);
        }
        
        Content *parsedContent = [self parseContentObjectFromJSON:jsonDictionary];
        if(parsedContent == nil) {
            NSLog(@"Failed to parse json data received from URL %@", urlString);
            completion(false, nil);
        }
        
        completion(true, parsedContent);
        
    }];
    [dataTask resume];
    
}

+(nullable Content*)parseContentObjectFromJSON:(NSDictionary *)jsonDictonary {
    NSString *title = (NSString*)[jsonDictonary objectForKey:@"title"];
    if(title == nil) {
        return nil;
    }
    
    NSArray *imageArray = (NSArray*)[jsonDictonary objectForKey:@"rows"];
    if(imageArray == nil) {
        return nil;
    }
    
    NSMutableArray *imageElements = [[NSMutableArray alloc] initWithCapacity:imageArray.count];
    for(NSDictionary* imageDictionary in imageArray) {
        NSString *imageName = (NSString*)[imageDictionary objectForKey:@"title"];
        if(imageName == nil) { imageName = @"Unknown"; }
        
        NSString *imageDesc = (NSString*)[imageDictionary objectForKey:@"description"];
        if(imageDesc == nil) { imageDesc = @""; }
        
        NSString *imageHref = (NSString*)[imageDictionary objectForKey:@"imageHref"];
        if(imageHref == nil) { imageHref = @""; }
        
        ImageElement *image = [[ImageElement alloc] initWithName:imageName Description:imageDesc ImageURL:imageHref];
        [imageElements addObject:image];
    }
    
    return [[Content alloc] initWithTitle:title images:imageElements];
}

@end
