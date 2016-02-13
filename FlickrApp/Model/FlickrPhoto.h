//
//  FlickrPhoto.h
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoState) {
    FRESH,
    DOWNLOADED,
    FAILED
};

@interface FlickrPhoto : NSObject

@property NSString *photoTitle, *photoId, *photoSecret, *farmId, *serverId;
@property (readonly) NSURL *photoUrl;
@property PhotoState state;
@property UIImage *image;

@end
