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
#import <mesibo/mesibo.h>
#import "UserListViewController.h"

@interface MesiboUIManager : NSObject 


+ (void) launchUserListViewcontroller:(UIViewController *)parent opts:(MesiboUserListScreenOptions *)opts;

+ (void) launchUserListViewcontroller:(UIViewController *) parent withChildViewController : (UserListViewController*) childViewController withContactChooser:(int) selection withForwardMessageData:(NSArray *) fwdMessage  withMembersList: (NSString* )memberList withForwardGroupName:(NSString*) forwardGroupName withForwardGroupid:(long) forwardGroupid;

+ (void) launchCreateNewGroupController:(UIViewController *)parent withMemeberProfiles:(NSMutableArray*)profileArray existingMembers:(NSMutableArray *)members withGroupId:(uint32_t) groupid  modifygroup:(BOOL)modifygroup  uidelegate:(id)uidelegate;

+(void) showMediaFilesInViewer:(UIViewController *) parent withInitialIndex:(int) index withData:(NSArray*) data withTitle:(NSString *)title;

+(void) showImageInViewer:(UIViewController *) parent withImage:(UIImage*) image withTitle:(NSString *)title handler:(MesiboImageViewerBlock) handler;
+(void) showImageFile:(UIViewController *) parent path:(NSString*) path withTitle:(NSString *)title;

+ (void) showVideofile:(UIViewController *) parent withVideoFilePath:(NSString*) filePath;

+ (void) openGenericFiles:(UIViewController *) parent withFilePath:(NSString*) filePath;

+ (void) pickImageData:(ImagePicker*)im withParent:(id)Parent withMediaType:(int)type withBlockHandler:(void(^)(ImagePickerFile *file))handler ;

+ (void) launchImageEditor:(ImagePicker*)im withParent:(id)Parent withImage:(UIImage *)image title:(NSString*)title hideEditControls:(BOOL)hideControls showCaption:(BOOL)showCaption showCropOverlay:(BOOL)showCropOverlay squareCrop:(BOOL)squareCrop maxDimension:(int)maxDimension withBlock: (MesiboImageEditorBlock)handler;

+(void) showE2EInfo:(UIViewController *) parent profile:(MesiboProfile*) profile;

@end
