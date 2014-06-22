//
//  KTMDetailWeatherViewController.m
//  WeatherApp
//
//  Created by Kishore Thejasvi on 22/06/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#import "KTMDetailWeatherViewController.h"
#import "KTMAppDelegate.h"

@interface KTMDetailWeatherViewController ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *summaryLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *humidityLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *windSpeedLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *cloudCoverLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *presurreLabel;

// Weather data
@property (strong, nonatomic) NSDictionary *weatherData;

@end

@implementation KTMDetailWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadDetailedWeatherInfo];
}

- (void) loadDetailedWeatherInfo {
    UILabel *summaryLabelRef = [self.summaryLabel objectAtIndex:0];
    UILabel *humidityLabelRef = [self.humidityLabel objectAtIndex:0];
    UILabel *windSpeedLabelRef = [self.windSpeedLabel objectAtIndex:0];
    UILabel *cloudCoverLabelRef = [self.cloudCoverLabel objectAtIndex:0];
    UILabel *presurreLabelRef = [self.presurreLabel objectAtIndex:0];
    
    summaryLabelRef.text = [self.weatherData objectForKey:@"summary"];
    summaryLabelRef.numberOfLines = 0;
    humidityLabelRef.text = [NSString stringWithFormat:@"Humidity: %@", [self.weatherData objectForKey:@"humidity"]];
    windSpeedLabelRef.text = [NSString stringWithFormat:@"Wind Speed: %@", [self.weatherData objectForKey:@"windSpeed"]];
    cloudCoverLabelRef.text = [NSString stringWithFormat:@"Cloud Cover: %@", [self.weatherData objectForKey:@"cloudCover"]];
    presurreLabelRef.text = [NSString stringWithFormat:@"Pressure: %@", [self.weatherData objectForKey:@"pressure"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setData: (NSDictionary *)data {
    self.weatherData = data;
}

@end
