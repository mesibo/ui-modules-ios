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
