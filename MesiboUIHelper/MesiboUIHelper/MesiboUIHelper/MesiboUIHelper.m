/** Copyright (c) 2019 Mesibo
 * https://mesibo.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the terms and condition mentioned
 * on https://mesibo.com as well as following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions, the following disclaimer and links to documentation and
 * source code repository.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of Mesibo nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific prior
 * written permission.
 *
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Documentation
 * https://mesibo.com/documentation/
 *
 * Source Code Repository
 * https://github.com/mesibo/ui-modules-ios
 *
 */

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
