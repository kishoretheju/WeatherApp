//
//  KTMHttpClient.h
//  WeatherApp
//
//  Created by Kishore Thejasvi on 22/06/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface KTMHttpClient : AFHTTPSessionManager

+ (instancetype) sharedClient;

@end
