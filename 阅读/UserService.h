//
//  UserService.h
//  BmobIMDemo
//
//  Created by Bmob on 14-7-11.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface UserService : NSObject

/**
 *  登陆
 *
 *  @param username 用户名
 *  @param password 密码
 *  @param block    登陆结果
 */
+(void)logInWithUsernameInBackground:(NSString *)username
                            password:(NSString *)password
                               block:(BmobUserResultBlock)block;



/**
 *  注册
 *
 *  @param username  用户名
 *  @param password  密码
 *  @param sucessful 定位是否成功
 *  @param block     注册结果
 */
+(void)registerWithUsernameInBackground:(NSString *)username
                               password:(NSString *)password
                        locateSucessful:(BOOL)sucessful
                                  block:(BmobBooleanResultBlock)block;


+(void)saveFriendsList;

@end
