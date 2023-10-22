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

#import <UIKit/UIKit.h>
#import "basicViewController.h"
#import "MesiboUIHelper.h"





@interface registerMobileViewController : BasicViewController <UITextFieldDelegate>


@property (weak , nonatomic) IBOutlet UITextField *mPhoneNumberTextField;

@property (strong, nonatomic) NSString *mCountryCode;
@property (strong, nonatomic) NSString *mCountryName;
@property (strong, nonatomic) NSString *mPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *mRegisterMobileDetailsLbl;

@property (strong, nonatomic) IBOutlet UILabel *mRegisterMobileInfoLbl;
@property (strong, nonatomic) IBOutlet UIView *mChangeCountryButton;
@property (strong, nonatomic) IBOutlet UILabel *mRegisterMobileHeaderLbl;

@property (strong, nonatomic) IBOutlet UIButton *mRegisterMobileButton;

@property (weak, nonatomic) IBOutlet UITextField *mCountryCodeTextField;

@property (strong, nonatomic) UIViewController* mRegisterParent;
//TBD
@property (strong, nonatomic) PhoneVerificationBlock mLoginBlock;

@property (weak, nonatomic) IBOutlet UIButton *mHaveOTPCodeBtn;


@property (weak, nonatomic) IBOutlet UILabel *mPhoneNumberText;
@property (weak, nonatomic) IBOutlet UILabel *mCountryText;

@property (weak, nonatomic) IBOutlet UILabel *mHiphanText;

@end
