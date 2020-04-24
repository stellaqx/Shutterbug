//
//  FlickerPhotosTableViewController.m
//  Shutterbug
//
//  Created by Qian on 4/22/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "FlickerPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickerPhotosTableViewController ()

@end

@implementation FlickerPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// updateUI
- (void)setPhotos:(NSArray *)photos {
    _photos  = photos;
    [self.tableView reloadData];
}

// MARK: - SplitView
- (BOOL)isInSplitView {
    id detail = self.splitViewController.viewControllers[1]; // if we are not in a split view, we are nil
    return detail == nil ? NO : YES;
}

// MARK: - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id detail = self.splitViewController.viewControllers[1]; // if we are not in a split view, we are nil
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:detail photo:self.photos[indexPath.row]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"FlickrPhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // configure the cell (display ui etc.)
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKey:FLICKR_PHOTO_DESCRIPTION];
    return cell;
}

#pragma mark - Navigation

-(void)prepareImageViewController:(ImageViewController *)imageVC photo:(NSDictionary *)photo {
    imageVC.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    imageVC.title = [photo valueForKey:FLICKR_PHOTO_TITLE];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([self isInSplitView]) {
        return;
    }
    // get the index path of the sender
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"displayPhoto"] && [segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
        ImageViewController *imageVC = (ImageViewController *)segue.destinationViewController;
        NSDictionary *photo = self.photos[indexPath.row];
        [self prepareImageViewController:imageVC photo:photo];
    }
}

/*
- (void)encodeWithCoder:(nonnull NSCoder *)coder;

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection;

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container;

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize;

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container;

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator;

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator;

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator;

- (void)setNeedsFocusUpdate;

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context;

- (void)updateFocusIfNeeded;
 
 */

@end
