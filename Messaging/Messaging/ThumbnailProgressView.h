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
