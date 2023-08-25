/** Copyright (c) 2023 Mesibo, Inc
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

#import "UIColors.h"


@implementation UIColor (Extensions)


+ (UIColor *) titleColor0 {
    return hex2Rgb(TITLE_COLOR_0);
}
+ (UIColor *) titleColor1 {
    return hex2Rgb(TITLE_COLOR_1);
}
+ (UIColor *) titleColor2 {
    return hex2Rgb(TITLE_COLOR_2);
}
+ (UIColor *) titleColor3 {
    return hex2Rgb(TITLE_COLOR_3);
}
+ (UIColor *) titleColor4 {
    return hex2Rgb(TITLE_COLOR_4);
}
+ (UIColor *) titleColor5 {
    return hex2Rgb(TITLE_COLOR_5);
}
+ (UIColor *) titleColor6 {
    return hex2Rgb(TITLE_COLOR_6);
}
+ (UIColor *) titleColor7 {
    return hex2Rgb(TITLE_COLOR_7);
}

+(UIColor *) toastColor {
    return hex2Rgb(TOAST_COLOR);
}

+(UIColor *) pullRefreshColor {
    return hex2Rgb(PULLREFRESH_COLOR);
}


//+ (UIColor *)getColor:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
//    return [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
//}

+(UIColor *) getColorView:(UInt32) color {
    if(USE_ALL_DEFAULT_COLOR)
        return [ UIColor whiteColor];
    if(color == USE_DEFAULT_COLOR)
        return [ UIColor whiteColor];
    
    
    return hex2Rgb(color);
}

+(UIColor *) getColorNavTtl:(UInt32) color {
    if(USE_ALL_DEFAULT_COLOR)
        return [ UIColor blackColor];
    if(color == USE_DEFAULT_COLOR)
        return [ UIColor blackColor];
    
    
    return hex2Rgb(color);
}
+(UIColor *) getColor:(UInt32) color {
    
    if(USE_ALL_DEFAULT_COLOR)
        return nil;
    if(color == USE_DEFAULT_COLOR)
        return nil;
    
    
    return [UIColor colorWithRed:((float)((color>>16)&0xFF))/255.0 green:((float)((color>>8)&0xFF))/255.0 blue:((float)((color)&0xFF))/255.0 alpha:((float)((color>>24)&0xFF))/255.0];
}


+ (UIColor *) toolBarColor {
    return [UIColor getColor:TOOLBAR_COLOR];
}



@end
