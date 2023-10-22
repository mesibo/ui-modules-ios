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
