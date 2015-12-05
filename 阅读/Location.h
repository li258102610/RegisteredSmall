//
//  Location.h
//  BmobIMDemo
//
//  Created by Bmob on 14-7-11.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationDelegate ;

@interface Location : NSObject<CLLocationManagerDelegate>



@property(nonatomic,assign)double myLatitude;
@property(nonatomic,assign)double myLongitude;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(weak)id <LocationDelegate> delegate;

-(CLLocationCoordinate2D)currentLocation;

+(instancetype)shareInstance;

-(void)startUpdateLocation;

-(void)stopUpateLoaction;

@end


@protocol LocationDelegate <NSObject>
@optional
-(void)didUpdateLocation:(Location *)loc;
@optional
-(void)didFailWithError:(NSError *)error location:(Location *)loc;
@end
