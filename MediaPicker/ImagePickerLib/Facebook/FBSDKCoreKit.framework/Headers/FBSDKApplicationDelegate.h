/******************************************************************************
* By accessing or copying this work, you agree to comply with the following   *
* terms:                                                                      *
*                                                                             *
* Copyright (c) 2019-2023 mesibo                                              *
* https://mesibo.com                                                          *
* All rights reserved.                                                        *
*                                                                             *
* Redistribution is not permitted. Use of this software is subject to the     *
* conditions specified at https://mesibo.com . When using the source code,    *
* maintain the copyright notice, conditions, disclaimer, and  links to mesibo * 
* website, documentation and the source code repository.                      *
*                                                                             *
* Do not use the name of mesibo or its contributors to endorse products from  *
* this software without prior written permission.                             *
*                                                                             *
* This software is provided "as is" without warranties. mesibo and its        *
* contributors are not liable for any damages arising from its use.           *
*                                                                             *
* Documentation: https://mesibo.com/documentation/                            *
*                                                                             *
* Source Code Repository: https://github.com/mesibo/                          *
*******************************************************************************/

// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/*!
 @class FBSDKApplicationDelegate

 @abstract
 The FBSDKApplicationDelegate is designed to post process the results from Facebook Login
 or Facebook Dialogs (or any action that requires switching over to the native Facebook
 app or Safari).

 @discussion
 The methods in this class are designed to mirror those in UIApplicationDelegate, and you
 should call them in the respective methods in your AppDelegate implementation.
 */
@interface FBSDKApplicationDelegate : NSObject

/*!
 @abstract Gets the singleton instance.
 */
+ (instancetype)sharedInstance;

/*!
 @abstract
 Call this method from the [UIApplicationDelegate application:openURL:sourceApplication:annotation:] method
 of the AppDelegate for your app. It should be invoked for the proper processing of responses during interaction
 with the native Facebook app or Safari as part of SSO authorization flow or Facebook dialogs.

 @param application The application as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].

 @param url The URL as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].

 @param sourceApplication The sourceApplication as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].

 @param annotation The annotation as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].

 @return YES if the url was intended for the Facebook SDK, NO if not.
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/*!
 @abstract
 Call this method from the [UIApplicationDelegate application:didFinishLaunchingWithOptions:] method
 of the AppDelegate for your app. It should be invoked for the proper use of the Facebook SDK.

 @param application The application as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].

 @param launchOptions The launchOptions as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].

 @return YES if the url was intended for the Facebook SDK, NO if not.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
