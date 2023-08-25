/** Copyright (c) 2023 Mesibo, Inc
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

#import "ThumbnailProgressView.h"

@interface ThumbnailProgressView()
@property (nonatomic, strong) CAShapeLayer *progressBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *iconLayer;

@property (nonatomic, assign) BOOL isSpinning;



@property (nonatomic, assign) BOOL isAnimatingProgressBackgroundLayerFillColor;
@end

@implementation ThumbnailProgressView

#define kArrowSizeRatio .12
#define kStopSizeRatio  .3
#define kTickWidthRatio .3

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setIconView:(UIView *)iconView
{
    if (_iconView)
    {
        [_iconView removeFromSuperview];
    }
    
    _iconView = iconView;
    [self addSubview:_iconView];
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _lineWidth = fmaxf(self.frame.size.width * 0.025, 1.f);
    _progressColor = [UIColor whiteColor]; //[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    _tickColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    
    self.progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.contentsScale = [[UIScreen mainScreen] scale];
    _progressBackgroundLayer.strokeColor = _progressColor.CGColor;
    _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
    _progressBackgroundLayer.lineCap = kCALineCapRound;
    _progressBackgroundLayer.lineWidth = _lineWidth;
    _progressBackgroundLayer.cornerRadius = _progressBackgroundLayer.frame.size.height/2;
    _progressBackgroundLayer.masksToBounds = YES;
    [self.layer addSublayer:_progressBackgroundLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    _progressLayer.contentsScale = [[UIScreen mainScreen] scale];
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.fillColor = nil;
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = _lineWidth * 2.0;
    [self.layer addSublayer:_progressLayer];
    
    self.iconLayer = [CAShapeLayer layer];
    _iconLayer.contentsScale = [[UIScreen mainScreen] scale];
    _iconLayer.strokeColor = _progressColor.CGColor;
    _iconLayer.fillColor = nil;
    _iconLayer.lineCap = kCALineCapButt;
    _iconLayer.lineWidth = _lineWidth;
    _iconLayer.fillRule = kCAFillRuleNonZero;
    [self.layer addSublayer:_iconLayer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setProgressColor:(UIColor *)tintColor
{
    _progressColor = tintColor;
    _progressBackgroundLayer.strokeColor = tintColor.CGColor;
    _progressLayer.strokeColor = tintColor.CGColor;
    _iconLayer.strokeColor = tintColor.CGColor;
    
    if (self.progress == 1.) {
        _progressBackgroundLayer.fillColor = tintColor.CGColor;
    }
}

- (void)setTickColor:(UIColor *)tickColor
{
    _tickColor = tickColor;
}

- (void)drawRect:(CGRect)rect
{
    // Make sure the layers cover the whole view
    _progressBackgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    _iconLayer.frame = self.bounds;

    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;

    // Draw background
    [self drawBackgroundCircle:_isSpinning];

    // Draw progress
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    // CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapButt;
    processPath.lineWidth = _lineWidth;

    radius = (self.bounds.size.width - _lineWidth*3) / 2.0;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [_progressLayer setPath:processPath.CGPath];

    switch (_circularState) {
        case FFCircularStateStop:
             [self drawStop];
            break;
            
        case FFCircularStateStopSpinning:
             [self drawStop];
            break;
            
        case FFCircularStateStopProgress:
             [self drawStop];
            break;
            
        case FFCircularStateCompleted:
             [self drawTick];
            break;
            
        case FFCircularStateFailed:
            [self drawFail];
            break;
            
        case FFCircularStateIcon:
            if (!self.iconView && !self.iconPath){
                [self drawArrow];
            }
            else if (self.iconPath){
                _iconLayer.path = self.iconPath.CGPath;
                _iconLayer.fillColor = nil;
            }
            break;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Setters

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = fmaxf(lineWidth, 1.f);
    
    _progressBackgroundLayer.lineWidth = _lineWidth;
    _progressLayer.lineWidth = _lineWidth * 2.0;
    _iconLayer.lineWidth = _lineWidth;
}

#pragma mark -
#pragma mark Drawing

- (void) drawBackgroundCircle:(BOOL) partial {
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    // Draw background
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    
    // Recompute the end angle to make it at 90% of the progress
    if (partial) {
        endAngle = (1.8F * (float)M_PI) + startAngle;
    }

    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];

    _progressBackgroundLayer.path = processBackgroundPath.CGPath;
}

- (void) drawTick {
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height)/2;
    
    /*
     First draw a tick that looks like this:
     
     A---F
     |   |
     |   E-------D
     |           |
     B-----------C
     
     (Remember: (0,0) is top left)
     */
    UIBezierPath *tickPath = [UIBezierPath bezierPath];
    CGFloat tickWidth = radius * kTickWidthRatio;
    [tickPath moveToPoint:CGPointMake(0, 0)];                            // A
    [tickPath addLineToPoint:CGPointMake(0, tickWidth * 2)];             // B
    [tickPath addLineToPoint:CGPointMake(tickWidth * 3, tickWidth * 2)]; // C
    [tickPath addLineToPoint:CGPointMake(tickWidth * 3, tickWidth)];     // D
    [tickPath addLineToPoint:CGPointMake(tickWidth, tickWidth)];         // E
    [tickPath addLineToPoint:CGPointMake(tickWidth, 0)];                 // F
    [tickPath closePath];
    
    // Now rotate it through -45 degrees...
    [tickPath applyTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    
    // ...and move it into the right place.
    [tickPath applyTransform:CGAffineTransformMakeTranslation(radius * .46, 1.02 * radius)];
    
    [_iconLayer setPath:tickPath.CGPath];
    [_iconLayer setFillColor:self.tickColor.CGColor];
    [_progressBackgroundLayer setFillColor:_progressLayer.strokeColor];
}

- (void) drawStop {
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kStopSizeRatio;
    CGFloat sideSize = self.bounds.size.width * ratio;
    
    UIBezierPath *stopPath = [UIBezierPath bezierPath];
    [stopPath moveToPoint:CGPointMake(0, 0)];
    [stopPath addLineToPoint:CGPointMake(sideSize, 0.0)];
    [stopPath addLineToPoint:CGPointMake(sideSize, sideSize)];
    [stopPath addLineToPoint:CGPointMake(0.0, sideSize)];
    [stopPath closePath];
    
    // ...and move it into the right place.
    [stopPath applyTransform:CGAffineTransformMakeTranslation(radius * (1-ratio), radius* (1-ratio))];
    
    [_iconLayer setPath:stopPath.CGPath];
    [_iconLayer setStrokeColor:_progressLayer.strokeColor];
    [_iconLayer setFillColor:self.progressColor.CGColor];
}

- (void) drawFail {
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kStopSizeRatio;
    CGFloat sideSize = self.bounds.size.width * ratio;
    
    UIBezierPath *stopPath = [UIBezierPath bezierPath];
    [stopPath moveToPoint:CGPointMake(0, 0)];
    [stopPath addLineToPoint:CGPointMake(sideSize, sideSize)];
    [stopPath moveToPoint:CGPointMake(0, sideSize)];
    [stopPath addLineToPoint:CGPointMake(sideSize, 0)];
    [stopPath closePath];
    
    // ...and move it into the right place.
    [stopPath applyTransform:CGAffineTransformMakeTranslation(radius * (1-ratio), radius* (1-ratio))];
    
    [_iconLayer setPath:stopPath.CGPath];
    [_iconLayer setStrokeColor:_progressLayer.strokeColor];
    [_iconLayer setFillColor:self.progressColor.CGColor];
}

- (void) drawArrow {
    if(_mArrowDirectionUp)
        _iconLayer.path = [self upArrowPath].CGPath;
    else
        _iconLayer.path = [self downArrowPath].CGPath;

    _iconLayer.fillColor = nil;
}

- (UIBezierPath *)downArrowPath{
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kArrowSizeRatio;
    CGFloat segmentSize = self.bounds.size.width * ratio;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize * 3.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize, segmentSize * 3.3)];
    [path addLineToPoint:CGPointMake(-segmentSize, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, 0.0)];
    [path closePath];
    
    [path applyTransform:CGAffineTransformMakeTranslation(-segmentSize /2.0, -segmentSize / 1.2)];
    [path applyTransform:CGAffineTransformMakeTranslation(radius * (1-ratio), radius* (1-ratio))];
    return path;
}

- (UIBezierPath *)upArrowPath{
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kArrowSizeRatio;
    CGFloat segmentSize = self.bounds.size.width * ratio;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize * 3.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize, segmentSize * 3.3)];
    [path addLineToPoint:CGPointMake(-segmentSize, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, 0.0)];
    [path closePath];
    

    [path applyTransform:CGAffineTransformMakeRotation(M_PI)];
    [path applyTransform:CGAffineTransformMakeTranslation(radius * 1.0, 1.0 * radius)];
    [path applyTransform:CGAffineTransformMakeTranslation(segmentSize, segmentSize *1.3)];
   
    return path;
 
}

#pragma mark Setters

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0) progress = 1.0;
    
    if (_progress != progress) {
        _progress = progress;
        
        if (_progress == 1.0) {
            [self animateProgressBackgroundLayerFillColor];
        }
        
        if (_progress == 0.0) {
            _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setCircularState:(FFCircularState)state{
    
    if (_circularState != state) {
        
        _circularState = state;

        switch (_circularState) {
            case FFCircularStateStop:
                [self setProgress:0];
                if(self.isSpinning){
                    [self stopSpinProgressBackgroundLayer];
                }
                if(self.isAnimatingProgressBackgroundLayerFillColor){
                    [self stopAnimatingProgressBackgroundLayerFillColor];
                }
                break;
                
            case FFCircularStateStopSpinning:
                [self setProgress:0];
                if(self.isSpinning==NO){
                    [self startSpinProgressBackgroundLayer];
                }
                if(self.isAnimatingProgressBackgroundLayerFillColor){
                    [self stopAnimatingProgressBackgroundLayerFillColor];
                }
                break;
                
            case FFCircularStateStopProgress:
                if(self.isSpinning){
                    [self stopSpinProgressBackgroundLayer];
                }
                if(self.isAnimatingProgressBackgroundLayerFillColor){
                    [self stopAnimatingProgressBackgroundLayerFillColor];
                }
                break;
                
            case FFCircularStateCompleted:
                [self setProgress:1.0];
                if(self.isSpinning){
                    [self stopSpinProgressBackgroundLayer];
                }
                break;
                
            case FFCircularStateFailed:
                [self setProgress:0];
                if(self.isSpinning){
                    [self stopSpinProgressBackgroundLayer];
                }
                break;
                
            case FFCircularStateIcon:
                [self setProgress:0];
                if(self.isSpinning){
                    [self stopSpinProgressBackgroundLayer];
                }
                if(self.isAnimatingProgressBackgroundLayerFillColor){
                    [self stopAnimatingProgressBackgroundLayerFillColor];
                }
                break;
                
            default:
                break;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)tintColorDidChange{
    if(self.tintColor){
        [self setProgressColor:self.tintColor];
    }
    else{
        [self setProgressColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0]];
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        self.alpha = .5;
    }
    else{
        self.alpha = 1.0;
    }
}

#pragma mark Animations

- (void)animateProgressBackgroundLayerFillColor {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    colorAnimation.duration = .5;
    colorAnimation.repeatCount = 1.0;
    colorAnimation.removedOnCompletion = NO;
    
    colorAnimation.fromValue = (__bridge id) _progressBackgroundLayer.backgroundColor;
    colorAnimation.toValue = (__bridge id) _progressLayer.strokeColor;
    
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [_progressBackgroundLayer addAnimation:colorAnimation forKey:@"colorAnimation"];
    
    self.isAnimatingProgressBackgroundLayerFillColor = YES;
}

- (void)stopAnimatingProgressBackgroundLayerFillColor{
    [_progressBackgroundLayer removeAnimationForKey:@"colorAnimation"];
    _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
    self.isAnimatingProgressBackgroundLayerFillColor = NO;
}

- (void)startSpinProgressBackgroundLayer {
    self.isSpinning = YES;
    [self drawBackgroundCircle:YES];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_progressBackgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void) stopSpinProgressBackgroundLayer {
    [self drawBackgroundCircle:NO];
    [_progressBackgroundLayer removeAllAnimations];
    self.isSpinning = NO;
}

- (void)restartAnimation{
    BOOL shouldStart = self.isSpinning;
    self.isSpinning = YES;
    [self stopSpinProgressBackgroundLayer];
    if(shouldStart){
        [self startSpinProgressBackgroundLayer];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self restartAnimation];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self restartAnimation];
}

#pragma mark - Notification

- (void)applicationWillEnterForeground:(NSNotification*)notification{
    [self restartAnimation];
}

-(void) config:(UIColor *)bgcolor progressColor:(UIColor *)progressColor tickColor:(UIColor *)tickColor lineWidth:(CGFloat)lineWidth arrowUp:(BOOL) arrowUp {
    
    _mArrowDirectionUp = arrowUp;
    if(lineWidth > 1.0f) {
        [self setLineWidth:lineWidth];
    }
    
    if(progressColor) {
        if(!tickColor)
            tickColor = progressColor;
        [self setProgressColor:progressColor];
    }
    
    if(tickColor)
        [self setTickColor:tickColor];
    
    if(bgcolor)
        self.backgroundColor = bgcolor;
    
}

@end
