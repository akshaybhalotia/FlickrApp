//
//  FlickrPhoto.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import "FlickrPhoto.h"

static NSString *const URL_FORMAT = @"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg";

@implementation FlickrPhoto

-(instancetype)init {
    if (self = [super init]) {
        self.state = FRESH;
    }
    return self;
}

-(NSURL *)photoUrl {
    NSString *url = [NSString stringWithFormat:URL_FORMAT, self.farmId, self.serverId, self.photoId, self.photoSecret];
    return [NSURL URLWithString:url];
}

@end
