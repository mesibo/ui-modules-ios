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

#import "Defines.h"

#import "ImagePicker.h"
//#import "ImageViewer.h"
#import "../PEPhotoCropEditor/PECropViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreLocation/CoreLocation.h>
#import <AVKit/AVKit.h>

#import "addCaptionViewController.h"
#import "GMImagePickerController.h"
#import "TODocumentPickerViewController.h"
#import "TODocumentsDataSource.h"
#import "ImagePickerUtils.h"
#import "UIColors.h"
#import "AddCaptionViewController.h"
#import "FacebookLogin.h"
#import "PhotoSliderController.h"
#import "UIAlerts.h"
#import "AlbumTableController.h"

#define PHASSET_VIDEO 2

#include <GooglePlaces/GooglePlaces.h>
#include <GooglePlacePicker/GooglePlacePicker.h>

@implementation AlbumsData : NSObject
@end

@implementation PhotoData : NSObject
@end


@implementation ImagePickerFile
- (id)init
{
    self = [super init];
    if (self)
    {
        _filePath = nil;
        _mp4state = 0;
        _mp4Path = nil;
        _mp4TranscodingHandler = nil;
        _image = nil;
        _message = nil;
        _title = nil;
        _url = nil;
        _phasset = nil;
    }
    return self;
}

-(void) setMp4TranscodingHandler:(void (^)(ImagePickerFile *))handler {
    @synchronized (self) {
        _mp4TranscodingHandler = handler;
        if(_mp4state == 2)
            _mp4TranscodingHandler(self);
    }
}

-(void) setMp4Ready:(BOOL)ready {
    @synchronized (self) {
        _mp4state = ready?2:0;
        if(_mp4TranscodingHandler)
            _mp4TranscodingHandler(self);
    }
}
@end


@interface ImagePicker (NSObject) <GMImagePickerControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,PECropViewControllerDelegate, CLLocationManagerDelegate, MPMediaPickerControllerDelegate, TODocumentPickerViewControllerDelegate >
@end


@implementation ImagePicker

{
    
    CLLocationManager *mLocationManager;
    GMSPlacePicker *mPlacePicker;
    //GMSPlacePicker
    GMSPlacesClient *mPlacesClient;
    
}



+ (ImagePicker *)sharedInstance {
    
    static ImagePicker *myInstance = nil;
    if(nil == myInstance) {
        @synchronized(self) {
            if (nil == myInstance) {
                myInstance = [[self alloc] init];
            }
        }
    }
    return myInstance;
}


-(void)pickMedia:(int) filetype :(void(^)(ImagePickerFile *file))handler {
    
    _completionHandler = [handler copy];
    
    ImagePickerFile *mf = [ImagePickerFile new];
    mf.title = nil;
    mf.image = nil;
    mf.message = nil;
    mf.filePath = nil;
    
    switch (filetype) {
            
        case PICK_CAMERA_IMAGE:
            [self fromCamera];
            mf.fileType = PICK_CAMERA_IMAGE;
            break;
            
        case PICK_FACEBOOK_IMAGES:
            [self handleFacebook];
            mf.fileType = PICK_FACEBOOK_IMAGES;
            break;
        case PICK_IMAGE_GALLERY:
            mf.fileType = PICK_IMAGE_GALLERY;
            [self fromMyPhone];
            break;
        case PICK_VIDEO_GALLERY:
            mf.fileType = PICK_VIDEO_GALLERY;
            [self fromVideoGallery];
            break;
        case PICK_VIDEO_RECORDING:
            mf.fileType = PICK_VIDEO_RECORDING;
            [self captureVideo ];
            break;
        case PICK_AUDIO_FILES:
            mf.fileType = PICK_AUDIO_FILES;
            [self getAudioTracks];
            break;
        case PICK_LOCATION:
            mf.fileType = PICK_LOCATION;
            [self getCurentLocation];
            break;
        case PICK_DOCUMENTS:
            mf.fileType = PICK_DOCUMENTS;
            [self getDocumentFile];
            break;
            
            
        default:
            return;
    }
    
    
    
}

- (void) getDocumentFile {
    
    TODocumentPickerViewController *documentPicker = [[TODocumentPickerViewController alloc] initWithFilePath:nil];
    documentPicker.dataSource = [[TODocumentsDataSource alloc] init];
    documentPicker.documentPickerDelegate = self;
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:documentPicker];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [_mParent presentViewController:controller animated:YES completion:nil];
    
    
}

- (void)documentPickerViewController:(TODocumentPickerViewController *)documentPicker didSelectItems:(nonnull NSArray<TODocumentPickerItem *> *)items inFilePath:(NSString *)filePath
{
    
    [_mParent dismissViewControllerAnimated:YES completion:nil];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    TODocumentPickerItem *item  = [items objectAtIndex:0];
    NSString *absoluteFilePath = [filePath stringByAppendingPathComponent:item.fileName];
    NSString *filezPath = [NSString stringWithFormat:@"%@%@",documentsDirectory,absoluteFilePath];
    
    
    ImagePickerFile *mf = [ImagePickerFile new];
    mf.title = item.fileName;
    //mf.title = NULL;
    NSString *ext = [filezPath pathExtension];
    UIImage *newImage= [ImagePickerUtils getDefaultImageForExt:ext];
    mf.image = newImage;
    mf.filePath = filezPath;
    mf.fileType = PICK_DOCUMENTS;
    NSLog(@"Paths for items selected: %@", filezPath);
    _completionHandler(mf);
}

- (void) getCurentLocation {
    
    mPlacesClient = [GMSPlacesClient sharedClient];
    
    mLocationManager = [[CLLocationManager alloc] init];
    mLocationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([mLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [mLocationManager requestAlwaysAuthorization];
    }
    
    mLocationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    [mLocationManager startUpdatingLocation];
    
    
}


- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        
        [UIAlerts showDialogue:message withTitle:title];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [mLocationManager requestAlwaysAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location updates failed with %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [mLocationManager stopUpdatingLocation];
    mLocationManager = nil;
    
    CLLocation *newLocation = locations.lastObject;
    NSLog(@"%@", newLocation.description);
    
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    
    mPlacePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    
    
    [mPlacePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            ImagePickerFile *mf = [ImagePickerFile new];
            mf.title = place.name;
            mf.message=place.formattedAddress;
            UIImage *newImage= [ImagePickerUtils getDefaultMapImage];
            mf.image = newImage;
            //mf.filePath = [ProfileHandler saveImage:newImage];
            mf.fileType = PICK_LOCATION;
            mf.lat = place.coordinate.latitude;
            mf.lon = place.coordinate.longitude;
            //NSString *url = [NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=15&views=traffic",mf.lat,mf.lon];
            _completionHandler(mf);
        } else {
            //self.nameLabel.text = @"No place selected";
            //self.addressLabel.text = @"";
        }
    }];
    
    
    
}


-(void)captureImage:(void(^)(NSString* imagePath))handler {
    
    [self fromCamera];
    
}

- (void) getAudioTracks {
    
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    //mediaPicker.showsCloudItems = YES;
    //mediaPicker.prompt = NSLocalizedString (@"Select Audio track to send", "Prompt in media item picker");
    @try {
        [mediaPicker loadView]; // Will throw an exception in iOS simulator
        [_mParent presentViewController:mediaPicker animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        
        [UIAlerts showDialogue:NSLocalizedString(@"The music library is not available.",@"Error message when MPMediaPickerController fails to load") withTitle:NSLocalizedString(@"Oops!",@"Error title")];
    }
    
    
}

#pragma mark Media picker delegate methods

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    // We need to dismiss the picker
    [_mParent dismissViewControllerAnimated:YES completion:nil];
    
    // Assign the selected item(s) to the music player and start playback.
    if ([mediaItemCollection count] < 1) {
        return;
    }
    MPMediaItem *anItem = (MPMediaItem *)[mediaItemCollection.items objectAtIndex: 0];
    
    
    NSURL *assetURL = [anItem valueForProperty: MPMediaItemPropertyAssetURL];
    NSString *song = [assetURL path];
    
    ImagePickerFile *mf = [ImagePickerFile new];
    mf.message = nil;
    mf.title=nil;
    mf.filePath = song;
    mf.image = [ImagePickerUtils getDefaultMusicImage];
    _completionHandler(mf);
    
    
    
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    
    // User did not select anything
    // We need to dismiss the picker
    
    [_mParent dismissViewControllerAnimated:YES completion:nil ];
}

-(void)captureVideo{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *tmp_picker=[[UIImagePickerController alloc]init];
        tmp_picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        
        tmp_picker.navigationBar.tintColor = [UIColor whiteColor];
        
        tmp_picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        
        tmp_picker.delegate=self;
        
        [_mParent presentViewController:tmp_picker animated:YES completion:nil];
        
        _completionHandler([ImagePickerFile new]);
        
        
        
    }else {
        
        [UIAlerts showDialogue:@"No Camera Available." withTitle:@""];
        
        
    }
    
}

-(void)fromVideoGallery{
    
    [self launchGMImagePicker:self];
    
}

-(void)handleFacebook {
    FacebookLogin *fblogin = [FacebookLogin sharedInstance];
    fblogin.mParentController = _mParent;
    [fblogin initiateLogin];
}


-(void) callBackFromFacebook:(UIImage*) imageFacebook{
    
    ImagePickerFile *mf = [ImagePickerFile new];
    mf.fileType = PICK_FACEBOOK_IMAGES;
    mf.title=nil;
    mf.image = imageFacebook;
    _completionHandler(mf);
    
}

-(void) getImageEditor:(UIImage *)image title:(NSString *)title hideEditControl:(BOOL)hideControls showCaption:(BOOL)showCaption showCropOverlay:(BOOL)showCropOverlay squareCrop:(BOOL)squareCrop maxDimension:(int)maxDimension withBlock:(MesiboImageEditorBlock)handler {
    
    UIStoryboard *storyboard = [ImagePickerUtils getMeImageVuStoryBoard];
    
    AddCaptionViewController *avc = [storyboard instantiateViewControllerWithIdentifier:@"AddCaptionViewController"];
    
    if([avc isKindOfClass:[AddCaptionViewController class]]) {
        UINavigationController *un = [[UINavigationController alloc] initWithRootViewController:avc];
        avc.mImageCaption = image;
        avc.mHandlerBlock = handler;
        avc.mTitle = title;
        avc.mHideEditControl=hideControls;
        avc.mShowCaption = showCaption;
        avc.mShowCropOverlay = showCropOverlay;
        avc.mSquareCrop = squareCrop;
        avc.mMaxDimension = maxDimension;
        [_mParent presentViewController:un animated:YES completion:nil];
    }
    
    
}


- (void)fromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = [ImagePicker sharedInstance];
        [_mParent presentViewController: controller animated: YES completion: nil];
    } else {
        
        [UIAlerts showDialogue:@"No Camera Available." withTitle:@""];
        
    }
}

-(void)fromMyPhone
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.navigationBar.barStyle = UIBarStyleBlackTranslucent; // Or whatever style.
        // or
        controller.navigationBar.tintColor = [UIColor whiteColor];
        
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = [ImagePicker sharedInstance];
        [_mParent presentViewController: controller animated: YES completion: nil];
    }else {
        
        [UIAlerts showDialogue:@"No Picture Available." withTitle:@""];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_mParent dismissViewControllerAnimated: YES completion: nil];
    ImagePickerFile *mf = [ImagePickerFile new];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeVideo] ||
        [type isEqualToString:(NSString *)kUTTypeMovie])
    {   // movie != video
        NSURL *urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
        UIImage *image = [ImagePickerUtils thumbnailImageFromURL:urlvideo];
        CGSize newSize = CGSizeMake(240.0f, 240.0f);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        mf.image = newImage;
        mf.filePath = [urlvideo path];
        mf.fileType = PICK_VIDEO_RECORDING;
        mf.title=nil;
        
        [self mov2mp4:mf videoUrl:urlvideo];
        _completionHandler(mf);
        
    }else {
        UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
        CGSize newSize = CGSizeMake(240.0f, 240.0f);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        mf.image = image;
        mf.fileType = PICK_CAMERA_IMAGE;
        mf.title=nil;
        mf.filePath = nil;
        _completionHandler(mf);

    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [_mParent dismissViewControllerAnimated: YES completion: nil];
    
}

- (IBAction)launchGMImagePicker:(id)sender
{
    GMImagePickerController *picker = [[GMImagePickerController alloc] init];
    picker.delegate = self;
    picker.title = @"Gallery";
    
    picker.customDoneButtonTitle = @"Done";
    picker.customCancelButtonTitle = @"Cancel";
    picker.customNavigationBarPrompt = nil;
    picker.colsInPortrait = 3;
    picker.colsInLandscape = 5;
    picker.minimumInteritemSpacing = 2.0;
    picker.displaySelectionInfoToolbar = NO;
    picker.allowsMultipleSelection = NO;
    //picker.confirmSingleSelection = YES;
    //picker.confirmSingleSelectionPrompt = @"Do you want to select the image you have chosen?";
    
    //picker.showCameraButton = YES;
    picker.autoSelectCameraImages = NO;
    
    //You can pick the smart collections you want to show:
    picker.customSmartCollections = @[@(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                      @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                      @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                      @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
                                      @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
                                      @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                      @(PHAssetCollectionSubtypeSmartAlbumPanoramas)];
    
    
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //picker.mediaTypes = @[@(PHAssetMediaTypeImage)];
    
    //picker.pickerBackgroundColor = [UIColor blackColor];
    //picker.pickerTextColor = [UIColor whiteColor];
    picker.toolbarBarTintColor = [UIColor whiteColor];
    picker.toolbarTextColor = [UIColor whiteColor];
    picker.toolbarTintColor = [UIColor getColor:TOOLBAR_COLOR];
    picker.navigationBarBackgroundColor = [UIColor getColor:TOOLBAR_COLOR];
    picker.navigationBarTextColor = [UIColor whiteColor];
    picker.navigationController.navigationBar.barTintColor =[UIColor getColor:TOOLBAR_COLOR];
    picker.navigationBarTintColor = [UIColor whiteColor];
    
    //picker.pickerFontName = @"Verdana";
    //    picker.pickerBoldFontName = @"Verdana-Bold";
    //    picker.pickerFontNormalSize = 14.f;
    //    picker.pickerFontHeaderSize = 17.0f;
    picker.pickerStatusBarStyle = UIStatusBarStyleDefault;
    //picker.useCustomFontForNavigationBar = YES;
    
    //UIPopoverPresentationController *popPC = picker.popoverPresentationController;
    //popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //popPC.sourceView = _gmImagePickerButton;
    //popPC.sourceRect = _gmImagePickerButton.bounds;
    //popPC.backgroundColor = [UIColor blackColor];
    
    
    [_mParent presentViewController:picker animated:YES completion:^{
        _mParent.navigationController.navigationBarHidden = YES;

    }];
}

-(long) getFileSize:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:filePath])
        return -1;
    
    NSError *error;
    NSDictionary *fileAttributes = [manager attributesOfItemAtPath:filePath error:&error];
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    return (long) fileSize;
}


- (int)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL handler:(void (^)(int))handler {
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    
    long filesizemov = [self getFileSize:[inputURL path]];
    
    NSString *preset = AVAssetExportPresetPassthrough;
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        preset = AVAssetExportPresetLowQuality;
    if ((filesizemov < 10*1024*1024) && [compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
        preset = AVAssetExportPresetMediumQuality;
    
    //AVAssetExportPresetPassthrough
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:preset];
    exportSession.outputURL = outputURL;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int result = 0;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        int status = exportSession.status;
        if(exportSession.status == AVAssetExportSessionStatusFailed || exportSession.status == AVAssetExportSessionStatusCancelled  ) {
            NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
            result = -1;
        }
        else if(exportSession.status == AVAssetExportSessionStatusCompleted)
                result = 0;
        else
            return;
        
        if(handler)
            handler(result);
        else
            dispatch_semaphore_signal(semaphore);
    }];
    
    if(!handler)
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}


-(void) mov2mp4:(ImagePickerFile *)mf videoUrl:(NSURL *) videoUrl{
    NSString *ext = [mf.filePath pathExtension];
    if(!ext || [ext caseInsensitiveCompare:@"mov"] != NSOrderedSame)
        return;
    
    
    mf.mp4state = 1;
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], @"video.mp4"];
    NSURL* outurl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    
    mf.mp4Path = [outurl path];
    //NSURL *outurl = [[urlvideo URLByDeletingPathExtension] URLByAppendingPathExtension:@"mp4"];
    [self convertVideoToLowQuailtyWithInputURL:videoUrl outputURL:outurl handler:^(int result) {
        long filesize = [self getFileSize:mf.mp4Path];
        
        if(0 == result) {
            [mf setMp4Ready:YES];
        } else
            [mf setMp4Ready:NO];
    }];
    
}

#pragma mark - GMImagePickerControllerDelegate

- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    _mParent.navigationController.navigationBarHidden = NO;
    
    NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
    PHAsset *pa = [assetArray objectAtIndex:0];
    
    //NSString *localid =
    
    ImagePickerFile *mf = [ImagePickerFile new];
    mf.fileType = pa.mediaType;
    mf.title=nil;
    
    if(pa.mediaType == PHASSET_VIDEO) {
        PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc] init];
        videoRequestOptions.version = PHVideoRequestOptionsVersionOriginal;
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:pa options:videoRequestOptions resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Your main thread code goes in here
                NSLog(@"Im on the main thread");
                [picker dismissViewControllerAnimated:YES completion:nil];
                
                // the AVAsset object represents the original video file
                NSURL *urlvideo = [(AVURLAsset *)asset URL];
                UIImage *image = [ImagePickerUtils thumbnailImageFromURL:urlvideo];
                CGSize newSize = CGSizeMake(240.0f, 240.0f);
                UIGraphicsBeginImageContext(newSize);
                [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                mf.filePath = [urlvideo path];
                mf.image = newImage;
                mf.phasset = pa;
                mf.localIdentifier = [pa localIdentifier];
                
                [self mov2mp4:mf videoUrl:urlvideo];
                _completionHandler(mf); // now call completion handler so that it can do it's workl

                
            });
            
        }];
        
    } else {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.deliveryMode = PHImageRequestOptionsVersionOriginal;
        imageRequestOptions.resizeMode =PHImageRequestOptionsResizeModeExact;
        
        [[PHImageManager defaultManager] requestImageForAsset:pa targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Your main thread code goes in here
                NSLog(@"Im on the main thread");
                [picker dismissViewControllerAnimated:YES completion:nil];
                mf.image = result;
                mf.phasset = pa;
                //Not setting local identifier here
                _completionHandler(mf);
            });
        }];
    }
}



//Optional implementation:
-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    _mParent.navigationController.navigationBarHidden = NO;
    NSLog(@"GMImagePicker: User pressed cancel button");
}


-(void) showPhotoInViewer:(UIViewController *)presentController withImage : (UIImage*) photoImage withTitle:(NSString*) title {
    
    UIStoryboard *storyboard = [ImagePickerUtils getMeImageVuStoryBoard];
    PhotoSliderController *psc = [storyboard instantiateViewControllerWithIdentifier:@"PhotoSliderController"];
    
    if([psc isKindOfClass:[PhotoSliderController class]]) {
        psc.mImageShow = photoImage;
        psc.mTitle = title;
        UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:psc];
        [presentController  presentViewController:unc animated:YES completion:nil];
    }
}

-(void) showMediaFilesInViewer:(UIViewController *)presentController withInitialIndex:(int)index withData : (NSArray*) filesArray withTitle:(NSString*) title{
    
    UIStoryboard *storyboard = [ImagePickerUtils getMeImageVuStoryBoard];
    PhotoSliderController *psc = [storyboard instantiateViewControllerWithIdentifier:@"PhotoSliderController"];
    
    if([psc isKindOfClass:[PhotoSliderController class]]) {
        UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:psc];
        psc.mSliderImageArray = filesArray;
        psc.mViwerZoomIndex = (NSUInteger)index;
        psc.mTitle = title;
        [presentController   presentViewController:unc animated:YES completion:nil];
        
    }
    
    
}

-(void) showMediaFiles : (UIViewController *)presentController withMediaData :(NSArray *) data  withTitle:(NSString*) title{
    
    UIStoryboard *storyboard = [ImagePickerUtils getMeImageStoryBoard];
    AlbumTableController *at = [storyboard instantiateViewControllerWithIdentifier:@"AlbumTableController"];
    
    if([at isKindOfClass:[AlbumTableController class]]) {
        UINavigationController *un = [[UINavigationController alloc] initWithRootViewController:at];
        at.mAlbumsData = data;
        at.mTitle = title;
        [presentController presentViewController:un animated:YES completion:nil];
    }
}

+ (void) showVideofile:(UIViewController *) parent withVideoFilePath:(NSString*) filePath {
    
    NSURL *videoURL = [NSURL fileURLWithPath:filePath];
    //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    //[playerViewController.player play];//Used to Play On start
    [parent presentViewController:playerViewController animated:YES completion:nil];
    
}

+ (void) openGenericFiles:(UIViewController *) parent withFilePath:(NSString*) filePath {
    
    NSURL *resourceToOpen = [NSURL fileURLWithPath:filePath];
    BOOL canOpenResource = [[UIApplication sharedApplication] canOpenURL:resourceToOpen];
    if (canOpenResource) {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:resourceToOpen options:@{} completionHandler:nil];
    }
    
}

+(void) showFile:(UIViewController *)parent path:(NSString *)path title:(NSString *)title type:(int)type{
    
    if(0 == type) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [[ImagePicker sharedInstance] showPhotoInViewer:parent withImage:image withTitle:title];
        return;
    }
    
    if(1 == type) {
        [ImagePicker showVideofile:parent withVideoFilePath:path];
        return;
    }
    
    if(2 == type) {
        [ImagePicker openGenericFiles:parent withFilePath:path];
        return;
    }
    
    return;
}



@end
