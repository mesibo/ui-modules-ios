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
#import "ImagePicker.h"



@interface AddCaptionViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) MesiboImageEditorBlock  mHandlerBlock;



@property (weak, nonatomic) IBOutlet UITextView *mCaptionEdit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mCaptionViewHeight;

@property (weak, nonatomic) IBOutlet UIView *mCaptionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mCaptionEditHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mCaptionViewShift;

@property (strong,nonatomic) UIImage *mImageCaption;

@property (assign,nonatomic) BOOL mShowCaption;
@property (assign,nonatomic) BOOL mShowCropOverlay;
@property (assign,nonatomic) BOOL mSquareCrop;
@property (assign,nonatomic) int mMaxDimension;

@property (weak, nonatomic) IBOutlet UIImageView *mCaptionImageView;

@property (weak, nonatomic) IBOutlet UIButton *mCaptionBtn;

@property (assign,nonatomic)BOOL mHideEditControl;

@property (strong, nonatomic) NSString *mTitle;

@end
