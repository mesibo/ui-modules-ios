/** Copyright (c) 2023 Mesibo, Inc
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

@implementation MesiboUI {
    
}

static id<MesiboUIListener> mListener = nil;
static NSBundle *mBundle = nil;
static UIStoryboard *mStoryboard = nil;

+(MesiboUiDefaults *) getUiDefaults {
    static MesiboUiDefaults *mUiOptions = nil;
    if(nil == mUiOptions) {
        @synchronized(self) {
            if (nil == mUiOptions) {
                mUiOptions = [[MesiboUiDefaults alloc] init];
            }
        }
    }
    
    return mUiOptions;
}

+(MesiboScreen *) getParentScreen:(id)view {
    return (MesiboScreen *) [MesiboCommonUtils getAssociatedObject:view];
}

+(BOOL) addTarget:(id _Nonnull)parent screen:(MesiboScreen * _Nonnull)screen view:(id _Nonnull)view action:(SEL _Nonnull)action {
    if(!screen || !view || !action) return NO;
    [MesiboCommonUtils cleanTargets:view];
    return [MesiboCommonUtils addTarget:parent view:view action:action screen:screen];
}

+(void) setListener:(id<MesiboUIListener>)delegate {
    mListener = delegate;
}

+(nullable id<MesiboUIListener>) getListener {
    return mListener;
}

+(NSBundle *) getMesiboUIBumble {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *bundleURL = [mainBundle URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    mBundle = [[NSBundle alloc] initWithURL:bundleURL];
    return mBundle;
}

+(UIImage *)imageNamed:(NSString *)imageName color:(uint32_t)color {
    return [MesiboImage imageNamed:imageName color:color];
}

+ (UIImage *)imageNamed:(NSString *)imageName {
    return [MesiboImage imageNamed:imageName];
}

+(UIViewController * _Nullable) getUserListViewController:(MesiboUserListScreenOptions *)opts {
    if(!opts) return nil;
    
    NSBundle *bundle = [MesiboUI getMesiboUIBumble];
    // NSBundle *bundle = [NSBundle bundleWithIdentifier: @"com.tringme.LiveChatResource"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mesibo" bundle:bundle];
    UserListViewController *vc = (UserListViewController *)[sb instantiateViewControllerWithIdentifier:@"UserListViewController"];
    
    vc.mUiDelegate = opts.listener;
    vc.mUiDelegateForMessageView = opts.mlistener;
    vc.mMode = opts.mode;
    vc.forwardIds = opts.forwardIds;
    vc.mForwardGroupid = opts.groupid;
    
    
    if(!vc.mUiDelegate) vc.mUiDelegate = [MesiboUI getListener];
    if(!vc.mUiDelegateForMessageView) vc.mUiDelegateForMessageView = vc.mUiDelegate;
    
    
    if([vc isKindOfClass:[UserListViewController class]]) {
        vc.mMode = USERLIST_MODE_MESSAGES;
        return vc;
    }
    
    return nil;
    
}

+(UIViewController * _Nullable) getMessageViewController:(MesiboMessageScreenOptions * _Nonnull)opts {
    if(!opts || !opts.profile || ![opts.profile isValidDestination]) {
        NSLog(@"getMessageViewController: Invalid opts or profile");
        return nil;
    }
    
    UIStoryboard *storyboard = [MesiboCommonUtils getMeMesiboStoryBoard];
    MessageViewController *cv = (MessageViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    
    if(![cv isKindOfClass:[MessageViewController class]]) {
        NSLog(@"getMessageViewController: Invalid controller");
        return nil;
    }
    
    cv.mOpts = opts;
    cv.mDismissOnBackPressed = NO;
    cv.mUser = opts.profile;
    [cv setTableViewDelegate:opts.listener?opts.listener:[MesiboUI getListener]];
    
    MesiboUiDefaults *options = [MesiboUI getUiDefaults];
    
    if(options.hidesBottomBarWhenPushed)
        cv.hidesBottomBarWhenPushed = YES;
    
    return cv;
}


+(void) launchUserList:(UIViewController *)parent opts:(MesiboUserListScreenOptions *) opts {
    
    UIViewController *mesiboController = [MesiboUI getUserListViewController:opts];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mesiboController];
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
   // MesiboUiOptions *opt = [MesiboUI getUiOptions];
  //  opt.enableBackButton = back;
    
    [parent presentViewController:navigationController animated:YES completion:nil];
}

+(void) launchMessaging:(UIViewController *) parent opts:(MesiboMessageScreenOptions *) opts {
    
    if(!parent) {
        NSLog(@"Missing Parent");
        return;
    }
    
    MessageViewController *vc = (MessageViewController *) [MesiboUI getMessageViewController:opts];
    
    if(!vc) {
        return;
    }
    
    UINavigationController *navigationController = nil;
    if(opts.navigation && !parent.navigationController) {
        navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.mDismissOnBackPressed = YES;
    }
    
    if(parent.navigationController)
        [parent.navigationController pushViewController:vc animated:YES];
    else {
        if(navigationController) {
            [parent presentViewController:navigationController animated:YES completion:nil];
        } else {
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [parent presentViewController:vc animated:YES completion:nil];
        }
    }
}

+(void) launchEditGroupDetails:(id) parent groupid:(uint32_t) groupid  {
    
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mesibo" bundle:bundle];
    UserListViewController *vc = (UserListViewController *)[sb instantiateViewControllerWithIdentifier:@"UserListViewController"];
    if([vc isKindOfClass:[UserListViewController class]]) {
        
        [MesiboUIManager launchUserListViewcontroller:parent withChildViewController:vc  withContactChooser:USERLIST_MODE_EDITGROUP withForwardMessageData:nil withMembersList:nil withForwardGroupName:nil withForwardGroupid:groupid];
    }
    
}

+(void) showEndToEncEncryptionInfo:(UIViewController *) parent profile:(MesiboProfile*)profile {
    [MesiboUIManager showE2EInfo:parent profile:profile];
}

+ (UIViewController *) getE2EViewController:(MesiboProfile *)profile {
    E2EViewController *vc =  [E2EViewController new];
    [vc setProfile:profile];
    return vc;
}


+(UIImage *) getDefaultImage:(BOOL)group {
    if(group)
        return [MesiboImage getDefaultGroupImage];
    
    return [MesiboImage getDefaultProfileImage];
}

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

@implementation MesiboScreen
- (id)init {
    self = [super init];
    if (!self) return self;
  
    [self reset];
    return self;
}

-(void) reset {
    self.parent = nil;
    self.table = nil;
    //self.toolbar = nil;
    self.title = nil;
    self.subtitle = nil;
    self.titleArea = nil;
    self.userList = NO;
    self.options = nil;
}
@end

@implementation MesiboUserListScreen
- (id)init {
    self = [super init];
    if (!self) return self;
  
    [self reset];
    return self;
}

-(void) reset {
    [super reset];
    self.mode = 0;
    self.userList = YES;
    self.search = nil;
}
@end

@implementation MesiboMessageScreen
- (id)init {
    self = [super init];
    if (!self) return self;
  
    [self reset];
    return self;
}

-(void) reset {
    [super reset];
    self.profile = nil;
    self.profileImage = nil;
    self.editText = nil;
}
@end

@implementation MesiboRow

- (id) init {
    self = [super init];
    if (!self) return self;
    
    self.screen = nil; // keep out so that it does not get reset
    [self reset];
    return self;
}

-(void) reset {
    self.row = nil;
    self.message = nil;
    
}

@end

@implementation MesiboUserListRow

- (id)init {
    self = [super init];
    if (!self) return self;
    [self reset];
    return self;
}

-(void) reset {
    [super reset];
    self.profile = nil;
    self.name = nil;
    self.subtitle = nil;
    self.timestamp = nil;
    self.image = nil;
}

@end

@implementation MesiboMessageRow

- (id) init {
    self = [super init];
    if (!self) return self;
    
    [self reset];

    return self;
}

-(void) reset {
    [super reset];
    self.title = nil;
    self.subtitle = nil;
    self.messageText = nil;
    self.filename = nil;
    self.filesize = nil;
    self.name = nil;
    self.heading = nil;
    self.footer = nil;
    self.image = nil;
    self.status = nil;
    self.replyView = nil;
    self.titleView = nil;
}
@end


@implementation MesiboOnClickObject

- (id)init {
    self = [super init];
    if (!self) return self;
    [self reset];
    return self;
}

-(void) reset {
    self.object = nil;
    self.screen = nil;
}

@end


@implementation MesiboScreenOptions

- (id)init {
    self = [super init];
    if (!self) return self;
    [self reset];
    return self;
}

-(void) reset {
    self.sid = 0;
    self.userObject = nil;
}

@end

@implementation MesiboUserListScreenOptions

- (id)init {
    self = [super init];
    if (!self) return self;
    [self reset];
    return self;
}

-(void) reset {
    self.mode = USERLIST_MODE_MESSAGES;
    self.forwardIds = nil;
    self.groupid = 0;
    
    self.listener = nil;
    self.mlistener = nil;
}

@end

@implementation MesiboMessageScreenOptions

- (id)init {
    self = [super init];
    if (!self) return self;
    [self reset];
    return self;
}

-(void) reset {
    self.profile = nil;
    self.listener = nil;
    self.navigation = NO;
}

@end
