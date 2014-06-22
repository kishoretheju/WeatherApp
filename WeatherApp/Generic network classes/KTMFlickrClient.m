//
//  KTMFlickrClient.m
//  WeatherApp
//
//  Created by Kishore Thejasvi on 22/06/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#import "KTMFlickrClient.h"

@implementation KTMFlickrClient

+ (instancetype) sharedClient {
    static KTMFlickrClient *flickrClient = nil;
    
    static dispatch_once_t onceTokenForFlickr;
    dispatch_once(&onceTokenForFlickr, ^{
        flickrClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kFlickrBaseURLString]];
    });
    
    return flickrClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}


@end
