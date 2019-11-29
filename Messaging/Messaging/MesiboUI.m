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
#import "MesiboUI.h"
#import "UserListViewController.h"
#import "MesiboUIManager.h"
#import "MesiboImage.h"

@implementation MesiboUI

+ (UIViewController *) getMesiboUIViewController:(id)uidelegate {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *bundleURL = [mainBundle URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mesibo" bundle:bundle];
    UserListViewController *vc = (UserListViewController *)[sb instantiateViewControllerWithIdentifier:@"UserListViewController"];
    
    vc.mUiDelegate = uidelegate;
    
    if([vc isKindOfClass:[UserListViewController class]]) {
        vc.mNewContactChooser = USERLIST_MESSAGE_MODE;
        return vc;
    }
        return nil;

}

+ (UIViewController *) getMesiboUIViewController {
    return [MesiboUI getMesiboUIViewController:nil];
}

+(void) launchEditGroupDetails:(id) parent groupid:(uint32_t) groupid  {

    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mesibo" bundle:bundle];
    UserListViewController *vc = (UserListViewController *)[sb instantiateViewControllerWithIdentifier:@"UserListViewController"];
    if([vc isKindOfClass:[UserListViewController class]]) {

    [MesiboUIManager launchUserListViewcontroller:parent withChildViewController:vc  withContactChooser:USERLIST_EDIT_GROUP_MODE withForwardMessageData:nil withMembersList:nil withForwardGroupName:nil withForwardGroupid:groupid];
    }
    
}


+(void) launchMessageViewController:(UIViewController *)parent profile:(id)profile uidelegate:(id)uidelegate {
    [MesiboUIManager launchMessageViewController:parent withUserData:profile uidelegate:uidelegate];
}

+(void) launchMessageViewController:(UIViewController *)parent profile:(id)profile {
    [MesiboUIManager launchMessageViewController:parent withUserData:profile uidelegate:nil];
}


+(UIImage *) getDefaultImage:(BOOL)group {
    if(group)
        return [MesiboImage getDefaultGroupImage];
    
    return [MesiboImage getDefaultProfileImage];
}

//This is a dummy function for Single object module
+(BOOL) getUITableViewInstance:(UITableViewWithReloadCallback *) table {
    return [table isPagingEnabled];
}


+(BOOL) launchViewController:(UIViewController *)parent vc:(UIViewController *)vc root:(BOOL)root {
    return YES;
}

+(BOOL) launchViewController:(UIViewController *)parent storyboard:(NSString *)storyboard identifier:(NSString *)identifier root:(BOOL)root {
    return YES;
}

@end
