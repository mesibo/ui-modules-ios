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

#import <AVFoundation/AVFoundation.h>
#import "UIHelperImageUtils.h"

@implementation UIHelperImageUtils

+(UIImage *) getVideoThumbail:(NSURL *)url {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 2);
    
    CGImageRef oneRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    //[_firstImage setImage:one];
    //firstImage.contentMode = UIViewContentModeScaleAspectFit;
    return one;
}

+(UIImage *) getVideoThumbailFromPath:(NSString *)path {
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    return [self getVideoThumbail:fileURL];
}

+(UIImage *) loadFromFile:(NSString *)filePath {
    return [UIImage imageWithContentsOfFile:filePath];
}

+(UIImage *) loadThumbnail:(NSString *)filePath with:(int)width height:(int)height {
    UIImage *img = [self loadFromFile:filePath];
    CGSize newSize;
    newSize.height = height;
    newSize.width = width;
    
    img = [self imageCroppedToFitSize:img size:newSize];
    return img;
}

+(UIImage *) resizeAndCrop:(UIImage *)img width:(int)width height:(int)height {
    CGSize newSize;
    newSize.height = height;
    newSize.width = width;
    
    return [self imageCroppedToFitSize:img size:newSize];
}

// width and height specifies aspect and minimum size to be maintained
+(UIImage *) resizeAndCropToAspect:(UIImage *)img width:(int)width height:(int)height {
    
    
    int origwidth = img.size.width;
    int origheight = img.size.height;
    
    if(origwidth > width && origheight > height) {
        
        float ratio = (float)origwidth / (float)width;
        
        int newwidth = origwidth;
        int newheight = height*ratio;
        if(newheight > origheight) {
            ratio = (float)origheight / (float)height;
            newheight = origheight;
            newwidth = width*ratio;
        }
    
        height = newheight;
        width = newwidth;
    }
    
    CGSize newSize;
    newSize.height = height;
    newSize.width = width;
    
    return [self imageCroppedToFitSize:img size:newSize];
}


+(UIImage *) resize:(UIImage *)img maxside:(int)maxside {
    CGSize size = [img size];
    int width = (int) size.width;
    int height = (int) size.height;
    int maxinputside = width;
    if(height > width)
        maxinputside = height;
    
    if(maxside >= maxinputside)
        return img;
    
    float multipler = (float)maxside/(float)maxinputside;
    width = (int)(width*multipler);
    height = (int)(height*multipler);
    
    CGSize newSize;
    newSize.height = height;
    newSize.width = width;
    
    return [self imageScaledToFitSize:img size:newSize];
}


+(NSData *) imageCompression:(UIImage *)img compression:(int)compression {
    return UIImageJPEGRepresentation(img, ((float)compression)/100.0);
}

+(UIImage *) imageFromData:(NSData *)data {
    return [UIImage imageWithData:data];
}

+(UIImage *)imageToFitSize:(UIImage *)srcImage size:(CGSize)fitSize method:(MGImageResizingMethod)resizeMethod
{
    float imageScaleFactor = 1.0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    if ([srcImage respondsToSelector:@selector(scale)]) {
        imageScaleFactor = [srcImage scale];
    }
#endif
    
    float sourceWidth = [srcImage size].width * imageScaleFactor;
    float sourceHeight = [srcImage size].height * imageScaleFactor;
    float targetWidth = fitSize.width;
    float targetHeight = fitSize.height;
    BOOL cropping = !(resizeMethod == MGImageResizeScale);
    
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    CGRect sourceRect, destRect;
    if (cropping) {
        destRect = CGRectMake(0, 0, targetWidth, targetHeight);
        float destX = 0.0, destY=0.0;
        if (resizeMethod == MGImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == MGImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
                // Crop top
                destX = 0.0;
                destY = 0.0;
            } else {
                // Crop left
                destX = 0.0;
                destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == MGImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
                // Crop bottom
                destX = round((scaledWidth - targetWidth) / 2.0);
                destY = round(scaledHeight - targetHeight);
            } else {
                // Crop right
                destX = round(scaledWidth - targetWidth);
                destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = CGRectMake(destX / scaleFactor, destY / scaleFactor,
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = CGRectMake(0, 0, sourceWidth, sourceHeight);
        destRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
    }
    
    // Create appropriately modified image.
    UIImage *image = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    CGImageRef sourceImg = nil;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        //TBD, earlier scale factor was 0.f which was keeping the scale factor of 2.0 in UIImage, so even when
        // image was scaled, png representation was returning imagesize*scalled size and making it large. 
        UIGraphicsBeginImageContextWithOptions(destRect.size, NO, 1.0f); // 0.f for scale means "scale for device's main screen".
        sourceImg = CGImageCreateWithImageInRect([srcImage CGImage], sourceRect); // cropping happens here.
        image = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:srcImage.imageOrientation]; // create cropped UIImage.
        
    } else {
        UIGraphicsBeginImageContext(destRect.size);
        sourceImg = CGImageCreateWithImageInRect([srcImage CGImage], sourceRect); // cropping happens here.
        image = [UIImage imageWithCGImage:sourceImg]; // create cropped UIImage.
    }
    
    CGImageRelease(sourceImg);
    [image drawInRect:destRect]; // the actual scaling happens here, and orientation is taken care of automatically.
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#endif
    
    if (!image) {
        // Try older method.
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, scaledWidth, scaledHeight, 8, (scaledWidth * 4),
                                                     colorSpace, kCGImageAlphaPremultipliedLast);
        CGImageRef sourceImg = CGImageCreateWithImageInRect([srcImage CGImage], sourceRect);
        CGContextDrawImage(context, destRect, sourceImg);
        CGImageRelease(sourceImg);
        CGImageRef finalImage = CGBitmapContextCreateImage(context);	
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        image = [UIImage imageWithCGImage:finalImage];
        CGImageRelease(finalImage);
    }
    
    return image;
}


+ (UIImage *)imageCroppedToFitSize:(UIImage*)image size:(CGSize)fitSize
{
    return [self imageToFitSize:image size:fitSize method:MGImageResizeCrop];
}


+ (UIImage *)imageScaledToFitSize:(UIImage*)image size:(CGSize)fitSize
{
    return [self imageToFitSize:image size:fitSize method:MGImageResizeScale];
}

@end
