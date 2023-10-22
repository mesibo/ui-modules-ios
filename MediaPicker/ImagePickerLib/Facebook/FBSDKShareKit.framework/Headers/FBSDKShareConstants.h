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

#import <FBSDKCoreKit/FBSDKMacros.h>

/*!
 @abstract The error domain for all errors from FBSDKShareKit.
 @discussion Error codes from the SDK in the range 200-299 are reserved for this domain.
 */
FBSDK_EXTERN NSString *const FBSDKShareErrorDomain;

/*!
 @typedef NS_ENUM(NSInteger, FBSDKShareErrorCode)
 @abstract Error codes for FBSDKShareErrorDomain.
 */
typedef NS_ENUM(NSInteger, FBSDKShareErrorCode)
{
  /*!
   @abstract Reserved.
   */
  FBSDKShareReservedErrorCode = 200,

  /*!
   @abstract The error code for errors from uploading open graph objects.
   */
  FBSDKShareOpenGraphErrorCode,

  /*!
   @abstract The error code for when a sharing dialog is not available.
   @discussion Use the canShare methods to check for this case before calling show.
   */
  FBSDKShareDialogNotAvailableErrorCode,

  /*!
   @The error code for unknown errors.
   */
  FBSDKShareUnknownErrorCode,
};
