//
//  WeatherViewController.h
//  iWeather
//
//  Created by 傅洋 on 14-9-12.
//  Copyright (c) 2014年 4ier.in. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>

@interface WeatherViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locManager;
    AFHTTPRequestOperationManager *httpManager;
}
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void)updateWeatherInfo:(CLLocationCoordinate2D)location2D;

- (void)updateInfoInUI:(id)responseObject;

@end
