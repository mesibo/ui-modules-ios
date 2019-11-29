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

#import "ImagePickerUtils.h"
#import <UIKit/UIKit.h>
#import "UIColors.h"
#import "UIImage+Tint.h"
#import "Defines.h"
#import "UIAlerts.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


@implementation ImagePickerUtils

static NSMutableArray * statusImages;





+ (UIImage *)getDefaultImageForExt:(NSString *)ext
{
    UIImage *image = [ImagePickerUtils imageNamed:@"DOCS"];

    
    if([ext isEqualToString:@"MP4" ] || [ext isEqualToString:@"mp4" ])
    return [ImagePickerUtils imageNamed:@"MP4"];
    else if ([ext isEqualToString:@"MP3"] || [ext isEqualToString:@"mp3"])
    return [ImagePickerUtils imageNamed:@"MP3"];
    else if ([ext isEqualToString:@"TXT"] || [ext isEqualToString:@"txt"])
        return [ImagePickerUtils imageNamed:@"TXT"];
    else if ([ext isEqualToString:@"PDF"] || [ext isEqualToString:@"pdf"])
        return [ImagePickerUtils imageNamed:@"PDF"];
    else if ([ext isEqualToString:@"DOC"] || [ext isEqualToString:@"doc"])
        return [ImagePickerUtils imageNamed:@"DOC"];
    else if ([ext isEqualToString:@"DOCX"] || [ext isEqualToString:@"docx"])
        return [ImagePickerUtils imageNamed:@"DOC"];
    else if ([ext isEqualToString:@"ZIP"] || [ext isEqualToString:@"zip"])
        return [ImagePickerUtils imageNamed:@"ZIP"];
    else if ([ext isEqualToString:@"RAR"] || [ext isEqualToString:@"rar"])
        return [ImagePickerUtils imageNamed:@"RAR"];
    else if ([ext isEqualToString: @"XLS"] || [ext isEqualToString:@"xls"])
        return [ImagePickerUtils imageNamed:@"XLS"];
    else if ([ext isEqualToString: @"JPG"] || [ext isEqualToString:@"jpg"])
        return [ImagePickerUtils imageNamed:@"JPG"];
    else if ([ext isEqualToString: @"PNG"] || [ext isEqualToString:@"png"])
        return [ImagePickerUtils imageNamed:@"JPG"];

   else
    
    return image;
    
    
}




+ (UIImage*) getDefaultMapImage {
    
    return [ImagePickerUtils imageNamed:@"dmap"];
}
+ (UIImage*) getDefaultMusicImage {
    
    return [ImagePickerUtils imageNamed:@"music"];
}
+ (UIImage*) getDefaultDocumentImage {

    return [ImagePickerUtils imageNamed:@"DOCS"];
}

+ (UIImage*) getDefaultProfileImage {
    
    return [ImagePickerUtils imageNamed:@"blank_profile"];
}

+(UIImage *)imageNamed:(NSString *)imageName {
    
    
    NSBundle *bundle =[ImagePickerUtils getBundle];
    return [UIImage imageNamed:imageName
                      inBundle:bundle compatibleWithTraitCollection:nil];
    
    
    
}

+(UIStoryboard *)getMeImageStoryBoard {
    
    
    NSBundle *bundle =[ImagePickerUtils getBundle];
    
    return [UIStoryboard storyboardWithName:IMAGELIB_STORY_BOARD bundle:bundle];
    
    
    
}

+(UIStoryboard *)getMeImageVuStoryBoard {
    
    NSBundle *bundle =[ImagePickerUtils getBundle];
    
    return [UIStoryboard storyboardWithName:IMAGEVU_STORY_BOARD bundle:bundle];
    
    
    
}
+(NSBundle *)getBundle {
    
    
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:PICKER_BUNDLE withExtension:@"bundle"];
    
    if(nil == bundleURL) {
        
        return nil;
        
    }
    NSBundle *bundle = [[NSBundle alloc] initWithURL:bundleURL];
    
    
    return bundle;
    
}

+ (BOOL) isUrl:(NSString *) path {
    
    if ([path.lowercaseString hasPrefix:@"http://"] || [path.lowercaseString hasPrefix:@"https://"] ) {
        return YES;
    } else {
        return NO;
    }
    
}


+ (UIImage *)thumbnailImageFromURL:(NSURL *)videoURL {
    
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


+ (UIImage*) getBitmapFromFile:(NSString*) checkFile {
    UIImage *image = nil;
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:checkFile];
    if(fileExist) {
        if([self isImageFile:checkFile]) {
            image =  [UIImage imageWithContentsOfFile:checkFile];
        } else {
            NSURL *videoUrl = [NSURL fileURLWithPath:checkFile];
            image =[ImagePickerUtils thumbnailImageFromURL:videoUrl];
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

@end
