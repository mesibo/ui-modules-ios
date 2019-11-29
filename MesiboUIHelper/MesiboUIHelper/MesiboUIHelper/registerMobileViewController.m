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

#import "registerMobileViewController.h"
#import "verifyMobileViewController.h"
#import "UIColors.h"
#import "UIAlertsDialogue.h"
#import "LoginConfiguration.h"
#import "MesiboUIHelper.h"
#import "countryTableViewController.h"
#import "LoginUImanager.h"

#import "UIAlertsDialogue.h"

@interface registerMobileViewController ()


@end


@implementation registerMobileViewController


@synthesize mCountryCode;
@synthesize mCountryName;
@synthesize mPhoneNumber;

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
    //mCountry
    
    [super viewDidLoad];
    MesiboUiHelperConfig *config = [MesiboUIHelper getUiConfig];
    
    self.mCountryCode = config.mCountryCode;
    self.mCountryName = nil;
    self.view.backgroundColor = [UIColor getColor:config.mBackgroundColor];
    self.mRegisterMobileButton.backgroundColor = [UIColor getColor:config.mButtonBackgroundColor];
    [self.mRegisterMobileButton setTitleColor:[UIColor getColor:config.mButtonTextColor] forState:UIControlStateNormal] ;
    //[_mHaveOTPCodeBtn setTitleColor:[UIColor config.mTextColor] forState:UIControlStateNormal] ;
    [_mHaveOTPCodeBtn setTintColor:[UIColor getColor:config.mTextColor]] ;
    // Do any additional setup after loading the view.
    self.mCountryCodeTextField.delegate =self;
    self.mCountryCodeTextField.text = mCountryCode;
    self.mCountryCodeTextField.textColor = [UIColor getColor:config.mSecondaryTextColor];
    
    //[UIManagerInstance addProgress:self.view];
    
    _mRegisterMobileHeaderLbl.text = PHONE_REGISTRATION_HEADER_TEXT;
    _mRegisterMobileDetailsLbl.text = PHONE_REGISTRATION_DISCRIPTION_TEXT;
    _mRegisterMobileInfoLbl.text = PHONE_REGISTRATION_BOTTOM_TEXT;
    
    _mRegisterMobileDetailsLbl.textColor = [UIColor getColor:config.mTextColor];
    _mRegisterMobileInfoLbl.textColor = [UIColor getColor:config.mTextColor];
    _mRegisterMobileHeaderLbl.textColor = [UIColor getColor:config.mTextColor];
    _mHiphanText.textColor = [UIColor getColor:config.mSecondaryTextColor];
    _mCountryText.textColor = [UIColor getColor:config.mSecondaryTextColor];
    _mPhoneNumberText.textColor = [UIColor getColor:config.mSecondaryTextColor];


}

-(void) viewDidAppear:(BOOL)animated {
    [_mPhoneNumberTextField becomeFirstResponder];
}


- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[countryTableViewController class]]) {
        countryTableViewController *countryTable = segue.sourceViewController;
        
        if (countryTable.callingCode) {
            NSString *plus =@"+";
            plus = [plus stringByAppendingString:countryTable.callingCode];
            self.mCountryCode = countryTable.callingCode;
            self.mCountryCodeTextField.text = plus;
            //self.countryLable.text = plus;
            
        }
    }
}



- (IBAction)verifymVerifiyPhoneNumber:(id)sender {
    [self validateAndVerify];
    
    // callback . ..  . . .
}


-(void) validateAndVerify {
    //TBD, change to phone number
    self.mPhoneNumberTextField.text = [self stripPhone:self.mPhoneNumberTextField.text];
    
    if([self.mPhoneNumberTextField.text length] < 5) {
        [UIAlertsDialogue alert:self message:@"Invalid Phone Number" title:@"Enter a valid number and try again" handler:nil];
        return;
    }
    
    self.mPhoneNumber = [mCountryCode stringByAppendingString:self.mPhoneNumberTextField.text];
    
    if(![self  isPhoneNumberValid:self.mPhoneNumber]) {
        [UIAlertsDialogue showDialogue:REGISTER_INVALID_PHONE_MSG withTitle:REGISTER_INVALID_PHONE_TITLE];
        return;
    }
    
    if([_mPhoneNumberTextField isFirstResponder])
        [_mPhoneNumberTextField resignFirstResponder];
    
    [self resignFirstResponder];
    
    [_mPhoneNumberTextField endEditing:YES];
    
    self.mLoginBlock(self, mPhoneNumber, nil, ^(BOOL result) {
        if(result) {
            [LoginUImanager launchVerificationViewController:self withPhoneNumber:self.mPhoneNumber handler:_mLoginBlock ];
            
        } else {
            [UIAlertsDialogue alert:self message:PHONE_REGISTRATION_FAIL_MESSAGE title:PHONE_REGISTRATION_FAIL_TITLE handler:nil];
        }
    });
    
    if(true) return;
    
    NSString *msg = [NSString stringWithFormat:REGISTER_MOBILE_CONFIMATION_MSG,self.mPhoneNumber];
    
    //[self alertMessage:msg withTitle:REGISTER_MOBILE_CONFIMATION_TITLE];
    [UIAlertsDialogue alert:self message:msg title:REGISTER_MOBILE_CONFIMATION_TITLE handler:^(BOOL result) {
        if(result) {
            
            if(self.mLoginBlock) {
                self.mLoginBlock(self, mPhoneNumber, nil, ^(BOOL result) {
                    if(result) {
                        [LoginUImanager launchVerificationViewController:self withPhoneNumber:self.mPhoneNumber handler:_mLoginBlock ];
                        
                    } else {
                        [UIAlertsDialogue alert:self message:PHONE_REGISTRATION_FAIL_MESSAGE title:PHONE_REGISTRATION_FAIL_TITLE handler:nil];
                    }
                });
            }
        }
    }];
    
    return;

}

- (NSString*) stripPhone : (NSString *) phoneNumber {
    return phoneNumber;
}
-(BOOL) isPhoneNumberValid :(NSString *) phoneNumber {
    // do something to verify
    return YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        mCountryCode = textField.text;
    }
    return YES;
}

- (IBAction)alreadyHaveOtp:(UIButton *)sender {
    //self.mRegisterCallbackHandler(self,@"000000000000",ACTION_HAVE_OTP);
    [LoginUImanager launchVerificationViewController:self withPhoneNumber:self.mPhoneNumber handler:_mLoginBlock ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"country_selection"]) {
        UINavigationController *nvc   = segue.destinationViewController;
        countryTableViewController  *ctc = nvc.viewControllers.firstObject;
        ctc.rateFinder = @"picker";
        
    }
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        // do here everything you want
        NSLog(@"Pressed on TextField!");
        [self.view endEditing:YES]; // Hide keyboard
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"country_selection" sender:self];
        return NO;
    }
    
    return YES;
}

@end
