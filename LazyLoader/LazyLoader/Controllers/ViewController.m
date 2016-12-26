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
#import "OperationManager.h"
#import "LazyDownloader.h"
#import "Constants.h"

#pragma mark- Private
@interface ViewController (Private)

-(void) fetchDataFromJSONFeed;
-(void) loadLazily:(ImageElement*)imageElement atIndexPath:(NSIndexPath*)indexPath;

@end

#pragma mark- View Controller Implementation
@implementation ViewController

#pragma mark- View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Configure Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefreshTableview) forControlEvents:UIControlEventValueChanged];
    
    //Configure TableView
    [self.contentTableView addSubview:self.refreshControl];
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    self.contentTableView.estimatedRowHeight = 350;
    self.contentTableView.tableFooterView = [[UIView alloc] init];
    
    self.downloadManager = [[OperationManager alloc] init];
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

-(void)loadLazily:(ImageElement *)imageElement atIndexPath:(NSIndexPath *)indexPath {
    
    //Leave images which are successful or failed
    if(imageElement.downloadStatus != DownloadStatus_Default) {
        NSLog(@"Download already in completed/failed for image with title: %@", imageElement.name);
        return;
    }
    NSIndexPath *indexPathKey = [NSIndexPath indexPathForRow:indexPath.row
                                                   inSection:indexPath.section];
    
    NSObject *downloadOperation = [self.downloadManager.ongoingOperations objectForKey:indexPathKey];
    if(downloadOperation != nil) {
        NSLog(@"Download already in progress for image with title: %@", imageElement.name);
        return;
    }
    
    LazyDownloader *lazyDownloader = [[LazyDownloader alloc] initWithTarget:imageElement];
    __weak LazyDownloader *weakLazyDownloader = lazyDownloader;     //use weak reference to operation to avoid retain cycle
    [lazyDownloader setCompletionBlock:^{
        if(weakLazyDownloader.isCancelled) {return;}
        [self.downloadManager.ongoingOperations removeObjectForKey:indexPathKey];
        if(weakLazyDownloader.isCancelled) {return;}
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Reloading tableview");
            [self.contentTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });
        
    }];
    
    [self.downloadManager.ongoingOperations setObject:lazyDownloader forKey:indexPathKey];
    [self.downloadManager.operationQueue addOperation:lazyDownloader];
}

-(void)onRefreshTableview {
    [self.refreshControl endRefreshing];
    [self.downloadManager reset];
    self.feedContent = [[Content alloc] initWithTitle:@"" images:[[NSArray alloc] init]];
    [self.contentTableView reloadData];
    [self fetchDataFromJSONFeed];
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
    
    // Update cell with available data
    ImageElement *imageElement = [self.feedContent.images objectAtIndex:indexPath.row];
    cell.imgView.image =imageElement.image;
    cell.nameLabel.text = imageElement.name;
    cell.descriptionLabel.text = imageElement.desc;
    
    // Load images lazily based on status
    UIActivityIndicatorView *progressView = [cell.imgView showProgressView];
    switch (imageElement.downloadStatus) {
        case DownloadStatus_Default:
            [self loadLazily:imageElement atIndexPath:indexPath];
            break;
        case DownloadStatus_Failed:
            cell.imgView.image = [UIImage imageNamed:@"noImage"];
        case DownloadStatus_Completed:
            [cell.imgView hideProgressView:progressView];
        default:
            break;
    }
    [cell layoutIfNeeded];
    return cell;
}

@end
