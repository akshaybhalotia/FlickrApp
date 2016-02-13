//
//  ImageStreamController.h
//  FlickrApp
//
//  Created by Akshay Bhalotia on 14/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageStreamProtocol;

@interface ImageStreamController : NSOperation

@property (weak) id<ImageStreamProtocol> streamDelegate;

-(void)fetchPhotoList;
-(void)startDownloadingPhoto:(FlickrPhoto *)photo forIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ImageStreamProtocol <NSObject>

-(void)doneFetchingList:(NSArray *)list withSuccess:(BOOL)success;
-(void)doneDownloadingPhoto:(FlickrPhoto *)photo forIndexPath:(NSIndexPath *)indexPath;

@end