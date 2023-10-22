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

#import "MesiboUIHelper.h"
//#import "LoginViewController.h"
#import "registerMobileViewController.h"
#import "verifyMobileViewController.h"
#import "WelcomeController.h"
#import "LoginUImanager.h"


//Needed .. .
@implementation MesiboUiHelperConfig
@end

@implementation WelcomeBanner
@end


static MesiboUiHelperConfig *mUiConfig = nil;

@implementation MesiboUIHelper


- (void) startWelcomViewController: (UIViewController *) mParent WithAppdata:(MesiboUiHelperConfig *) appData  withBlock: (WelcomeBlock) handler; {
    
    WelcomeController *wc = (WelcomeController *)[LoginUImanager findViewController:WELCOME_STORY_BOARD withBundleName:WELCOME_BUNDLE withIendifier:@"WelcomeController"];
    _mParentViewController = mParent;
    if([wc isKindOfClass:[WelcomeController class]]) {
        wc.mWelcomeHandler = [handler copy];
        wc.mWelcomeParent = mParent;
        [mParent presentViewController:wc animated:YES completion:nil];
    }
}

+ (UIViewController *) getWelcomeViewController:(WelcomeBlock )handler{
    WelcomeController *wc = (WelcomeController *)[LoginUImanager findViewController:WELCOME_STORY_BOARD withBundleName:WELCOME_BUNDLE withIendifier:@"WelcomeController"];
    
    wc.mWelcomeHandler = handler;
    return wc;
}

+(UIViewController *) startMobileVerification:(PhoneVerificationBlock)handler {
    registerMobileViewController *rmvc = (registerMobileViewController *)[LoginUImanager findViewController:LOGIN_PROCESS_STORY_BOARD withBundleName:LOGIN_PROCESS_BUNDLE withIendifier:@"registerMobileViewController"];
    rmvc.mLoginBlock = handler ;
    return rmvc;
}

+(void) setUiConfig:(MesiboUiHelperConfig *)config {
    mUiConfig = config;
}

+(MesiboUiHelperConfig *) getUiConfig {
    return mUiConfig;
}

@end
