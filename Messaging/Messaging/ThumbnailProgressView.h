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
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


typedef NS_ENUM (NSInteger, FFCircularState){
    FFCircularStateStop = 0,
    FFCircularStateStopSpinning,
    FFCircularStateStopProgress,
    FFCircularStateCompleted,
    FFCircularStateFailed,
    FFCircularStateIcon,
};

@interface ThumbnailProgressView : UIControl

/**
 * The progress of the view.
 **/
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL mArrowDirectionUp;
/**
 * The width of the line used to draw the progress view.
 **/
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * The color of the progress view
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 * The color of the tick view
 */
@property (nonatomic, strong) UIColor *tickColor;

/**
 * Icon view to be rendered instead of default arrow
 */
@property (nonatomic, strong) UIView* iconView;

/**
 * Bezier path to be rendered instead of icon view or default arrow
 */
@property (nonatomic, strong) UIBezierPath* iconPath;

/**
 * Indicates if the component is spinning
 */
@property (nonatomic, readonly) BOOL isSpinning;

@property (nonatomic, assign) FFCircularState circularState;


- (UIBezierPath *)downArrowPath;

- (UIBezierPath *)upArrowPath;

/**
 * Make the background layer to spin around its center. This should be called in the main thread.
 */
- (void) startSpinProgressBackgroundLayer;

/**
 * Stop the spinning of the background layer. This should be called in the main thread.
 * WARN: This implementation remove all animations from background layer.
 **/
- (void) stopSpinProgressBackgroundLayer;

-(void) config:(UIColor *)bgcolor progressColor:(UIColor *)progressColor tickColor:(UIColor *)tickColor lineWidth:(CGFloat)lineWidth arrowUp:(BOOL) arrowUp;

@end
