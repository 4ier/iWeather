//
//  WeatherViewController.m
//  iWeather/Users/fuyang/Documents/iWeather/iWeather/WeatherAppDelegate.h
//
//  Created by 傅洋 on 14-9-12.
//  Copyright (c) 2014年 4ier.in. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // New a indicator
    [[self loadingIndicator] startAnimating];
    
    // init locManager
    locManager = [[CLLocationManager alloc]init];
    httpManager = [[AFHTTPRequestOperationManager alloc]init];
    
    // set delegate
    locManager.delegate = self;
    
    // set accuracy
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // set update rate
    locManager.distanceFilter = 100;
    
    // start service
    [locManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    [self updateWeatherInfo:[location coordinate]];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error occur: %@" , error);
}

- (void)updateWeatherInfo:(CLLocationCoordinate2D)location2D
{
    NSArray *keys = [NSArray arrayWithObjects:@"lat", @"lon", @"cnt", nil];
    NSArray *values = [NSArray arrayWithObjects:[NSNumber numberWithDouble:(double)location2D.latitude], [NSNumber numberWithDouble:(double)location2D.longitude], [NSNumber numberWithInt:0], nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    [httpManager GET:@"http://api.openweathermap.org/data/2.5/weather" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updateInfoInUI:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get weather information failed!");
    }];
}

- (void)updateInfoInUI:(id)responseObject
{
    NSDictionary *weatherInfo;
    weatherInfo = (NSDictionary *)responseObject;
    
    double temp;
    temp = [[[weatherInfo objectForKey:@"main"] objectForKey:@"temp"] doubleValue];
    
    NSString *iconID;
    iconID = (NSString *)[[(NSArray *)[weatherInfo objectForKey:@"weather"] firstObject] objectForKey:@"icon"];
    
    NSString *location;
    location = (NSString *)[weatherInfo objectForKey:@"name"];
    
    if ( temp == 0 || location == nil || iconID == nil )
    {
        return;
    }
    
    [_weatherLabel setText:[NSString stringWithFormat:@"%.1f°C", round(temp - 273.15)]];
    [_locationLabel setText:location];
    [_weatherImg setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:iconID ofType:@"png"]]];
    
    [[self loadingIndicator] stopAnimating];
    [[self loadingIndicator] setHidden:true];
    
}

@end
