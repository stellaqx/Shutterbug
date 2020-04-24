//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Qian on 4/21/20.
//  Copyright © 2020 Stella Xu. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

// MARK: - Getters & Setters
- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    // because the setImage is called when we set the URL
    _scrollView.contentSize = self.image? [self.image size] : CGSizeZero;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.delegate = self; // set the delegate and implement the method there
}

// MARK: - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// MARK: - imageURL, imageView and image
- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    // synchronously donwloading it from the web emm blocking mainQ
    // self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
    // asynchronously download
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration]; // this is one time thing, there's default and background config too
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL * _Nullable localfile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (response && [response.URL isEqual:self.imageURL]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                __weak __typeof__(self) weakSelf = self;
                // update the UI in the mainQ, without holding self in a mutual dead lock
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.image = image;
                });
            }
        }
    }];
    [task resume];
}

- (UIImageView *)imageView {
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    
    return _imageView; //reference by instance variable
}

// no need to have @synthesize because we're not reference by instance variable
- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image? [self.image size] : CGSizeZero;
    [self.spinner stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.imageView];
    [self.spinner startAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
