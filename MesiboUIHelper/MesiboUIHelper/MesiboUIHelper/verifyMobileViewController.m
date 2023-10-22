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

#import "verifyMobileViewController.h"
//#import "includes.h"
#import "LoginConfiguration.h"
#import "UIColors.h"
#import "UIAlertsDialogue.h"


// VerifyCodeController


@implementation verifyMobileViewController 
{
    BOOL _done;
}
@synthesize mVerifiyPhoneNumber;
@synthesize mVerifyDetailsLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _done = NO;
    
    MesiboUiHelperConfig *config = [MesiboUIHelper getUiConfig];
    
    self.view.backgroundColor = [UIColor getColor:config.mBackgroundColor];
    self.mVerifyOtpBtn.backgroundColor = [UIColor getColor:config.mButtonBackgroundColor];
    [self.mVerifyOtpBtn setTitleColor:[UIColor getColor:config.mButtonTextColor] forState:UIControlStateNormal] ;
    [_mStartAgainBtn setTintColor:[UIColor getColor:config.mTextColor]] ;
    _mVerifiyHeaderLabel.text = CODE_VERIFICATION_HEADER;
    _mVerifiyHeaderLabel.textColor = [UIColor getColor:config.mTextColor];
    
    _mBottomInfoLabel.text = CODE_VERIFICATION_BOTTOM_INFO;
    _mBottomInfoLabel.textColor = [UIColor getColor:config.mTextColor];
    
    //self.mVerifyDetailsLabel.text = CODE_VERIFICATION_DISCRIPTION_INFO;
    self.mVerifyDetailsLabel.textColor = [UIColor getColor:config.mTextColor];

}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    if(_done)
        return YES;
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSString *code;
    if (nil != self.mVerifiyPhoneNumber || self.mVerifiyPhoneNumber.length !=0 ){
        NSString *phoneString = [NSString stringWithFormat:@"+%@", self.mVerifiyPhoneNumber];
        code  = [NSString stringWithFormat:CODE_VERIFICATION_DISCRIPTION_INFO, phoneString];
    }else {
        code  = [NSString stringWithFormat:CODE_VERIFICATION_DISCRIPTION_INFO,YOUR_NUMBER];
    }

    self.mVerifyDetailsLabel.text = code;
    [_mOtpTextField becomeFirstResponder];

}





- (IBAction) verifyOTPCode :(id) sender {
    
    if(self.mOtpTextField.text.length != 6) {
        [UIAlertsDialogue showDialogue:VERIFY_INVALID_OTP_MSG withTitle:VERIFY_INVALID_OTP_TITLE];
        return ;
        
    }

    if([_mOtpTextField isFirstResponder])
       [_mOtpTextField resignFirstResponder];
    
    [self resignFirstResponder];
    
    [_mOtpTextField endEditing:YES];
    
    if(self.mLoginBlock) {
        self.mLoginBlock(self, mVerifiyPhoneNumber, self.mOtpTextField.text, ^(BOOL result) {
            
            if(result) {
                /* no need to dismiis we can launch mesibo as rootview controller */
                //[self dismissViewControllerAnimated:YES completion:nil];
                _done = YES;
                
            } else {
                
                [UIAlertsDialogue showDialogue:VERIFICATION_FAILED_MESSAGE withTitle:VERIFICATION_FAILED_TITLE];
                
            }
        });
    }
        //[self.mDelegate onLogin:mVerifiyPhoneNumber code:self.mOtpTextField.text caller:self];
    
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerFromStart:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
