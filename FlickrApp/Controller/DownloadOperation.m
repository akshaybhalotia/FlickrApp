//
//  DownloadOperation.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import "DownloadOperation.h"

@implementation DownloadOperation

-(void)main {
    NSData *imageData;
    if (!self.cancelled) {
        imageData = [NSData dataWithContentsOfURL:self.flickrPhoto.photoUrl];
    }
    if (!self.cancelled) {
        if (imageData.length > 0) {
            self.flickrPhoto.state = DOWNLOADED;
            self.flickrPhoto.image = [UIImage imageWithData:imageData];
        } else {
            self.flickrPhoto.state = FAILED;
        }
    }
}

@end
