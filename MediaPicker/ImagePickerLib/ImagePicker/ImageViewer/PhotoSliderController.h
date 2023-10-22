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

@interface PhotoSliderController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mViewerBackBtn;

@property (weak, nonatomic) IBOutlet UIButton *_mViwerFrontBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *_mViwerScrollVu;
@property (assign, nonatomic) BOOL mControllerPushed;
@property (strong, nonatomic) UIImage * mImageShow;
@property (strong, nonatomic) NSArray * mSliderImageArray;
@property (assign, nonatomic) NSUInteger mViwerZoomIndex;
@property (strong, nonatomic) NSString* mTitle;

@property (weak, nonatomic) IBOutlet UIView *mTopLayer;

@end

