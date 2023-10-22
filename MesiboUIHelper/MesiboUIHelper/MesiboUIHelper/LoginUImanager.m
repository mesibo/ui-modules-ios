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

#import "LoginUImanager.h"
#import "verifyMobileViewController.h"
#import "registerMobileViewController.h"

@implementation LoginUImanager

+ (void) launchVerificationViewController:(id)parent withPhoneNumber:(NSString *) phoneNumber handler:(PhoneVerificationBlock)handler {
    
    verifyMobileViewController *lvc = (verifyMobileViewController *)[((UIViewController *)parent).storyboard instantiateViewControllerWithIdentifier:@"verifyMobileViewController"];
    
    if([lvc isKindOfClass:[verifyMobileViewController class]]) {
        if(nil != phoneNumber)
            lvc.mVerifiyPhoneNumber = [NSString stringWithFormat:@"%@", phoneNumber];
        lvc.mLoginBlock = handler;
        //lvc.mVerifyHandler = _mRegisterHandler;
        [parent presentViewController:lvc animated:YES completion:nil];
    }

    
}


+ (void) launchRegisterViewController:(id)parent handler:(PhoneVerificationBlock)handler {
    
    registerMobileViewController *lvc = (registerMobileViewController *)[LoginUImanager findViewController:LOGIN_PROCESS_STORY_BOARD withBundleName:LOGIN_PROCESS_BUNDLE withIendifier:@"registerMobileViewController"];
    
    if([lvc isKindOfClass:[registerMobileViewController class]]) {
        lvc.mLoginBlock = handler;
        [parent  presentViewController:lvc animated:YES completion:nil];
    }
    
    
}

+ (UIViewController *) findViewController : (NSString *) storyboard withBundleName : (NSString *)  bundlename withIendifier: (NSString *) identifier {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:bundlename withExtension:@"bundle"];
    
    if(nil == bundleURL) {
        
        return nil;
        
    }
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
    UIStoryboard *realStoryboard = [UIStoryboard storyboardWithName:storyboard bundle:bundle];
    UIViewController *lvc = (UIViewController *)[realStoryboard instantiateViewControllerWithIdentifier:identifier];
    
    
    return lvc;
}



@end
