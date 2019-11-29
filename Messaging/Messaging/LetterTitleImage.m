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

#import "LetterTitleImage.h"
#import "UIColors.h"

uint32_t gTitleColors[] = {0Xfff16364, 0Xfff58559, 0Xfff9a43e, 0Xffe4c62e, 0Xff67bf74, 0Xff59a2be, 0Xff2093cd, 0Xffad62a7};

@implementation LetterTitleImage

+(UIImage*) drawTitleImage:(NSString*) text  withSize :(int) size

{
    
    NSString *firstChar = @"*";

    if(nil != text && text.length != 0) {
        firstChar = [[text substringToIndex:1] capitalizedString];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.text = firstChar;
    label.font = [UIFont boldSystemFontOfSize:(size*0.7)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    //UIColor *backColor =
    label.backgroundColor = [LetterTitleImage textColor:text];
    
    
    //label.backgroundColor = hex2Rgb((int)titleColors[number]);
    
    label.layer.cornerRadius = label.frame.size.height / 2.0f;
    
    UIGraphicsBeginImageContext(label.frame.size);
    
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    
    return image;
}

+(UIColor *) textColor:(NSString *)text {
    int colorIndex = 0 ;
    
    
    if(nil != text && text.length != 0) {
        colorIndex = [text hash] % 8 ;
    }

    uint32_t bgColor = gTitleColors[colorIndex];
   
    return [UIColor colorWithRed:((float)((bgColor>>16)&0xFF))/255.0 green:((float)((bgColor>>8)&0xFF))/255.0 blue:((float)((bgColor)&0xFF))/255.0 alpha:((float)((bgColor>>24)&0xFF))/255.0];
}


@end
