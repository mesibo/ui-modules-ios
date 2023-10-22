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
//  TODocumentPickerConfiguration.m
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TODocumentPickerConfiguration.h"
#import "UIImage+TODocumentPickerIcons.h"


@implementation TODocumentPickerConfiguration

- (instancetype)init
{
    if (self = [super init]) {
        _showToolbar = YES;
    }

    return self;
}

- (UIImage *)defaultIcon
{
    if (_defaultIcon == nil) {
        _defaultIcon = [self TO_documentPickerDefaultIcon];
    }

    return _defaultIcon;
}

- (UIImage *)folderIcon
{
    if (_folderIcon == nil) {
        _folderIcon = [self TO_documentPickerFolderIcon];
    }

    return _folderIcon;
}

- (UIImage *)TO_documentPickerFolderIcon
{
    UIImage *folderIcon = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){33,27}, NO, 0.0f);
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
        [rectanglePath moveToPoint: CGPointMake(0.5, 23.61)];
        [rectanglePath addCurveToPoint: CGPointMake(3.41, 26.5) controlPoint1: CGPointMake(0.5, 25.21) controlPoint2: CGPointMake(1.8, 26.5)];
        [rectanglePath addLineToPoint: CGPointMake(29.59, 26.5)];
        [rectanglePath addCurveToPoint: CGPointMake(32.5, 23.61) controlPoint1: CGPointMake(31.2, 26.5) controlPoint2: CGPointMake(32.5, 25.21)];
        [rectanglePath addLineToPoint: CGPointMake(32.5, 6.39)];
        [rectanglePath addCurveToPoint: CGPointMake(29.59, 3.5) controlPoint1: CGPointMake(32.5, 4.79) controlPoint2: CGPointMake(31.2, 3.5)];
        [rectanglePath addCurveToPoint: CGPointMake(15.5, 3.5) controlPoint1: CGPointMake(29.59, 3.5) controlPoint2: CGPointMake(17.5, 3.5)];
        [rectanglePath addCurveToPoint: CGPointMake(10.5, 0.5) controlPoint1: CGPointMake(13.5, 3.5) controlPoint2: CGPointMake(12.5, 0.5)];
        [rectanglePath addCurveToPoint: CGPointMake(3.41, 0.5) controlPoint1: CGPointMake(8.5, 0.5) controlPoint2: CGPointMake(3.41, 0.5)];
        [rectanglePath addCurveToPoint: CGPointMake(0.5, 3.39) controlPoint1: CGPointMake(1.8, 0.5) controlPoint2: CGPointMake(0.5, 1.79)];
        [rectanglePath addLineToPoint: CGPointMake(0.5, 23.61)];
        [rectanglePath closePath];
        [UIColor.blackColor setStroke];
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];
        
        
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = UIBezierPath.bezierPath;
        [rectangle2Path moveToPoint: CGPointMake(32.5, 10.5)];
        [rectangle2Path addCurveToPoint: CGPointMake(29.5, 7.5) controlPoint1: CGPointMake(32.5, 8.84) controlPoint2: CGPointMake(31.16, 7.5)];
        [rectangle2Path addLineToPoint: CGPointMake(3.5, 7.5)];
        [rectangle2Path addCurveToPoint: CGPointMake(0.5, 10.5) controlPoint1: CGPointMake(1.84, 7.5) controlPoint2: CGPointMake(0.5, 8.84)];
        [UIColor.blackColor setStroke];
        rectangle2Path.lineWidth = 1;
        [rectangle2Path stroke];
        
        folderIcon = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return folderIcon;
}

- (UIImage *)TO_documentPickerDefaultIcon
{
    UIImage *documentIcon = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){33,37}, NO, 0.0f);
    {
        //// Group
        {
            //// Page Drawing
            UIBezierPath* pagePath = UIBezierPath.bezierPath;
            [pagePath moveToPoint: CGPointMake(5.5, 33.5)];
            [pagePath addLineToPoint: CGPointMake(28.5, 33.5)];
            [pagePath addLineToPoint: CGPointMake(28.5, 11.41)];
            [pagePath addLineToPoint: CGPointMake(19.3, 2.5)];
            [pagePath addLineToPoint: CGPointMake(5.5, 2.5)];
            [pagePath addLineToPoint: CGPointMake(5.5, 33.5)];
            [pagePath closePath];
            [UIColor.blackColor setStroke];
            pagePath.lineWidth = 1;
            [pagePath stroke];
            
            
            //// Fold Drawing
            UIBezierPath* foldPath = UIBezierPath.bezierPath;
            [foldPath moveToPoint: CGPointMake(19.5, 2.5)];
            [foldPath addLineToPoint: CGPointMake(19.5, 11.5)];
            [foldPath addLineToPoint: CGPointMake(28.5, 11.5)];
            [UIColor.blackColor setStroke];
            foldPath.lineWidth = 1;
            [foldPath stroke];
        }
        
        
        documentIcon = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return documentIcon;
}


@end
