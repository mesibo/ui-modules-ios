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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#define LOGIN_PROCESS_BUNDLE        @"MesiboUIHelperResource"
#define LOGIN_PROCESS_STORY_BOARD   @"Main"
#define WELCOME_BUNDLE              @"MesiboUIHelperResource"
#define WELCOME_STORY_BOARD         @"WelcomeLaunch"



#define LOGIN_SIGNIN                0
#define LOGIN_FORGOT_PASSWORD       1


#define ACTION_REGISTER_NUMBER      5
#define ACTION_HAVE_OTP             6


#define ACTION_VERIFY_NUMBER        10
#define ACTION_START_AGAIN          11


@interface WelcomeBanner : NSObject
@property (strong, nonatomic) NSString *mTitle;
@property (strong, nonatomic) NSString *mDescription;
@property (strong, nonatomic) UIImage *mImage;
@property (nonatomic) uint32_t mColor;
@end

@interface MesiboUiHelperConfig : NSObject
@property (strong,nonatomic) NSString *mCountryCode;
@property (strong,nonatomic) NSString *mAppName;
@property (strong,nonatomic) NSString *mAppTag;
@property (strong,nonatomic) NSString *mAppUrl;
@property (strong,nonatomic) NSString *mAppWriteUp;
@property (strong,nonatomic) NSString *mLoginTitle;
@property (strong,nonatomic) NSString *mLoginDesc;
@property (strong,nonatomic) NSString *mLoginBottomDesc;
@property (strong,nonatomic) NSString *mOtpTitle;
@property (strong,nonatomic) NSString *mOtpDesc;
@property (strong,nonatomic) NSString *mOtpBottomDesc;

@property (nonatomic) uint32_t mBackgroundColor;
@property (nonatomic) uint32_t mButtonBackgroundColor;
@property (nonatomic) uint32_t mTextColor;
@property (nonatomic) uint32_t mSecondaryTextColor;
@property (nonatomic) uint32_t mButtonTextColor;
@property (nonatomic) uint32_t mBannerTitleColor;
@property (nonatomic) uint32_t mBannerDescColor;
@property (nonatomic) uint32_t mErrorTextColor;
@property (nonatomic) uint32_t mLoginTitleColor;
@property (nonatomic) uint32_t mLoginDescColor;
@property (nonatomic) uint32_t mLoginBottomDescColor;

@property (strong,nonatomic) NSArray *mBanners;
@end


typedef void (^WelcomeBlock)(UIViewController * viewController, BOOL result);
typedef void (^PhoneVerificationResultBlock)(BOOL result);
typedef void (^PhoneVerificationBlock)(id caller, NSString* phone, NSString* code, PhoneVerificationResultBlock resultBlock);


@interface MesiboUIHelper : NSObject
@property (strong,nonatomic) UIViewController* mParentViewController;
+ (UIViewController *) getWelcomeViewController:(WelcomeBlock)handler;
+ (UIViewController *) startMobileVerification:(PhoneVerificationBlock)handler;
+(MesiboUiHelperConfig *) getUiConfig;
+(void) setUiConfig:(MesiboUiHelperConfig *)config;
@end




