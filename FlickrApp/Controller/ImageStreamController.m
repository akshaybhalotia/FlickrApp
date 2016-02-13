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
                NSDictionary *photos = [dataDictionary objectForKey:@"photos"];
                NSArray *photo = [photos objectForKey:@"photo"];
                for (NSDictionary *flickrPhoto in photo) {
                    FlickrPhoto *newPhoto = [FlickrPhoto new];
                    newPhoto.farmId = [flickrPhoto valueForKey:@"farm"];
                    newPhoto.photoId = [flickrPhoto valueForKey:@"id"];
                    newPhoto.photoSecret = [flickrPhoto valueForKey:@"secret"];
                    newPhoto.serverId = [flickrPhoto valueForKey:@"server"];
                    newPhoto.photoTitle = [flickrPhoto valueForKey:@"title"];
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
