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

#import "PhotoGalleryController.h"
#import "ImageViewer.h"
#import "UIColors.h"
#import "ImagePicker.h"
#import "ImagePickerUtils.h"
#import "FacebookLogin.h"
#import "PhotoSliderController.h"



#define kCellsPerRow 4

@interface PhotoGalleryController ()

@end

@implementation PhotoGalleryController

{
    int mEmptyTabl;
}

static NSString * const reuseIdentifier = @"CELL";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _mGalleryData.mAlbumName;
    mEmptyTabl=0;
    
    if(_mGalleryData.mAlbumPhotoCount >0) {
        mEmptyTabl =1;
    }
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.collectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[ImagePickerUtils imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) backButtonPressed:(id) sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    if (mEmptyTabl!=0) {
        
        self.collectionView.backgroundView = nil;
        
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-30, self.view.bounds.size.height)];
        
        messageLabel.text = @"Ooops Album is Empty :-(  ";
        messageLabel.textColor = [UIColor getColor:AT_MESSAGE_TXT_COLOR];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont boldSystemFontOfSize:16];
        
        //[messageLabel sizeToFit];
        
        self.collectionView.backgroundView = messageLabel;
        
    }
    
    return 0;

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    
    int totalCount =(int) _mGalleryData.mAlbumPhotoCount;
    return (totalCount);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
 
    
    UIImageView *albumImageView = (UIImageView *)[cell viewWithTag:100];
    UIImageView *videoImageLayer = (UIImageView *)[cell viewWithTag:101];
    albumImageView.image = [ImagePickerUtils imageNamed:@"indicator"];
    PhotoData *temp =[_mGalleryData.mPhotoGList objectAtIndex:indexPath.row];
    NSString * path = temp.mSourcePath;
    
    
    if([ImagePickerUtils isUrl:path]) {
               dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mesibo.mediapicker", 0);
        //dispatch_queue_t backgroundQueue = dispatch_get_main_queue();
        dispatch_async(backgroundQueue, ^{
            
            NSURL *url = [NSURL URLWithString:temp.mIconPath];
            albumImageView.image= [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            
            });
    }else {
        
        if([ImagePickerUtils isImageFile:path])
                videoImageLayer.hidden = YES;
        else
                videoImageLayer.hidden = NO;
        albumImageView.image= [ImagePickerUtils getBitmapFromFile:temp.mSourcePath];

    }

    return cell;
}



#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"selected %lu",(long)indexPath.row);
    
    PhotoData *temp =[_mGalleryData.mPhotoGList objectAtIndex:indexPath.row];
    
    
    if([ImagePickerUtils isUrl:temp.mSourcePath]) {
        
        UIStoryboard *storyboard = [ImagePickerUtils getMeImageStoryBoard];

        ImageViewer *cv = [storyboard instantiateViewControllerWithIdentifier:@"ImageViewer"];

        if([cv isKindOfClass:[ImageViewer class]]) {
            cv.mFBUrl = temp.mSourcePath;
            cv.mClosModalController = _mCloseModalController;
            [self   presentViewController:cv animated:YES completion:nil];
        }
    
    }else {
         UIStoryboard *storyboard = [ImagePickerUtils getMeImageVuStoryBoard];
        PhotoSliderController *cv = [storyboard instantiateViewControllerWithIdentifier:@"PhotoSliderController"];
        
        if([cv isKindOfClass:[PhotoSliderController class]]) {
            UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:cv];
            NSMutableArray *nsma = [[NSMutableArray alloc] init];
            for(int i=0;i< [_mGalleryData.mPhotoGList count];i++) {
                [nsma addObject:((PhotoData*)[_mGalleryData.mPhotoGList objectAtIndex:i]).mSourcePath];
            }
            cv.mSliderImageArray = nsma;
            cv.mViwerZoomIndex = indexPath.row;
            [self   presentViewController:unc animated:YES completion:nil];
        }
    }
}


@end
