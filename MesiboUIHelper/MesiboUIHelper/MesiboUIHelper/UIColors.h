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
