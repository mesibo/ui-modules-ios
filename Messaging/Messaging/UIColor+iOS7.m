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

//
//  UIColor+iOS7.m
//  FFCircularProgressView
//
//  Created by Fabiano Francesconi on 16/07/13.
//  Copyright (c) 2013 Fabiano Francesconi. All rights reserved.
//

#import "UIColor+iOS7.h"

@implementation UIColor (iOS7)

+ (UIColor *) ios7Blue {
    return [self colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
}

+ (UIColor *) ios7Gray {
    return [self colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
}

+(UIColor *) getColor:(uint32_t) color {

    return [UIColor colorWithRed:((float)((color>>16)&0xFF))/255.0 green:((float)((color>>8)&0xFF))/255.0 blue:((float)((color)&0xFF))/255.0 alpha:((float)((color>>24)&0xFF))/255.0];
}

@end
