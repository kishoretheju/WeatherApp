//
//  KTMAppDelegate.h
//  WeatherApp
//
//  Created by Kishore Thejasvi on 22/06/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSString *) findDeviceLocation;
@end
