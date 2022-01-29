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

#import "MesiboUIManager.h"
#import "UserListViewController.h"
#import "CreateNewGroupViewController.h"
#import "Includes.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVKit/AVKit.h>
#import "MesiboCommonUtils.h"
#import "MesiboConfiguration.h"


@implementation MesiboUIManager

+ (void) launchUserListViewcontroller:(UIViewController *) parent withChildViewController : (UserListViewController*) childViewController withContactChooser:(int) selection withForwardMessageData:(NSArray *)fwdMessage  withMembersList:(NSString* )memberList withForwardGroupName:(NSString*) forwardGroupName withForwardGroupid:(long) forwardGroupid {

    
    childViewController.mNewContactChooser = selection;
    childViewController.mForwardGroupid = forwardGroupid;
    childViewController.fwdMessage = fwdMessage;

    
    [parent.navigationController pushViewController:childViewController animated:YES];
    return;
}

+(void) launchMessageViewController:(UIViewController *) parent withUserData : (MesiboProfile*) userProfile uidelegate:(id)uidelegate {
    
    if(!parent)
        return;
        
    UIStoryboard *storyboard = [MesiboCommonUtils getMeMesiboStoryBoard];
    MessageViewController *cv = (MessageViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    if([cv isKindOfClass:[MessageViewController class]]) {
        cv.mUser = userProfile ;
        [cv setTableViewDelegate:uidelegate];
        
        if(parent.navigationController)
            [parent.navigationController pushViewController:cv animated:YES];
        else
            [parent presentViewController:cv animated:YES completion:nil];
        
        return;
    }

}

+(void) launchMessageViewController1:(UIViewController *) parent withUserData : (MesiboProfile*) userProfile {
    
    if(!parent)
        return;
    
    UIStoryboard *storyboard = [MesiboCommonUtils getMeMesiboStoryBoard];
    MessageViewController *cv = (MessageViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    if([cv isKindOfClass:[MessageViewController class]]) {
        cv.mUser = userProfile ;
        if(parent.navigationController)
            [parent.navigationController pushViewController:cv animated:YES];
        else
            [parent presentViewController:cv animated:YES completion:nil];
        
        return;
    }
    
}

+ (void) launchCreatNewGroupController:(UIViewController *)parent withMemeberProfiles:(NSMutableArray*)profileArray existingMembers:(NSMutableArray *)members withGroupId:(uint32_t) groupid  modifygroup:(BOOL)modifygroup  uidelegate:(id)uidelegate{
    
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

+(void) showMediaFilesInViewer:(UIViewController *) parent withInitialIndex:(int) index withData:(NSArray*) data withTitle:(NSString *)title{
    
    [[ImagePicker sharedInstance] showMediaFilesInViewer:parent withInitialIndex:index withData:data withTitle:title];
}

+(void) showImageInViewer:(UIViewController *) parent withImage:(UIImage*) image withTitle:(NSString *)title{
    
    [[ImagePicker sharedInstance] showPhotoInViewer:parent withImage:image withTitle:title];
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

//https://useyourloaf.com/blog/querying-url-schemes-with-canopenurl/
+ (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    //NSURL *URL = [NSURL URLWithString:scheme];
    NSURL *URL = [NSURL fileURLWithPath:scheme];
    
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened %@",scheme);
        }
    }];
}

//Global is needed, else UIDocumentInteractionController is crashing once local variable out of scope
UIDocumentInteractionController *documentController;

+ (void) openGenericFiles:(UIViewController *) parent withFilePath:(NSString*) filePath {
    
    //[self openScheme:filePath];
    //return;
    
    NSURL *resourceToOpen = [NSURL fileURLWithPath:filePath];
    BOOL canOpenResource = [[UIApplication sharedApplication] canOpenURL:resourceToOpen];
    if (YES || canOpenResource) {
        //UIApplication *application = [UIApplication sharedApplication];
        //[application openURL:resourceToOpen options:@{} completionHandler:nil];
        
        documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        documentController.delegate = nil;
        [documentController presentOpenInMenuFromRect:CGRectZero inView:parent.view animated:YES];
    }

}


+ (void) pickImageData:(ImagePicker*)im withParent:(id)Parent withMediaType:(int)type withBlockHandler:(void(^)(ImagePickerFile *file))handler {
    if(nil == im){
        im = [ImagePicker sharedInstance];
    }
    im.mParent = Parent;
    [im pickMedia:type :handler];
    
}

+ (void) launchImageEditor:(ImagePicker*)im withParent:(id)Parent withImage:(UIImage *)image title:(NSString*)title hideEditControls:(BOOL)hideControls showCaption:(BOOL)showCaption showCropOverlay:(BOOL)showCropOverlay squareCrop:(BOOL)squareCrop maxDimension:(int)maxDimension withBlock: (MesiboImageEditorBlock)handler {
    if(nil == im){
        im = [ImagePicker sharedInstance];
    }
    im.mParent = Parent;
    //[im getImageEditor:image withTitle:title hideEditControl:hideControls withBlock:handler];
    //TBD, 1280 -> take from mUiOptions
    [im getImageEditor:image title:title hideEditControl:hideControls showCaption:showCaption showCropOverlay:showCropOverlay squareCrop:squareCrop maxDimension:maxDimension withBlock:handler];
    
}


@end
