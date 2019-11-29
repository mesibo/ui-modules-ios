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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mesibo/mesibo.h>
#import "UserListViewController.h"

@interface MesiboUIManager : NSObject 


+ (void) launchUserListViewcontroller:(UIViewController *) parent withChildViewController : (UserListViewController*) childViewController withContactChooser:(int) selection withForwardMessageData:(NSArray *) fwdMessage  withMembersList: (NSString* )memberList withForwardGroupName:(NSString*) forwardGroupName withForwardGroupid:(long) forwardGroupid;

+(void) launchMessageViewController:(UIViewController *) parent withUserData : (MesiboUserProfile*) userProfile uidelegate:(id)uidelegate;

+ (void) launchCreatNewGroupController:(UIViewController *)parent withMemeberProfiles:(NSMutableArray*) profileArray withGroupId:(uint32_t) groupid modifygroup:(BOOL)modifygroup uidelegate:(id)uidelegate;

+(void) showMediaFilesInViewer:(UIViewController *) parent withInitialIndex:(int) index withData:(NSArray*) data withTitle:(NSString *)title;

+(void) showImageInViewer:(UIViewController *) parent withImage:(UIImage*) image withTitle:(NSString *)title;

+ (void) showVideofile:(UIViewController *) parent withVideoFilePath:(NSString*) filePath;

+ (void) openGenericFiles:(UIViewController *) parent withFilePath:(NSString*) filePath;

+ (void) pickImageData:(ImagePicker*)im withParent:(id)Parent withMediaType:(int)type withBlockHandler:(void(^)(ImagePickerFile *file))handler ;

+ (void) launchImageEditor:(ImagePicker*)im withParent:(id)Parent withImage:(UIImage *)image title:(NSString*)title hideEditControls:(BOOL)hideControls showCaption:(BOOL)showCaption showCropOverlay:(BOOL)showCropOverlay squareCrop:(BOOL)squareCrop maxDimension:(int)maxDimension withBlock: (MesiboImageEditorBlock)handler;
@end
