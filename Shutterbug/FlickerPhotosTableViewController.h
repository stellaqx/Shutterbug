//
//  FlickerPhotosTableViewController.h
//  Shutterbug
//
//  Created by Qian on 4/22/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* a generic flickr photo view controller, not tied to any data source */
@interface FlickerPhotosTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *photos;

@end

NS_ASSUME_NONNULL_END
