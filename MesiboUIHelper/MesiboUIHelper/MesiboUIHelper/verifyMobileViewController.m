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
