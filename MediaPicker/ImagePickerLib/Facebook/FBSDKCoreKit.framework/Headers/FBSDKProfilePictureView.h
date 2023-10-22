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

#import <UIKit/UIKit.h>

/*!
 @typedef FBSDKProfilePictureMode enum
 @abstract Defines the aspect ratio mode for the source image of the profile picture.
 */
typedef NS_ENUM(NSUInteger, FBSDKProfilePictureMode)
{
  /*!
   @abstract A square cropped version of the image will be included in the view.
   */
  FBSDKProfilePictureModeSquare,
  /*!
   @abstract The original picture's aspect ratio will be used for the source image in the view.
   */
  FBSDKProfilePictureModeNormal,
};

/*!
 @abstract A view to display a profile picture.
 */
@interface FBSDKProfilePictureView : UIView

/*!
 @abstract The mode for the receiver to determine the aspect ratio of the source image.
 */
@property (nonatomic, assign) FBSDKProfilePictureMode pictureMode;

/*!
 @abstract The profile ID to show the picture for.
 */
@property (nonatomic, copy) NSString *profileID;

/*!
 @abstract Explicitly marks the receiver as needing to update the image.
 @discussion This method is called whenever any properties that affect the source image are modified, but this can also
 be used to trigger a manual update of the image if it needs to be re-downloaded.
 */
- (void)setNeedsImageUpdate;

@end
