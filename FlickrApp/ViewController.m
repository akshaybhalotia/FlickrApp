//
//  ViewController.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright (c) 2016 Akshay Bhalotia. All rights reserved.
//

#import "ViewController.h"
#import "FlickrCollectionViewCell.h"

static NSString *const CELL_IDENTIFIER = @"flickrCell";

@interface ViewController () <UICollectionViewDelegateFlowLayout> {
    NSMutableArray *selectedCells;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    selectedCells = [NSMutableArray array];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    if ([selectedCells indexOfObject:indexPath] == NSNotFound) {
        cell.cellImageView.hidden = NO;
        cell.imageDetailsView.hidden = YES;
    } else {
        cell.cellImageView.hidden = YES;
        cell.imageDetailsView.hidden = NO;
    }
    return cell;
}

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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat side = self.view.frame.size.width / 2 - 6;
    return CGSizeMake(side, side);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
