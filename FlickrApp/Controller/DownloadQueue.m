//
//  DownloadQueue.m
//  FlickrApp
//
//  Created by Akshay Bhalotia on 13/02/16.
//  Copyright © 2016 Akshay Bhalotia. All rights reserved.
//

#import "DownloadQueue.h"

static NSString *const QUEUE_NAME = @"Download Queue";

@implementation DownloadQueue

-(instancetype)init {
    if (self = [super init]) {
        self.name = QUEUE_NAME;
        self.maxConcurrentOperationCount = 4;
    }
    return self;
}

@end
