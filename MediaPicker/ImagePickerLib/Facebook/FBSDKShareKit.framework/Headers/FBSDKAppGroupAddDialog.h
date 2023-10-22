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

// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#import <FBSDKShareKit/FBSDKAppGroupContent.h>

@protocol FBSDKAppGroupAddDialogDelegate;

/*!
 @abstract A dialog for creating app groups.
 */
@interface FBSDKAppGroupAddDialog : NSObject

/*!
 @abstract Convenience method to build up an app group dialog with content and a delegate.
 @param content The content for the app group.
 @param delegate The receiver's delegate.
 */
+ (instancetype)showWithContent:(FBSDKAppGroupContent *)content
                       delegate:(id<FBSDKAppGroupAddDialogDelegate>)delegate;

/*!
 @abstract The receiver's delegate or nil if it doesn't have a delegate.
 */
@property (nonatomic, weak) id<FBSDKAppGroupAddDialogDelegate> delegate;

/*!
 @abstract The content for app group.
 */
@property (nonatomic, copy) FBSDKAppGroupContent *content;

/*!
 @abstract A Boolean value that indicates whether the receiver can initiate an app group dialog.
 @discussion May return NO if the appropriate Facebook app is not installed and is required or an access token is
 required but not available.  This method does not validate the content on the receiver, so this can be checked before
 building up the content.
 @see validateWithError:
 @result YES if the receiver can share, otherwise NO.
 */
- (BOOL)canShow;

/*!
 @abstract Begins the app group dialog from the receiver.
 @result YES if the receiver was able to show the dialog, otherwise NO.
 */
- (BOOL)show;

/*!
 @abstract Validates the content on the receiver.
 @param errorRef If an error occurs, upon return contains an NSError object that describes the problem.
 @return YES if the content is valid, otherwise NO.
 */
- (BOOL)validateWithError:(NSError *__autoreleasing *)errorRef;

@end

/*!
 @abstract A delegate for FBSDKAppGroupAddDialog.
 @discussion The delegate is notified with the results of the app group request as long as the application has
 permissions to receive the information.  For example, if the person is not signed into the containing app, the shower
 may not be able to distinguish between completion of an app group request and cancellation.
 */
@protocol FBSDKAppGroupAddDialogDelegate <NSObject>

/*!
 @abstract Sent to the delegate when the app group request completes without error.
 @param appGroupAddDialog The FBSDKAppGroupAddDialog that completed.
 @param results The results from the dialog.  This may be nil or empty.
 */
- (void)appGroupAddDialog:(FBSDKAppGroupAddDialog *)appGroupAddDialog didCompleteWithResults:(NSDictionary *)results;

/*!
 @abstract Sent to the delegate when the app group request encounters an error.
 @param appGroupAddDialog The FBSDKAppGroupAddDialog that completed.
 @param error The error.
 */
- (void)appGroupAddDialog:(FBSDKAppGroupAddDialog *)appGroupAddDialog didFailWithError:(NSError *)error;

/*!
 @abstract Sent to the delegate when the app group dialog is cancelled.
 @param appGroupAddDialog The FBSDKAppGroupAddDialog that completed.
 */
- (void)appGroupAddDialogDidCancel:(FBSDKAppGroupAddDialog *)appGroupAddDialog;

@end
