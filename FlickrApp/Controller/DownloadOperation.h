//
//  DownloadOperation.h
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import "FlickrPhoto.h"
#import <Foundation/Foundation.h>

@interface DownloadOperation : NSOperation

@property FlickrPhoto *flickrPhoto;

@end
