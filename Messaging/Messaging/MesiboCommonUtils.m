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

#import "MesiboCommonUtils.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "Includes.h"
#import "MesiboConfiguration.h"



@implementation MesiboCommonUtils


+(void) setNavigationBarColor:(UINavigationBar *) navBar color:(UIColor *)color {
    //navBar.barTintColor = [UIColor getColor:NAVIGATION_BAR_COLOR];
    navBar.translucent = NO;
    
    navBar.barStyle = UIBarStyleBlack;
    navBar.barTintColor = color;
    
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

+ (NSString*) getFilePathSimulator:(NSString *) filePath {
    NSString *fullPath = [MesiboInstance getFilePath:MESIBO_FILETYPE_IMAGE];
    if(nil != filePath)
    fullPath = [fullPath stringByAppendingString:filePath];
    return fullPath;
}

+ (NSString*) getTnPathSimulator:(NSString *) tnPath {
    NSString *imagePath = [MesiboInstance getFilePath:MESIBO_FILETYPE_IMAGE];
    imagePath = [imagePath stringByAppendingPathComponent:@"/tn/"];
    if(nil != tnPath)
        imagePath = [imagePath stringByAppendingString:tnPath];
    return imagePath;
}

+(NSString *) getUserName:(MesiboUserProfile *) profile {
    if(![MesiboCommonUtils isEmpty:profile.name])
        return profile.name;
    
    if(![MesiboCommonUtils isEmpty:profile.address])
        return profile.address;
    
    return [NSString stringWithFormat:@"Group %u", profile.groupid];
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
