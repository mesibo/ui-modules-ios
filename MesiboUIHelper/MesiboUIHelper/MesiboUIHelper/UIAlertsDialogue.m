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

#import "UIAlertsDialogue.h"

@implementation UIAlertsDialogue


+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

+ (void)showDialogue:(NSString*)message withTitle :(NSString *) title {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [alert removeFromParentViewController];
                                        
                                    }];
    
    [alert addAction:defaultAction];
    [[UIAlertsDialogue topMostController]presentViewController:alert animated:YES completion:nil];
}

+(void)alert:(id)parent message:(NSString*)message title:(NSString *)title handler:(AlertResultBlock)handler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
            [alert removeFromParentViewController];
            if(handler)
                handler(YES);
        }
    ];
    
    
    UIAlertAction* NoAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault   handler:^(UIAlertAction * action) {
        
            [alert removeFromParentViewController];
            if(handler)
                handler(NO);
        }
    ];
    
    // if handler is nil, no point giving both the options, we just give OK option in that case
    if(handler)
        [alert addAction:NoAction]; //left
    
    [alert addAction:defaultAction]; //right
    
    [parent presentViewController:alert animated:YES completion:nil];
}


@end
