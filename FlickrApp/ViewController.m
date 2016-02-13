//
//  ViewController.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright (c) 2016 Akshay Bhalotia. All rights reserved.
//

#import "ViewController.h"

static NSString *const CELL_IDENTIFIER = @"flickrCell";

@interface FlickrCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cellContentView;

@end

@implementation FlickrCell

@end

@interface ViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    return cell;
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
