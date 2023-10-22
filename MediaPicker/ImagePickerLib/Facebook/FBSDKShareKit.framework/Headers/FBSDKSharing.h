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

#import <FBSDKShareKit/FBSDKSharingContent.h>

@protocol FBSDKSharingDelegate;

/*!
 @abstract The common interface for components that initiate sharing.
 @see FBSDKShareDialog
 @see FBSDKMessageDialog
 @see FBSDKShareAPI
 */
@protocol FBSDKSharing <NSObject>

/*!
 @abstract The receiver's delegate or nil if it doesn't have a delegate.
 */
@property (nonatomic, weak) id<FBSDKSharingDelegate> delegate;

/*!
 @abstract The content to be shared.
 */
@property (nonatomic, copy) id<FBSDKSharingContent> shareContent;

/*!
 @abstract A Boolean value that indicates whether the receiver should fail if it finds an error with the share content.
 @discussion If NO, the sharer will still be displayed without the data that was mis-configured.  For example, an
 invalid placeID specified on the shareContent would produce a data error.
 */
@property (nonatomic, assign) BOOL shouldFailOnDataError;

/*!
 @abstract Validates the content on the receiver.
 @param errorRef If an error occurs, upon return contains an NSError object that describes the problem.
 @return YES if the content is valid, otherwise NO.
 */
- (BOOL)validateWithError:(NSError **)errorRef;

@end

/*!
 @abstract The common interface for dialogs that initiate sharing.
 */
@protocol FBSDKSharingDialog <FBSDKSharing>

/*!
 @abstract A Boolean value that indicates whether the receiver can initiate a share.
 @discussion May return NO if the appropriate Facebook app is not installed and is required or an access token is
 required but not available.  This method does not validate the content on the receiver, so this can be checked before
 building up the content.
 @see [FBSDKSharing validateWithError:]
 @result YES if the receiver can share, otherwise NO.
 */
- (BOOL)canShow;

/*!
 @abstract Shows the dialog.
 @result YES if the receiver was able to begin sharing, otherwise NO.
 */
- (BOOL)show;

@end

/*!
 @abstract A delegate for FBSDKSharing.
 @discussion The delegate is notified with the results of the sharer as long as the application has permissions to
 receive the information.  For example, if the person is not signed into the containing app, the sharer may not be able
 to distinguish between completion of a share and cancellation.
 */
@protocol FBSDKSharingDelegate <NSObject>

/*!
 @abstract Sent to the delegate when the share completes without error or cancellation.
 @param sharer The FBSDKSharing that completed.
 @param results The results from the sharer.  This may be nil or empty.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results;

/*!
 @abstract Sent to the delegate when the sharer encounters an error.
 @param sharer The FBSDKSharing that completed.
 @param error The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error;

/*!
 @abstract Sent to the delegate when the sharer is cancelled.
 @param sharer The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer;

@end
