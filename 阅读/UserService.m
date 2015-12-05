//
//  UserService.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-11.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "UserService.h"
#import "Location.h"
#import <BmobIM/BmobUserManager.h>

@implementation UserService

+(void)saveFriendsList{
    BmobDB *db = [BmobDB currentDatabase];
    [db createDataBase];
    [[BmobUserManager currentUserManager] queryCurrentContactArray:^(NSArray *array, NSError *error) {
        NSMutableArray *chatUserArray = [NSMutableArray array];
        for (BmobUser * user in array) {
            BmobChatUser *chatUser = [[BmobChatUser alloc] init];
            chatUser.username      = [user objectForKey:@"username"];
            chatUser.avatar        = [user objectForKey:@"avatar"];
            chatUser.nick          = [user objectForKey:@"nick"];
            chatUser.objectId      = user.objectId;
            [chatUserArray addObject:chatUser];
        }
        [db saveOrCheckContactList:chatUserArray];
    }];
}

+(void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(BmobUserResultBlock)block{
    [BmobUser loginWithUsernameInBackground:username password:password block:^(BmobUser *user, NSError *error) {
        if (error) {
        }else{
            //启动定位
//            [[Location shareInstance] startUpdateLocation];
//            CLLocationDegrees longitude = [[Location shareInstance] currentLocation].longitude;
//            CLLocationDegrees latitude  = [[Location shareInstance] currentLocation].latitude;
//            BmobGeoPoint *location      = [[BmobGeoPoint alloc] initWithLongitude:longitude WithLatitude:latitude];
            
            CLLocationDegrees longitude     = [[Location shareInstance] currentLocation].longitude;
            CLLocationDegrees latitude      = [[Location shareInstance] currentLocation].latitude;
            CLLocationCoordinate2D gpsCoor  = CLLocationCoordinate2DMake(latitude, longitude);
            //百度坐标
//            CLLocationCoordinate2D bmapCoor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(gpsCoor,BMK_COORDTYPE_GPS));
//            BmobGeoPoint *location          = [[BmobGeoPoint alloc] initWithLongitude:bmapCoor.longitude WithLatitude:bmapCoor.latitude];
//            [user setObject:location forKey:@"location"];
//            
//            [user setObject:location forKey:@"location"];
            //结束定位
            [[Location shareInstance] stopUpateLoaction];
            //更新定位
            [user updateInBackground];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"]) {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"];
                [[BmobUserManager currentUserManager] checkAndBindDeviceToken:data];
            }
        }
        if (block) {
            block(user,error);
        }
    }];
}

+(void)registerWithUsernameInBackground:(NSString *)username
                               password:(NSString *)password
                        locateSucessful:(BOOL)successful
                                  block:(BmobBooleanResultBlock)block{
    
    BmobUser *user = [[BmobUser alloc] init];
    [user setUserName:username];
    [user setPassword:password];
    [user setObject:@"ios" forKey:@"deviceType"];
    if (successful) {
        
        CLLocationDegrees longitude = [[Location shareInstance] currentLocation].longitude;
        CLLocationDegrees latitude  = [[Location shareInstance] currentLocation].latitude;
        CLLocationCoordinate2D gpsCoor = CLLocationCoordinate2DMake(latitude, longitude);
//        CLLocationCoordinate2D bmapCoor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(gpsCoor,BMK_COORDTYPE_GPS));
//       BmobGeoPoint *location      = [[BmobGeoPoint alloc] initWithLongitude:bmapCoor.longitude WithLatitude:bmapCoor.latitude];
//        [user setObject:location forKey:@"location"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"]) {
        NSData *data         = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"];
        NSString *dataString = [NSString stringWithFormat:@"%@",data];
        dataString           = [dataString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        dataString           = [dataString stringByReplacingOccurrencesOfString:@">" withString:@""];
        dataString           = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [user setObject:dataString forKey:@"installId"];
        [[BmobUserManager currentUserManager] bindDeviceToken:data];
    }
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self logInWithUsernameInBackground:username password:password block:^(BmobUser *user, NSError *error) {
            }];
        }
        if (block) {
            block(isSuccessful,error);
        }
    }];
}

@end
