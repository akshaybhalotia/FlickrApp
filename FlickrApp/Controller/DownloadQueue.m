//
//  DownloadQueue.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import "DownloadQueue.h"

@implementation DownloadQueue

-(instancetype)init {
    if (self = [super init]) {
        self.name = @"Download Queue";
        self.maxConcurrentOperationCount = 4;
    }
    return self;
}

@end
