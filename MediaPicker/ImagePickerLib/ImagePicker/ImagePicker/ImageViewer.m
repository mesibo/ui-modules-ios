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
#import "ImageViewer.h"
#import "UIColors.h"
#import "ImagePicker.h"
#import "ImagePickerUtils.h"


@interface ImageViewer ()


@end

@implementation ImageViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if([ImagePickerUtils isUrl:_mFBUrl]) {
    NSURL *url = [NSURL URLWithString:_mFBUrl];
    _mImageView.image= [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    } else {
        _mImageView.image= [UIImage imageWithContentsOfFile:_mFBUrl];
    }
    //_mImageView.contentMode = UIViewContentModeScaleAspectFit;
   // _mImageView.contentMode = UIViewContentModeScaleToFill;
    _mImageView.layer.borderColor = [UIColor getColor:PICTURE_BORDER_LINE].CGColor;
    _mImageView.layer.borderWidth = 2.0;
    _mImageView.clipsToBounds = YES;
    
        
    [_mDoneBtn  setTitleColor:[UIColor getColor:DONE_CANCEL_COLOR] forState:UIControlStateNormal];
    [_mCancelBtn  setTitleColor:[UIColor getColor:DONE_CANCEL_COLOR] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelImage:(id)sender {
    
   [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)ImageSelected:(id)sender {
    
    
    ImagePicker *im = [ImagePicker sharedInstance];
    
    [_mClosModalController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        [im callBackFromFacebook:_mImageView.image];
    }];
    
}


@end
