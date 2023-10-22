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

#import <Foundation/Foundation.h>


#if 0
#define WELCOME_BACKGROUND_COLOR        PRIMARY_COLOR
#define WELCOME_TEXT_COLOR              WHITE_COLOR
#define LOGIN_DEFAULT_BACKGROUND_COLOR  PRIMARY_COLOR
#define LOGIN_BUTTON_BACKGROUND_COLOR   PRIMARY_DARK_COLOR
#define LOGIN_BUTTON_TEXT_COLOR         WHITE_COLOR
#define LOGIN_PRIMARY_TEXT_COLOR        WHITE_COLOR
#define LOGIN_SECONDARY_TEXT_COLOR      BLACK_COLOR
#endif

#define STARTUP_TEXT_POSITION_X                 10
#define STARTUP_TEXT_POSITION_APPNAME_Y         100
#define STARTUP_TEXT_POSITION_APPNAME_HEIGHT    50

#define STARTUP_TEXT_POSITION_TAGNAME_Y         130
#define STARTUP_TEXT_POSITION_TAGNAME_HEIGHT    100

#define APPNAME_FONTSIZE                        40.0
#define TAGLINE_FONTSIZE                        16.0


#define PHONE_REGISTRATION_HEADER_TEXT @"Enter your phone number"
#define PHONE_REGISTRATION_DISCRIPTION_TEXT @"We will send you a SMS with verification code to confirm your number."
#define PHONE_REGISTRATION_BOTTOM_TEXT @"Note, Mesibo may call instead of sending an SMS if SMS delivery to your phone fails."


#define PHONE_REGISTRATION_FAIL_MESSAGE  @"Invalid number. Please register with your other number"

#define PHONE_REGISTRATION_FAIL_TITLE  @"Registration Failed!"
#define    REGISTER_INVALID_PHONE_TITLE  @"Invalid Number"
#define    REGISTER_INVALID_PHONE_MSG  @"This is invalid phone numer please check it once again to verify"
#define    REGISTER_MOBILE_CONFIMATION_MSG  @"We are about to verify your phone number:\n\n+%@\n\nIs this number correct?"
#define    REGISTER_MOBILE_CONFIMATION_TITLE  @"Number Confimed ?"


/*-----------------verifyMobileViewController -----------------------*/


#define    VERIFY_INVALID_OTP_MSG @"Please enter the exact code which has been sent on your registered phone number"
#define    VERIFY_INVALID_OTP_TITLE @"Invalid Code"

#define VERIFICATION_FAILED_TITLE @"Verification Failed!"
#define VERIFICATION_FAILED_MESSAGE @"Code invalid please type the exact code which was sent to you."
#define YOUR_NUMBER @"Your Number"

#define CODE_VERIFICATION_HEADER @"Enter Verification Code"
#define CODE_VERIFICATION_DISCRIPTION_INFO @"We have sent a SMS with verification code to %@ It may take a few minutes to receive it."
#define CODE_VERIFICATION_BOTTOM_INFO @"You may restart the verification if you don't receive your code within 15 minutes."


#define DEFAULT_COUNTRY 91

