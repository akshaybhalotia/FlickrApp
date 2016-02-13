//
//  FlickrCollectionViewCell.h
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIView *imageDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
