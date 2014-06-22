//
//  KTMWeatherViewController.m
//  WeatherApp
//
//  Created by Kishore Thejasvi on 22/06/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#define BACKGROUNDIMAGEVIEW [self.backgroundImageView objectAtIndex:0]
#define ACTIVITYINDICATOR [self.activityIndicator objectAtIndex:0]
#define TABLEVIEW [self.tableView objectAtIndex:0]

#import "KTMWeatherViewController.h"
#import "KTMWeatherTableCell.h"
#import "KTMAppDelegate.h"
#import "KTMDetailWeatherViewController.h"
#import "KTMFlickrClient.h"

@interface KTMWeatherViewController ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *backgroundImageView;
@property (strong, nonatomic) IBOutletCollection(UITableView) NSArray *tableView;
@property (strong, nonatomic) IBOutletCollection(UIActivityIndicatorView) NSArray *activityIndicator;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSDictionary *currentWeatherDetails;
@property (strong, nonatomic) NSDictionary *hourlyWeatherDetails;
@property (strong, nonatomic) NSDictionary *dailyWeatherDetails;

// Table header view subviews
@property (strong, nonatomic) UILabel *summaryLabel;
@property (strong, nonatomic) UILabel *subDescriptionLabel;

@property (assign) NSInteger selectedRow;
@property (strong, nonatomic) UIRefreshControl *pullToRefresh;

@end

@implementation KTMWeatherViewController

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
    self.selectedRow = 0;
    
    self.data = [[NSMutableDictionary alloc] init];
    
    self.pullToRefresh = [[UIRefreshControl alloc] init];
    [TABLEVIEW addSubview:self.pullToRefresh];
    [self.pullToRefresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    [ACTIVITYINDICATOR startAnimating];
    [self loadWeatherInfo];
}

- (void) refreshTableView: (id)sender {
    [self loadWeatherInfo];
}

- (void) loadWeatherInfo {
    __block __typeof__(self) _self = self;
    
    KTMAppDelegate *appDelegate = (KTMAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *deviceLocation = [appDelegate findDeviceLocation];
    
    KTMHttpClient *httpClient = [KTMHttpClient sharedClient];
    [httpClient GET:deviceLocation
         parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                [_self extractWeatherInfo:(NSDictionary *)responseObject];
                UITableView *tableViewRef = [_self.tableView objectAtIndex:0];
                [tableViewRef reloadData];
                [ACTIVITYINDICATOR stopAnimating];
                [_self.pullToRefresh endRefreshing];
            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                [ACTIVITYINDICATOR stopAnimating];
                [_self.pullToRefresh endRefreshing];
            }];
}

- (void) extractWeatherInfo: (NSDictionary *)weatherInfo {
    self.data = [weatherInfo mutableCopy];
    self.currentWeatherDetails = [self.data objectForKey:@"currently"];
    self.hourlyWeatherDetails = [self.data objectForKey:@"hourly"];
    self.dailyWeatherDetails = [self.data objectForKey:@"daily"];
}

#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dailyWeatherDetails objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTMWeatherTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeatherCellIdentifier];
    
    if (!cell) {
        cell = [[KTMWeatherTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWeatherCellIdentifier];
    }
    
    [cell setTableCellData:[[self.dailyWeatherDetails objectForKey:@"data"] objectAtIndex:indexPath.row] atIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    
    self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    self.summaryLabel.font = [UIFont boldSystemFontOfSize:20];
    self.summaryLabel.textAlignment = NSTextAlignmentCenter;
    self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerView addSubview:self.summaryLabel];
    
    self.subDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 30)];
    self.subDescriptionLabel.font = [UIFont systemFontOfSize:17];
    self.subDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.subDescriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerView addSubview:self.subDescriptionLabel];
    
    if (self.currentWeatherDetails) {
        [self loadHeaderViewDataAndAnimate];
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    [TABLEVIEW deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSString *) convertUnixTimeToNormalTime: (NSNumber *) unixTime {
    NSDate *normalDate = [NSDate dateWithTimeIntervalSince1970:[unixTime integerValue]];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:normalDate
                                                          dateStyle:NSDateFormatterNoStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    return dateString;
}

- (void) loadHeaderViewDataAndAnimate {
    self.summaryLabel.text = [self.currentWeatherDetails objectForKey:@"summary"];
    
    NSString *tempString = [NSString stringWithFormat:@"%@", [self.currentWeatherDetails objectForKey:@"temperature"]];
    if ([tempString length]>4) {
        tempString = [tempString substringToIndex:4];
    }
    tempString = [tempString stringByAppendingString:@"o"];
    NSString *dateString = [self convertUnixTimeToNormalTime:(NSNumber *)[self.currentWeatherDetails objectForKey:@"time"]];
    NSString *string = [NSString stringWithFormat:@"%@ ,%@", tempString, dateString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    [attributedString setAttributes:@{NSBaselineOffsetAttributeName: @10, NSFontAttributeName: [UIFont systemFontOfSize:10]} range:NSMakeRange([tempString length] - 1, 1)];
    self.subDescriptionLabel.attributedText = attributedString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KTMDetailWeatherViewController *weatherDetailedVC = (KTMDetailWeatherViewController *)segue.destinationViewController;
    
    if ([weatherDetailedVC respondsToSelector:@selector(setData:)]) {
        NSDictionary *data = [[self.dailyWeatherDetails objectForKey:@"data"] objectAtIndex:self.selectedRow];
        [weatherDetailedVC setData:data];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
