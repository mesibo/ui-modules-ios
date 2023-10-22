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

#include <UIKit/UIKit.h>
#define USE_ALL_DEFAULT_COLOR 0

#define USE_DEFAULT_COLOR 0x00ffffff

#define hex2Rgb(c) \
[UIColor colorWithRed:((float)((c>>16)&0xFF))/255.0 green:((float)((c>>8)&0xFF))/255.0 blue:((float)((c)&0xFF))/255.0 alpha:((float)((c>>24)&0xFF))/255.0]

#define PRIMARY_COLOR           0xff03A9F4
#define BUTTON_TEXT_COLOR       WHITE_COLOR
#define BUTTON_COLOR            PRIMARY_DARK_COLOR

#define PRIMARY_DARK_COLOR      0xff1565c0
#define PRIMARY_LIGHT_COLOR     0xff42a5f5
#define PRIMARY_ACCENT_COLOR    0xffFF4081

#define PRIMARY_TEXT_COLOR      0xff212121
#define ERROR_COLOR             0xffff2222

#define WHITE_COLOR             0xffffffff
#define LIGHT_GRAY              0Xffeaeaea
#define BLACK_COLOR             0xff000000
#define GREEN_CALL_COLOR        0XFF00fb11


// set this navigationbar background color dafault is white //
#define TOOLBAR_COLOR               PRIMARY_COLOR

// set this for back ground color of each view controller  default is white//
#define BACKGROUND_COLOR            PRIMARY_LIGHT_COLOR



/* ------------------ Buttons ------------------------------------------*/
// set this for buttons background color dafault is nil //

//set this for Button tiltle color for those button whose back ground is changed //
#define BUTTON_TITLE_COLOR          WHITE_COLOR
#define BUTTON_TITLE_COLOR_SETTINGS  PRIMARY_LIGHT_COLOR


//set here for buttons with underlined or only text button like login, signup, forget password//
#define BUTTON_LABLE_COLOR          WHITE_COLOR


/*--------------------Navigation Bar-------------------------------------*/
// set this for navigation title color default is black //
#define NAVIGATION_BAR_TITLE_COLOR  WHITE_COLOR

//set this for sysmbole color if any -default is black //
#define NAVIGATION_BAR_TINT         WHITE_COLOR



@interface UIColor (Extension)

//+ (UIColor *) getColor:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness ;
+ (UIColor *) getButtonColor ;
+ (UIColor *) getColor:(UInt32) color;

@end
