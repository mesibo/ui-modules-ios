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

@interface UIHelperImageUtils : NSObject

typedef enum {
    MGImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} MGImageResizingMethod;


+(UIImage *) resizeAndCrop:(UIImage *)img width:(int)width height:(int)height;
+(UIImage *) resize:(UIImage *)img maxside:(int)maxside;
+(NSData *) imageCompression:(UIImage *)img compression:(int)compression;
+(UIImage *) imageFromData:(NSData *)data;
+(UIImage *) loadFromFile:(NSString *)filePath;
+(UIImage *) getVideoThumbail:(NSURL *)url;
+(UIImage *) getVideoThumbailFromPath:(NSString *)path;
+(UIImage *) resizeAndCropToAspect:(UIImage *)img width:(int)width height:(int)height;
@end
