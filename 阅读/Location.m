//
//  Location.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-11.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize locationManager=_locationManager;
@synthesize delegate = _delegate;




-(id)init{
    
    self = [super init];
    if (self) {
        _locationManager =[[CLLocationManager alloc] init];
        self.locationManager =  _locationManager;
        if ([CLLocationManager locationServicesEnabled] ) {
            _locationManager.delegate        = self;
            _locationManager.distanceFilter  = 100;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//            if (IS_iOS8) {
//                [_locationManager requestWhenInUseAuthorization];
//            }
            [_locationManager startUpdatingLocation];
            self.myLatitude                  = _locationManager.location.coordinate.latitude;
            self.myLongitude                 = _locationManager.location.coordinate.longitude;
        } else{
            self.myLatitude                  = 0.0f;
            self.myLongitude                 = 0.0f;
        }
    }
    return self;
}



+(instancetype)shareInstance{
    static  Location   *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(CLLocationCoordinate2D)currentLocation{
    CLLocationCoordinate2D cllocation = CLLocationCoordinate2DMake(self.myLatitude, self.myLongitude);
    return cllocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.myLatitude  = newLocation.coordinate.latitude;
    self.myLongitude = newLocation.coordinate.longitude;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateLocation:)]) {
        [self.delegate didUpdateLocation:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [_locationManager stopUpdatingLocation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailWithError:location:)]) {
        [self.delegate didFailWithError:error location:self];
    }
}

-(void)startUpdateLocation{
    [self.locationManager startUpdatingLocation];
}

-(void)stopUpateLoaction{
    [self.locationManager stopUpdatingLocation];
}

-(void)dealloc{
    self.locationManager = nil;
}

@end
