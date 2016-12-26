//
//  ViewController.m
//  LazyLoader
//
//  Created by Sachin Sawant on 24/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import "ViewController.h"
#import "ContentManager.h"
#import "UIView+Progress.h"
#import "LazyCell.h"
#import "Constants.h"

@interface ViewController (Private)
-(void) fetchDataFromJSONFeed;
@end

@implementation ViewController

#pragma mark- View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Configure TableView
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    self.contentTableView.estimatedRowHeight = 350;
    
    [self fetchDataFromJSONFeed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Helper Methods
-(void) fetchDataFromJSONFeed {
    UIActivityIndicatorView *progressView = [self.view showProgressView];
    [ContentManager getContentFromJSONFeedAtURL:JSONFeedURL withCompletion:^(BOOL success, Content *jsonContent) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideProgressView:progressView];
        });
        
        //Check if fetching the data is successful
        if(success == false || jsonContent == nil)   {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to fetch data" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:true completion:nil];
            });
        }
        
        //Success
        self.feedContent = jsonContent;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = self.feedContent.title;
            [self.contentTableView reloadData];
        });
        
    }];
}


#pragma mark- TableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedContent.images.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LazyCell *cell = (LazyCell*)[tableView dequeueReusableCellWithIdentifier:@"lazyCell"];
    
    if(cell == nil) {
        cell = [[LazyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lazyCell"];
    }
    
    ImageElement *imageElement = [self.feedContent.images objectAtIndex:indexPath.row];
    cell.imgView.image =imageElement.image;
    cell.nameLabel.text = imageElement.name;
    cell.descriptionLabel.text = imageElement.desc;
    
    return cell;
}

@end
