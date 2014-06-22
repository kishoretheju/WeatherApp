//
//  KTMWeatherTableCell.m
//  WeatherApp
//
//  Created by Kishore Thejasvi on 22/06/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#import "KTMWeatherTableCell.h"

@interface KTMWeatherTableCell ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dateLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *weatherSummaryLabel;

@end

@implementation KTMWeatherTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTableCellData: (NSDictionary *)data atIndex: (NSInteger)index {
    UILabel *dateLabelRef = [self.dateLabel objectAtIndex:0];
    UILabel *weatherSummaryLabelRef = [self.weatherSummaryLabel objectAtIndex:0];
    
    if (index == 0) {
        dateLabelRef.text = @"Today";
    } else if (index == 1) {
        dateLabelRef.text = @"Tomorrow";
    } else if (index == 2) {
        dateLabelRef.text = @"Day After Tomorrow";
    } else {
        dateLabelRef.text = [self convertUnixTimeToNormalTime:(NSNumber *)[data objectForKey:@"time"]];
    }
    
    weatherSummaryLabelRef.text = [data objectForKey:@"summary"];
}

- (NSString *) convertUnixTimeToNormalTime: (NSNumber *) unixTime {
    NSDate *normalDate = [NSDate dateWithTimeIntervalSince1970:[unixTime integerValue]];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:normalDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    return dateString;
}

- (NSInteger) findDifferenceInTime: (NSNumber *) unixTime {
    NSDate *normalDate = [NSDate dateWithTimeIntervalSince1970:[unixTime integerValue]];
    NSInteger difference = (NSInteger)[normalDate timeIntervalSinceNow];
    return difference;
}

@end
