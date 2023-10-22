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

//
//  GMGridViewCell.h
//  GMPhotoPicker
//
//  Created by Guillermo Muntaner Perelló on 19/09/14.
//  Copyright (c) 2014 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface GMGridViewCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;
//The imageView
@property (nonatomic, strong) UIImageView *imageView;
//Video additional information
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UILabel *videoDuration;
@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) CAGradientLayer *gradient;
//Selection overlay
@property (nonatomic) BOOL shouldShowSelection;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

- (void)bind:(PHAsset *)asset;

@end
