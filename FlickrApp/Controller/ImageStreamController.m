//
//  ImageStreamController.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 14/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import "DownloadOperation.h"
#import "DownloadQueue.h"
#import "ImageStreamController.h"

static NSString *const LIST_URL = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=ad766d15f6bb142ca9ed2a4722d083c7&tags=superman&per_page=36&format=json&nojsoncallback=1";

static NSString *const kPhotos = @"photos";
static NSString *const kPhoto = @"photo";
static NSString *const kFarm = @"farm";
static NSString *const kId = @"id";
static NSString *const kSecret = @"secret";
static NSString *const kServer = @"server";
static NSString *const kTitle = @"title";

@interface ImageStreamController () {
    DownloadQueue *downloadQueue;
    NSMutableArray *flickrPhotos;
    NSMutableDictionary *downloadsInProgress;
}

@end

@implementation ImageStreamController

-(instancetype)init {
    if (self = [super init]) {
        downloadQueue = [DownloadQueue new];
        downloadsInProgress = [NSMutableDictionary dictionary];
        flickrPhotos = [NSMutableArray array];
    }
    return self;
}

-(void)fetchPhotoList {
    NSURL *listURL = [NSURL URLWithString:LIST_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:listURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data) {
            NSError *jsonError;
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (!jsonError) {
                NSDictionary *photos = [dataDictionary objectForKey:kPhotos];
                NSArray *photo = [photos objectForKey:kPhoto];
                for (NSDictionary *flickrPhoto in photo) {
                    FlickrPhoto *newPhoto = [FlickrPhoto new];
                    newPhoto.farmId = [flickrPhoto valueForKey:kFarm];
                    newPhoto.photoId = [flickrPhoto valueForKey:kId];
                    newPhoto.photoSecret = [flickrPhoto valueForKey:kSecret];
                    newPhoto.serverId = [flickrPhoto valueForKey:kServer];
                    newPhoto.photoTitle = [flickrPhoto valueForKey:kTitle];
                    [flickrPhotos addObject:newPhoto];
                }
                [self.streamDelegate doneFetchingList:flickrPhotos withSuccess:YES];
            } else {
                [self.streamDelegate doneFetchingList:flickrPhotos withSuccess:NO];
            }
        }
        if (connectionError) {
            [self.streamDelegate doneFetchingList:flickrPhotos withSuccess:NO];
        }
    }];
}

-(void)startDownloadingPhoto:(FlickrPhoto *)photo forIndexPath:(NSIndexPath *)indexPath {
    DownloadOperation *downloadOperation = [downloadsInProgress objectForKey:indexPath];
    if (!downloadOperation) {
        downloadOperation = [DownloadOperation new];
        downloadOperation.flickrPhoto = photo;
        downloadOperation.completionBlock = ^() {
            [downloadsInProgress removeObjectForKey:indexPath];
            [self.streamDelegate doneDownloadingPhoto:photo forIndexPath:indexPath];
        };
        [downloadsInProgress setObject:downloadOperation forKey:indexPath];
        [downloadQueue addOperation:downloadOperation];
    }
}

@end
