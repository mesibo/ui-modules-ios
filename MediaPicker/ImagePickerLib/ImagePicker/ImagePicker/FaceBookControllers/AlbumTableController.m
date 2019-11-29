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
