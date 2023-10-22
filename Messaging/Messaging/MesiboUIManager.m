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

#import "MesiboUIManager.h"
#import "UserListViewController.h"
#import "CreateNewGroupViewController.h"
#import "Includes.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVKit/AVKit.h>
#import "MesiboCommonUtils.h"
#import "MesiboConfiguration.h"
#import "E2EViewController.h"


@implementation MesiboUIManager

+ (void) launchUserListViewcontroller:(UIViewController *) parent withChildViewController : (UserListViewController*) childViewController withContactChooser:(int) selection withForwardMessageData:(NSArray *)fwdMessage  withMembersList:(NSString* )memberList withForwardGroupName:(NSString*) forwardGroupName withForwardGroupid:(long) forwardGroupid {
    
    MesiboUserListScreenOptions *opts = [MesiboUserListScreenOptions new];
    opts.mode = selection;
    opts.groupid = forwardGroupid;
    opts.forwardIds = fwdMessage;
    
    childViewController.mOpts = opts;
    
    childViewController.mMode = selection;
    childViewController.mForwardGroupid = forwardGroupid;
    childViewController.forwardIds = fwdMessage;
    
    [parent.navigationController pushViewController:childViewController animated:YES];
    return;
}

+ (void) launchUserListViewcontroller:(UIViewController *)parent opts:(MesiboUserListScreenOptions *)opts {
    UserListViewController *vc = (UserListViewController *) [MesiboUI getUserListViewController:opts];
    if(!vc) return;
    
    // somehow getUserListViewController sets mode to Message, we need to check
    vc.mMode = opts.mode;
    
    [parent.navigationController pushViewController:vc animated:YES];
}




+ (void) launchCreateNewGroupController:(UIViewController *)parent withMemeberProfiles:(NSMutableArray*)profileArray existingMembers:(NSMutableArray *)members withGroupId:(uint32_t) groupid  modifygroup:(BOOL)modifygroup  uidelegate:(id)uidelegate{
    
    CreateNewGroupViewController *clv = [parent.storyboard
                                         instantiateViewControllerWithIdentifier:@"CreateNewGroupViewController"];
    if([clv isKindOfClass:[CreateNewGroupViewController class]]) {
        clv.mMemberProfiles = profileArray;
        clv.mExistingMembers = members;
        clv.mGroupid = groupid;
        clv.mGroupModifyMode = modifygroup;
        clv.mParenController = parent;
        clv.mUiDelegate = uidelegate;
        [parent.navigationController pushViewController:clv animated:YES];
    }
    
    
}

+(void) showE2EInfo:(UIViewController *) parent profile:(MesiboProfile*) profile {
    
    if(!parent)
        return;
    
    
    E2EViewController *cv = [E2EViewController new];
    [cv setProfile:profile];
    cv.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [parent presentViewController:cv animated:YES completion:nil];
    
}


+(void) showMediaFilesInViewer:(UIViewController *) parent withInitialIndex:(int) index withData:(NSArray*) data withTitle:(NSString *)title{
    
    [[ImagePicker sharedInstance] showMediaFilesInViewer:parent withInitialIndex:index withData:data withTitle:title];
}

+(void) showImageInViewer:(UIViewController *) parent withImage:(UIImage*) image withTitle:(NSString *)title  handler:(MesiboImageViewerBlock) handler{
    
    [[ImagePicker sharedInstance] showPhotoInViewer:parent withImage:image withTitle:title handler:handler];
}

+(void) showImageFile:(UIViewController *) parent path:(NSString*) path withTitle:(NSString *)title {
    [ImagePicker showFile:parent path:path title:title type:0];
}

+ (void) showVideofile:(UIViewController *) parent withVideoFilePath:(NSString*) filePath {
    
    if(YES || [MesiboInstance fileExists:filePath]) {
        NSURL *videoURL = [NSURL fileURLWithPath:filePath];
        //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [playerViewController.player play];//Used to Play On start
        [parent presentViewController:playerViewController animated:YES completion:nil];
    }
}

+ (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL fileURLWithPath:scheme];
    
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
    }];
}

UIDocumentInteractionController *documentController;

+ (void) openGenericFiles:(UIViewController *) parent withFilePath:(NSString*) filePath {
    
    NSURL *resourceToOpen = [NSURL fileURLWithPath:filePath];
    BOOL canOpenResource = [[UIApplication sharedApplication] canOpenURL:resourceToOpen];
    if (YES || canOpenResource) {
        documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        documentController.delegate = nil;
        [documentController presentOpenInMenuFromRect:CGRectZero inView:parent.view animated:YES];
    }
    
}


+ (void) pickImageData:(ImagePicker*)im withParent:(id)Parent withMediaType:(int)type withBlockHandler:(void(^)(ImagePickerFile *file))handler {
    if(nil == im){
        im = [ImagePicker sharedInstance];
    }
    
    PickerUiOptions *po = [ImagePicker getUiOptions];
    po.mToolbarColor = [MesiboUI getUiDefaults].mToolbarColor;
    
    im.mParent = Parent;
    [im pickMedia:type :handler];
    
}

+ (void) launchImageEditor:(ImagePicker*)im withParent:(id)Parent withImage:(UIImage *)image title:(NSString*)title hideEditControls:(BOOL)hideControls showCaption:(BOOL)showCaption showCropOverlay:(BOOL)showCropOverlay squareCrop:(BOOL)squareCrop maxDimension:(int)maxDimension withBlock: (MesiboImageEditorBlock)handler {
    if(nil == im){
        im = [ImagePicker sharedInstance];
    }
    im.mParent = Parent;
    [im getImageEditor:image title:title hideEditControl:hideControls showCaption:showCaption showCropOverlay:showCropOverlay squareCrop:squareCrop maxDimension:maxDimension withBlock:handler];
    
}


@end
