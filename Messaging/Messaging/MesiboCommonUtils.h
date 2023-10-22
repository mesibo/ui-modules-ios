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
#import "Mesibo/Mesibo.h"

#define PROFILE_STORYBOARD @"profile"
#define PROFILE_BUNDLE @"MesiboUIResource"

@interface MesiboCommonUtils : NSObject

+(NSString *) getUserName:(MesiboProfile *) profile;

+ (UIImage*) getBitmapFromFile:(NSString*) checkFile;
+ (BOOL) isImageFile:(NSString*) filePath ;
+ (UIImage *) profileThumbnailImageFromURL:(NSURL *)videoURL;
+(UIStoryboard *)getMeProfileStoryBoard ;
+(UIStoryboard *) getMeMesiboStoryBoard ;
+(NSBundle *)getBundle ;
+(void) setNavigationBarColor:(UINavigationBar *) navBar color:(UIColor *)color;
//+ (NSString*) getFilePathSimulator:(NSString *) filePath ;

//+ (NSString*) getTnPathSimulator:(NSString *) tnPath ;
+(BOOL) equals:(NSString *)s old:(NSString *)old;
+(BOOL) isEmpty:(NSString *)string;

+(void) associateObject:(id)parent obj:(id)obj;
+(id) getAssociatedObject:(id)parent;

+(BOOL) addTarget:(id)parent view:(id)view action:(SEL)action screen:(id)screen;
+(BOOL) cleanTargets:(id)view ;
@end
