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

#import "WelcomeController.h"
#import "MesiboUIHelper.h"
#import "registerMobileViewController.h"
#import "UIColors.h"
#import "LoginUImanager.h"
#import "LoginConfiguration.h"
#import "UIHelperImageUtils.h"


@interface WelcomeController ()<UITextViewDelegate>

#define CAROUSEL_SPEED  0.35f


@end

#define USE_SCROLL_TOEND    1

@implementation WelcomeController


{

UIImageView *mPictureView;
CGFloat     mScaleFactor;
CGFloat     mReverseScaleFactor;
CGRect      mClsoeFrame;
CGRect      mOpenFrame;
CGFloat     mHorizontalDisplacement;
CGRect      mPictureFrame;
UIPanGestureRecognizer *mPanGestureRecognizer;
CGFloat     mPrevHorizontalDisplacement;
CGFloat     mOffsetHorizontaldistance ;
CGPoint     mOffsetDisplacementPoint  ;
int         mLastPageInArray;

}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    //Setting colr scheme of welcome controller
    _mUiConfig = [MesiboUIHelper getUiConfig];
    
    self.view.backgroundColor = [UIColor getColor:((WelcomeBanner *)([_mUiConfig.mBanners objectAtIndex:0])).mColor];
    [_mSignupButton setTitleColor:[UIColor getColor:_mUiConfig.mTextColor] forState:UIControlStateNormal] ;
    _mSignupButton.backgroundColor = self.view.backgroundColor;
    
    
    // setup delegates for scrolling pictureview and text banner view with page indicator
    _mPictureScroll.delegate = self;
    _mBannerScroll.delegate = self;
    _mPicturePageControl.numberOfPages = [_mUiConfig.mBanners count];
    _mPicturePageControl.currentPage = 0;
    
    mPrevHorizontalDisplacement = 0 ;//initialization
    
    //set up info pane reference frame for animation when farme is in closed mode
    mClsoeFrame = _mSlidingPan.frame;
    
    //applying touch action to button for opening info pane frame
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openThePane:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_mInfoLbl addGestureRecognizer:tapGestureRecognizer];
    _mInfoLbl.userInteractionEnabled = YES;
    _mClsBtn.hidden = YES;
    
    
    // appling swiping action to view other than scroller
    mPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipingDone:)];
    [self.view addGestureRecognizer:mPanGestureRecognizer];
    
}



// The idea of this action is to add swiping other than scrolling colassal effect
- (void)swipingDone:(UIPanGestureRecognizer *)gestureRecognizer {
    mHorizontalDisplacement = [gestureRecognizer translationInView:self.view].x;
    mOffsetHorizontaldistance = mPrevHorizontalDisplacement - mHorizontalDisplacement;
    mPrevHorizontalDisplacement = mHorizontalDisplacement;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        };
        case UIGestureRecognizerStateChanged:{
            mOffsetDisplacementPoint = _mBannerScroll.contentOffset;
            mOffsetDisplacementPoint.x = _mBannerScroll.contentOffset.x+(mOffsetHorizontaldistance*_mBannerScroll.frame.size.width/self.view.frame.size.width);
            mOffsetDisplacementPoint.y = _mBannerScroll.contentOffset.y;
            
            //if scrolling goes left of first page do nothing limit scrolling
            if(mOffsetDisplacementPoint.x < 0 )
                mOffsetDisplacementPoint.x = 0;
            
            //like wise if is end page of scroller do limit scrolling..
            if(mOffsetDisplacementPoint.x > (_mBannerScroll.frame.size.width*mLastPageInArray) )
                mOffsetDisplacementPoint.x = (_mBannerScroll.frame.size.width*mLastPageInArray);
            
            [_mBannerScroll setContentOffset:mOffsetDisplacementPoint];
            // this will scrollcontent with finger moverment
            
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            
            CGFloat pageWidth = _mBannerScroll.frame.size.width;
            CGFloat x = mOffsetDisplacementPoint.x;
            CGFloat xOffset;
            
            // Mod operation do not use % mod operaton
            while (x > pageWidth) {
                x = x - pageWidth;
            }
            
            if(mHorizontalDisplacement>0)
                xOffset =-x;
            else
                xOffset = pageWidth-x;
            mOffsetDisplacementPoint.x = mOffsetDisplacementPoint.x+xOffset;
            mOffsetDisplacementPoint.y = _mBannerScroll.contentOffset.y;
            
            [UIView animateWithDuration:CAROUSEL_SPEED delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [_mBannerScroll setContentOffset:mOffsetDisplacementPoint];
            } completion:nil];
            
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

-(void) setupScrollView {
    mLastPageInArray = (int)[_mUiConfig.mBanners count];
    if(mLastPageInArray > 1) {
        mLastPageInArray -= 1;
    }

    
    int framewidth = _mPictureScroll.frame.size.width;
    int frameheight = _mPictureScroll.frame.size.height;
    int bannerWidth = _mBannerScroll.frame.size.width;
    
    int scrollpages = (int) [_mUiConfig.mBanners count];
    if(USE_SCROLL_TOEND)
        scrollpages++; // one extra scroll to end the tour
    
    _mPictureScroll.clipsToBounds = YES;
    //CGRect visibleRect = [_mPictureScroll convertRect:_mPictureScroll.bounds toView:[_mPictureScroll.delegate viewForZoomingInScrollView:_mPictureScroll]];
    
    for(int i = 0; i < [_mUiConfig.mBanners count]; i++) {
        WelcomeBanner *banner = [_mUiConfig.mBanners objectAtIndex:i];
        UIImage *image = [UIHelperImageUtils resizeAndCropToAspect:banner.mImage width:framewidth height:frameheight];
        mPictureView = [[UIImageView alloc] initWithImage:image];
        //mPictureView.contentMode = UIViewContentModeScaleAspectFill;
        //mPictureView.clipsToBounds = YES;
        //mPictureView.tag = 1;
        
        mPictureView.frame = CGRectMake(framewidth * i, 0.0, framewidth, frameheight);
        
        // for PNG transparency
        [mPictureView.layer setOpaque:NO];
        mPictureView.opaque = NO;
        
        [_mPictureScroll addSubview:mPictureView];
    }
    
    
    //last dummy view for auto ending, we are using same view as last view so that animation looks fine
    if(USE_SCROLL_TOEND)
        [_mPictureScroll addSubview:mPictureView];
    
    
    
    _mPictureScroll.contentSize = CGSizeMake(_mPictureScroll.frame.size.width*scrollpages, _mPictureScroll.frame.size.height);
    
    UILabel *label;
    for(int i = 0; i < [_mUiConfig.mBanners count]; i++) {
        WelcomeBanner *banner = [_mUiConfig.mBanners objectAtIndex:i];
        
        
        
        label = [[UILabel alloc] initWithFrame:_mBannerScroll.frame];
        label.numberOfLines = 0;
        label.text = banner.mDescription;
        label.textColor = [UIColor getColor:_mUiConfig.mBannerDescColor];
        label.font = [UIFont systemFontOfSize:15];
        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
        
        // Values are fractional -- you should take the ceilf to get equivalent values
        // we use width to calcuate number of lines
        CGSize descSize = CGSizeMake(ceilf(size.width), ceilf(size.height*ceilf(size.width/bannerWidth)));
        
        label.frame = CGRectMake(_mBannerScroll.frame.size.width * i, _mBannerScroll.frame.size.height-descSize.height, _mBannerScroll.frame.size.width, descSize.height);
        label.textAlignment = NSTextAlignmentCenter;
        [_mBannerScroll addSubview:label];

        
        label = [[UILabel alloc] initWithFrame:_mBannerScroll.frame];
        label.numberOfLines = 0;
        label.text = banner.mTitle;
        label.textColor = [UIColor getColor:_mUiConfig.mBannerTitleColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        
        size = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
        
        // Values are fractional -- you should take the ceilf to get equivalent values
        CGSize titleSize = CGSizeMake(ceilf(size.width), ceilf(size.height*ceilf(size.width/bannerWidth)));
        
        
        label.frame = CGRectMake(_mBannerScroll.frame.size.width * i, _mBannerScroll.frame.size.height-(descSize.height + titleSize.height), _mBannerScroll.frame.size.width, titleSize.height);
        
        label.textAlignment = NSTextAlignmentCenter;
        [_mBannerScroll addSubview:label];
        
    }
    
    if(USE_SCROLL_TOEND)
        [_mBannerScroll addSubview:label];
    
    _mBannerScroll.contentSize = CGSizeMake(_mBannerScroll.frame.size.width*scrollpages, _mBannerScroll.frame.size.height);
    mScaleFactor = _mPictureScroll.frame.size.width/_mBannerScroll.frame.size.width;
    mReverseScaleFactor = _mBannerScroll.frame.size.width/_mPictureScroll.frame.size.width;
    [self.view bringSubviewToFront:_mPicturePageControl];
    mClsoeFrame = _mSlidingPan.frame;
    CGFloat height = mClsoeFrame.size.height-131;
    mOpenFrame = mClsoeFrame;
    mOpenFrame.origin.y =  mOpenFrame.origin.y - height;
    mPictureFrame = _mMobileView.frame;
    CGRect frame = mPictureFrame;
    frame.origin.y = frame.origin.y + self.view.frame.size.height;
    _mMobileView.frame = frame;
    CGRect frame1 = _mSlidingPan.frame;
    frame1.origin.y=frame1.origin.y+200;
    _mSlidingPan.frame = frame1;
    //_mBannerScroll.alpha=0;
}


- (void) viewDidLayoutSubviews {
    
    
    
}


- (void) viewDidAppear:(BOOL)animated {
    
    //[self setupScrollView];
    
    [_mDoneButton setTitle:@"Next" forState:UIControlStateNormal];
    
    //self.view.frame.size.width
    //elf.view.frame.size.width
    
    UILabel* appName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] ;
    
    [self.view addSubview:appName];
    
    MesiboUiHelperConfig *config = [MesiboUIHelper getUiConfig];
    
    appName.text = config.mAppName;
    appName.textColor = [UIColor getColor:config.mBannerTitleColor];
    appName.font = [UIFont boldSystemFontOfSize:APPNAME_FONTSIZE];
    appName.textAlignment = NSTextAlignmentCenter;
    appName.alpha = 0;
    
    CGSize size = [appName.text sizeWithAttributes:@{NSFontAttributeName: appName.font}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    // we use width to calcuate number of lines
    CGSize labelsize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    appName.frame = CGRectMake((self.view.frame.size.width-labelsize.width)/2, ((self.view.frame.size.height-labelsize.height)/2)-40, labelsize.width, labelsize.height);
    

    UILabel* appTag = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 100, 100)];
    
    appTag.text = config.mAppTag;
    appTag.textColor = [UIColor getColor:config.mBannerTitleColor];
    appTag.font = [UIFont systemFontOfSize:TAGLINE_FONTSIZE];
    appTag.textAlignment = NSTextAlignmentCenter;
    appTag.alpha = 0;
    
    size = [appTag.text sizeWithAttributes:@{NSFontAttributeName: appTag.font}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    // we use width to calcuate number of lines
    CGSize descSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    
    appTag.frame = CGRectMake((self.view.frame.size.width-descSize.width)/2, appName.frame.origin.y+appName.frame.size.height , descSize.width, descSize.height);
    
    [self.view addSubview:appTag];
    
    //get current position and size
    
    //animate
    [UIView animateWithDuration:0.5 animations:^{appName.alpha = 1; } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{appTag.alpha = 1; } completion:^(BOOL finished) {
            appTag.alpha = 0;
            appName.alpha = 0;
            
            [self setupScrollView];
            //_mBannerScroll.alpha=1;
            
            [self closeThePane:nil];

        }];
    
    }];
    
}


- (IBAction)closeThePane:(id)sender {
    _mClsBtn.hidden = YES;
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //Animations
                            
                            _mSlidingPan.frame=mClsoeFrame;
                            _mMobileView.frame = mPictureFrame;
                            }completion:nil];

    
}

- (IBAction)openThePane:(id)sender {
    _mClsBtn.hidden = NO;
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //Animations
                            _mSlidingPan.frame=mOpenFrame; }completion:nil];
    
}


- (IBAction)onSkipIntro:(id)sender {
    NSLog(@"Skip");
    if(_mWelcomeHandler)
        _mWelcomeHandler(self, YES);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onDoneIntro:(id)sender {
    MesiboUiHelperConfig *config = [MesiboUIHelper getUiConfig];
    
    if(_mPicturePageControl.currentPage == ([config.mBanners count]-1)) {
        [self onSkipIntro:sender];
        return;
    }
    
    [self goToPage:_mPicturePageControl.currentPage+1];
    NSLog(@"Done");
    
}

-(void) goToPage:(int) page {
    int pageWidth = _mPictureScroll.frame.size.width;
    int offset = _mPictureScroll.contentOffset.x;
    if(offset == (pageWidth*page))
        return;
    
    CGRect frame = _mPictureScroll.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_mPictureScroll scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self closeThePane:nil];
    if([scrollView isEqual:_mPictureScroll]) {
        [self synchronizeScrollers:_mPictureScroll withCoupledScroller:_mBannerScroll withScalFactor:mReverseScaleFactor];
        [self updatePageIndicator];
    } else {
        [self synchronizeScrollers:_mBannerScroll withCoupledScroller:_mPictureScroll withScalFactor:mScaleFactor];
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self closeThePane:nil];
    CGFloat pageWidth = _mPictureScroll.frame.size.width;
    int page = floor((_mPictureScroll.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1; //this provide you the page number
    [self goToPage:page];
}

- (void) updatePageIndicator {
    CGFloat pageWidth = _mPictureScroll.frame.size.width;
    int page = floor((_mPictureScroll.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1; //this provide you the page number
    if(_mPicturePageControl.currentPage != page) {
        if(page >= [_mUiConfig.mBanners count]) {
            [self onSkipIntro:nil];
            return;
        }
        
        WelcomeBanner *banner = [_mUiConfig.mBanners objectAtIndex:page];
        
        __block uint32_t color = banner.mColor;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.backgroundColor = [UIColor getColor:color];
            _mSignupButton.backgroundColor = self.view.backgroundColor;
        }];

        _mPicturePageControl.currentPage = page; // this displays the white dot as current page*/
        
        if(page == ([_mUiConfig.mBanners count]-1)) {
            [_mDoneButton setTitle:@"Done" forState:UIControlStateNormal];
        } else
            [_mDoneButton setTitle:@"Next" forState:UIControlStateNormal];
    }
    
    
    
}

- (void) synchronizeScrollers : (UIScrollView *) scrollView withCoupledScroller: (UIScrollView *) coupledScrollView withScalFactor: (CGFloat) scaleFactor {
    CGPoint offset = scrollView.contentOffset;
    int x = roundf ((offset.x) * (scaleFactor));
    offset.x = x;
    offset.y = coupledScrollView.contentOffset.y;
    [coupledScrollView setContentOffset:offset ];
}

- (IBAction)doSignInProcess:(id)sender {
    //[LoginUImanager launchRegisterViewController:self withDelegate:_mDelegate];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
