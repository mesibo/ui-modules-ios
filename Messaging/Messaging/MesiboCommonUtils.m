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

#import "MesiboCommonUtils.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "Includes.h"
#import "MesiboConfiguration.h"
#import <objc/runtime.h>



@implementation MesiboCommonUtils


+(void) setNavigationBarColor:(UINavigationBar *) navBar color:(UIColor *)color {
    //navBar.barTintColor = [UIColor getColor:NAVIGATION_BAR_COLOR];
    navBar.translucent = NO;
    
    navBar.barStyle = UIBarStyleBlack;
    navBar.barTintColor = color;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = color;
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = appearance;
    }
    
}

+(UIStoryboard *)getMeProfileStoryBoard {
    
    NSBundle *bundle =[MesiboCommonUtils getBundle];
    return [UIStoryboard storyboardWithName:PROFILE_STORYBOARD bundle:bundle];
    
}

+(UIStoryboard *)getMeMesiboStoryBoard {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Mesibo" bundle:bundle];
    return sb;
    
}
+(NSBundle *)getBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:PROFILE_BUNDLE withExtension:@"bundle"];
    if(nil == bundleURL) {
        return nil;
    }
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
    return bundle;
    
}


+ (UIImage*) getBitmapFromFile:(NSString*) checkFile {
    UIImage *image = nil;
    BOOL fileExist = [MesiboInstance fileExists:checkFile];
    if(fileExist) {
        if([self isImageFile:checkFile]) {
            image =  [UIImage imageWithContentsOfFile:checkFile];
        } else {
            NSURL *videoUrl = [NSURL fileURLWithPath:checkFile];
            image =[MesiboCommonUtils profileThumbnailImageFromURL:videoUrl];
        }
    }
    
    return image;
}

+ (BOOL) isImageFile:(NSString*) filePath {
    
    BOOL isimage = NO;
    CFStringRef fileExtension = (__bridge CFStringRef) [filePath pathExtension];
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    
    if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
        isimage = YES;
    }
    CFRelease(fileUTI);
    return isimage;
}

+ (UIImage *) profileThumbnailImageFromURL:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = nil;
    CMTime requestedTime = CMTimeMake(1, 60);     // To create thumbnail image
    CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err];
    NSLog(@"err = %@, imageRef = %@", err, imgRef);
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:imgRef];
    CGImageRelease(imgRef);    // MUST release explicitly to avoid memory leak
    
    return thumbnailImage;
}

+(NSString *) getUserName:(MesiboProfile *) profile {
    if(![MesiboCommonUtils isEmpty:[profile getName]])
        return [profile getName];
    
    if(![MesiboCommonUtils isEmpty:[profile getAddress]])
        return [profile getAddress];
    
    return [NSString stringWithFormat:@"Group %u", [profile getGroupId]];
}

+(BOOL) equals:(NSString *)s old:(NSString *)old {
    int sempty = [s length];
    int dempty = [old length];
    if(sempty != dempty) return NO;
    if(!sempty) return YES;
    
    return ([s caseInsensitiveCompare:old] == NSOrderedSame);
}

+(BOOL) isEmpty:(NSString *)string {
    if(/*[NSNull null] == string ||*/ nil == string || 0 == [string length])
        return YES;
    return NO;
}
@end
