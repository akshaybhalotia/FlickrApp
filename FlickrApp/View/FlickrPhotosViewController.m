//
//  FlickrPhotosViewController.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright (c) 2016 Akshay Bhalotia. All rights reserved.
//

#import "FlickrCollectionViewCell.h"
#import "FlickrPhoto.h"
#import "ImageStreamController.h"
#import "FlickrPhotosViewController.h"

static NSString *const CELL_IDENTIFIER = @"flickrCell";

static NSString *const ERROR = @"An error occured";
static NSString *const MESSAGE = @"We couldn't establish a connection. Please try again later.";
static NSString *const TITLE_OK = @"OK";

@interface FlickrPhotosViewController () <ImageStreamProtocol, UICollectionViewDelegateFlowLayout> {
    ImageStreamController *imageStreamController;
    NSMutableArray *flickrPhotos;
    NSMutableArray *selectedCells;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityIndicator;

@end

@implementation FlickrPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    flickrPhotos = [NSMutableArray array];
    imageStreamController = [ImageStreamController new];
    imageStreamController.streamDelegate = self;
    selectedCells = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mainActivityIndicator startAnimating];
    
    [imageStreamController fetchPhotoList];
}

#pragma mark - ImageStreamProtocol methods

-(void)doneFetchingList:(NSArray *)list withSuccess:(BOOL)success {
    [self.mainActivityIndicator stopAnimating];
    flickrPhotos = [list mutableCopy];
    if (success) {
        [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:ERROR message:MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:TITLE_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okAction];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

-(void)doneDownloadingPhoto:(FlickrPhoto *)photo forIndexPath:(NSIndexPath *)indexPath {
    [flickrPhotos replaceObjectAtIndex:indexPath.row withObject:photo];
    [self.collectionView performSelectorOnMainThread:@selector(reloadItemsAtIndexPaths:) withObject:[NSArray arrayWithObject:indexPath] waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [flickrPhotos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    FlickrPhoto *photo = [flickrPhotos objectAtIndex:indexPath.row];
    
    if (photo.image) {
        cell.cellImageView.image = photo.image;
    }
    cell.imageTitleLabel.text = photo.photoTitle;
    
    if ([selectedCells indexOfObject:indexPath] == NSNotFound) {
        cell.cellImageView.hidden = NO;
        cell.imageDetailsView.hidden = YES;
    } else {
        cell.cellImageView.hidden = YES;
        cell.imageDetailsView.hidden = NO;
    }
    
    switch (photo.state) {
        case FAILED:
        case DOWNLOADED:
            [cell.activityIndicator stopAnimating];
            break;
            
        case FRESH:
            [cell.activityIndicator startAnimating];
            [imageStreamController startDownloadingPhoto:photo forIndexPath:indexPath];
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    FlickrCollectionViewCell *cell = (FlickrCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([selectedCells indexOfObject:indexPath] == NSNotFound) {
        [selectedCells addObject:indexPath];
        [UIView transitionWithView:cell.cellContentView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^() {
            cell.cellImageView.hidden = YES;
            cell.imageDetailsView.hidden = NO;
        } completion:nil];
    } else {
        [selectedCells removeObject:indexPath];
        [UIView transitionWithView:cell.cellContentView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^() {
            cell.cellImageView.hidden = NO;
            cell.imageDetailsView.hidden = YES;
        } completion:nil];
    }
}

#pragma mark - UICollectionViewDataDelegateFlowLayout methods

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat side = self.view.frame.size.width / 2 - 6;
    return CGSizeMake(side, side);
}

@end
