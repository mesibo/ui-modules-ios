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

#import "AlbumTableController.h"
#import "PhotoGalleryController.h"
#import "UIColors.h"
#import "ImagePicker.h"
#import "Defines.h"
#import "ImagePickerUtils.h"
#import "FacebookLogin.h" 


@interface AlbumTableController ()

@end

@implementation AlbumTableController
{
int mEmptyTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.title = @"Media Files";
    if(nil != _mTitle){
        self.title = _mTitle;
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    self.tableView.tableFooterView.backgroundColor = [UIColor getColor:TABLE_FOOTER_LINE];
    mEmptyTable=0;
    
    if([_mAlbumsData count] >0) {
        mEmptyTable=1;
    };
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[ImagePickerUtils imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)barButtonBackPressed:(id)sender {
    

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    
    if (mEmptyTable!=0) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
        
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-30, self.view.bounds.size.height)];
        
        messageLabel.text = @"Ooops ! Empty Album :( ";
        messageLabel.textColor = [UIColor getColor:AT_MESSAGE_TXT_COLOR
                                  ];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont boldSystemFontOfSize:16];
        
        //[messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    NSLog(@"album count %lu",(unsigned long)[_mAlbumsData count]);
    return [_mAlbumsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 77;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     NSString *  reuseIdentifier = @"cellAlbum";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
 
    AlbumsData *alg1 = [_mAlbumsData objectAtIndex:indexPath.row];
    
    UILabel *albumName = (UILabel*)[cell viewWithTag:101];
    albumName.text = (NSString*) alg1.mAlbumName;
    
    UILabel *albumCount = (UILabel*)[cell viewWithTag:102];
    albumCount.text = [NSString stringWithFormat:@"%ld items",(long)alg1.mAlbumPhotoCount];
    
 
    UIImageView *albumImageView = (UIImageView *)[cell viewWithTag:100];
    
    NSString *pathString = ( (AlbumsData *)[_mAlbumsData objectAtIndex:indexPath.row]).mAlbumProfilePicPath;
    
    if([ImagePickerUtils isUrl:pathString]) {
        albumImageView.image = [ImagePickerUtils imageNamed:@"indicator"];

        dispatch_queue_t backgroundQueue = dispatch_queue_create("com.social.fun", 0);
        //dispatch_queue_t backgroundQueue = dispatch_get_main_queue();
        dispatch_async(backgroundQueue, ^{
 
            NSURL *url = [NSURL URLWithString: pathString];
            albumImageView.image= [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];

        });
        
    } else {
        
        //albumImageView.image = [UIImage imageWithContentsOfFile:pathString];
        albumImageView.image = [ImagePickerUtils getBitmapFromFile:pathString];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    NSLog(@"selected %ld",(long)indexPath.row);
    
    UIStoryboard *storyboard = [ImagePickerUtils getMeImageStoryBoard];

    
    PhotoGalleryController *destViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoGalleryController"];
    
    if([destViewController isKindOfClass:[PhotoGalleryController class]]) {
        destViewController.mGalleryData = [_mAlbumsData objectAtIndex:indexPath.row];
        destViewController.mCloseModalController =self;
        
        UINavigationController *unv = [[UINavigationController alloc] initWithRootViewController:destViewController];
        //[self.navigationController pushViewController:destViewController animated:YES];
        [self presentViewController:unv animated:YES completion:nil];
        
        }
}



@end
