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

#import "AddCaptionViewController.h"
#import "ImagePicker.h"
#import "ImagePickerUtils.h"
#import "PECropViewController.h"


@interface AddCaptionViewController () <PECropViewControllerDelegate>

@end

@implementation AddCaptionViewController 

{
CGFloat mMinimumTextViewHeight;
CGFloat mMaximumTextViewHeight;
CGFloat mOriginalParentHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mMinimumTextViewHeight=39;
    mMaximumTextViewHeight=100;
    mOriginalParentHeight = _mCaptionViewHeight.constant;
    
    _mCaptionImageView.hidden = NO;
    
    _mCaptionImageView.image = _mImageCaption;
    _mCaptionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title=@"Add Caption";
    if(nil != _mTitle){
        self.title = _mTitle;
    }

    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[ImagePickerUtils imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    
    if(!_mHideEditControl) {
    
    UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[ImagePickerUtils imageNamed:@"ic_rotate_right_white.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(rotateImage)forControlEvents:UIControlEventTouchUpInside];
    [button1 setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[ImagePickerUtils imageNamed:@"ic_crop_white.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(cropImage)forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *barButton2 = [[UIBarButtonItem alloc] initWithCustomView:button2];

    self.navigationItem.rightBarButtonItems = @[barButton1,barButton2];
    }

    _mCaptionEdit.delegate = self;
    
    _mCaptionEdit.layer.borderWidth = 0.5;
    _mCaptionEdit.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mCaptionEdit.layer.cornerRadius = 4.0;

    _mCaptionEdit.delegate = self;
    _mCaptionEdit.text = @"Add your caption . . .";
    _mCaptionEdit.textColor = [UIColor lightGrayColor]; //optional
    
    if(!_mShowCaption) {
        [_mCaptionEdit setHidden:YES];
        //[_mCaptionBtn setHidden:YES];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle =UIBarStyleBlackTranslucent;
    
    if(_mShowCropOverlay)
        [self cropImage];
    
}

- (IBAction)barButtonBackPressed:(id)sender {
    
    [self dismissKeyboard];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cropImage {
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    UIImage *sampleImage = _mCaptionImageView.image;
    controller.image = sampleImage;
    
    NSLog(@"Orig Image size is: %d %d", (int)sampleImage.size.width, (int)sampleImage.size.height );
    
    //UIImage *image = newImage;
    CGFloat width = sampleImage.size.width;
    CGFloat height = sampleImage.size.height;
    CGFloat length = MIN(width, height);
    
    if(_mSquareCrop ) {
        controller.keepingCropAspectRatio = YES;
        controller.imageCropRect = CGRectMake((width - length) / 2,
                                              (height - length) / 2,
                                              length,
                                              length);
    } else {
        float border=0.1; // 10%
        float sidemultipler = 1-2*border;
        controller.imageCropRect = CGRectMake(width*border,
                                              height*border,
                                              width*sidemultipler,
                                              height*sidemultipler);
    }
    
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
     
     
     [self presentViewController:navigationController animated:YES completion:nil];
    
    
}

- (void) rotateImage {
    
    UIImage *sampleImage = _mCaptionImageView.image;
    _mCaptionImageView.image = [self imageRotatedByDegrees:sampleImage deg:90];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}



- (BOOL)dismissKeyboard
{
    if([_mCaptionEdit isFirstResponder])
        [_mCaptionEdit resignFirstResponder];
    
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    // [_mChatEdit removeConstraints:_mChatEdit.constraints];
    
        CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    
    
    _mCaptionViewShift.constant = keyboardFrameConverted.size.height;
    
    
    //[self updateViewConstraints];
    [self.view invalidateIntrinsicContentSize];
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //[self scrollToLatestChat:YES];
        
        
    }];
    
    
}



-(void)keyboardWillHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _mCaptionViewShift.constant = 0;
        
        [self.view layoutIfNeeded];
        
    }];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add your caption . . ."]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add your caption . . .";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}



- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat height = height = ceil(textView.contentSize.height)+2;
    
    if (height < mMinimumTextViewHeight ) { // min cap, + 5 to avoid tiny height difference at min height
        height = mMinimumTextViewHeight;
    }
    if (height > mMaximumTextViewHeight) { // max cap
        height = mMaximumTextViewHeight;
    }
    
    height = height - mMinimumTextViewHeight;
    
    if(height) {
        if(_mCaptionViewHeight.constant != mOriginalParentHeight + height ) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _mCaptionViewHeight.constant = mOriginalParentHeight + height ;
        
        [UIView commitAnimations];
        }
    } else
        _mCaptionViewHeight.constant = mOriginalParentHeight ;
   
    }

-(UIImage *)imageResize :(UIImage*)img maxSide:(int)maxSide square:(BOOL)square {

    int width = (int) _mCaptionImageView.image.size.width;
    int height = (int)_mCaptionImageView.image.size.height;
    
    if(height <= maxSide && width <= maxSide ) {
            if(!square || (square && (width == height)))
                return img;
    }
    
    if(square) {
        width = maxSide;
        height = maxSide;
    } else {
        int maxlen = height;
        if(width > maxlen)
            maxlen = width;

        float multipler = ((float)maxSide)/(float)maxlen;
        width = (int) (width*multipler);
        height = (int) (height*multipler);

    }

    
    CGSize newSize;
    newSize.width = width;
    newSize.height = height;
    
    //CGFloat scale = [[UIScreen mainScreen]scale]; //Audrey, don't use this else decompressed image will be of same size
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    UIGraphicsBeginImageContext(newSize); //Audrey
    //UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) invokeListener {
    if(nil == _mHandlerBlock)
        return;
    
    if(_mMaxDimension > 0) {
        _mCaptionImageView.image = [self imageResize:_mCaptionImageView.image maxSide:_mMaxDimension square:_mSquareCrop];
    }
    
    NSLog(@"Image size is: %d %d", (int)_mCaptionImageView.image.size.width, (int)_mCaptionImageView.image.size.height );
    
    NSString * text =_mCaptionEdit.text;
    if ([_mCaptionEdit.text isEqualToString:@"Add your caption . . ."]) {
        text = NULL;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        _mHandlerBlock(_mCaptionImageView.image , text);
    }];
}

- (IBAction)sendMessagePicture:(id)sender {
    
    [self dismissKeyboard];
        
    [self invokeListener];

}

#pragma mark - rotate images



- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    _mCaptionImageView.image = croppedImage;
    if(_mShowCropOverlay) {
        [self invokeListener];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if(_mShowCropOverlay) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


@end
