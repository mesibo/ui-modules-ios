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

#import "CreateNewGroupViewController.h"
#import "MesiboImage.h"
#import <mesibo/Mesibo.h>
#import "Includes.h"
#import "MesiboCommonUtils.h"
#import "UserListViewController.h"
#import "MesiboUIAlerts.h"
#import "MesiboUIManager.h"

#define  MAXLENGTH  50
#define  GROUP_NAME_LENTH 2

@interface CreateNewGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mContactsTable;
@property (weak, nonatomic) IBOutlet UITextField *mGroupNameEditor;

@property (weak, nonatomic) IBOutlet UIImageView *mGroupImage;
@property (weak, nonatomic) IBOutlet UIButton *mCreateGroupBtn;
@property (weak, nonatomic) IBOutlet UILabel *mCharCounter;

@end



@implementation CreateNewGroupViewController

{
    NSString *mGroupPicturePath;
    NSString *mGroupStatus;
    UIColor *mPrimaryColor;
    
    uint32_t mGroupId;
    MesiboUiOptions *mMesiboUIOptions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mMesiboUIOptions = [MesiboInstance getUiOptions];
    self.title = mMesiboUIOptions.createGroupTitle;
    if(_mGroupModifyMode)
        self.title = MODIFY_GROUP_TITLE_STRING;
    
    mPrimaryColor = [UIColor getColor:0xff00868b];
    if(mMesiboUIOptions.mToolbarColor)
        mPrimaryColor = [UIColor getColor:mMesiboUIOptions.mToolbarColor];
    
    MesiboUserProfile *mesiboGroupProfile = nil;
    
    mGroupId = _mGroupid;
    
    if(mGroupId > 0) {
        mesiboGroupProfile = [MesiboInstance getGroupProfile:mGroupId];
        if(mesiboGroupProfile)
            _mGroupName = mesiboGroupProfile.name;
        
        _mGroupNameEditor.text = _mGroupName ;
    }
    
    _mContactsTable.delegate = self;
    _mContactsTable.dataSource = self;
    _mGroupNameEditor.delegate = self;
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[MesiboImage imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    _mContactsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_mContactsTable reloadData];
    UITapGestureRecognizer *keyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyTapPressed)];
    keyTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:keyTap];
    
    UITapGestureRecognizer *pictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfilePicture:)];
    pictureTap.numberOfTapsRequired = 1;
    pictureTap.delegate = self;
    _mGroupImage.userInteractionEnabled = YES;
    [_mGroupImage addGestureRecognizer:pictureTap];
    
    _mCharCounter.text = [NSString stringWithFormat:@"%d",MAXLENGTH];
    
    mGroupPicturePath = nil;
    
    NSString *picturePath = [MesiboImage getDefaultGroupProfilePath];
    if(mesiboGroupProfile) {
        picturePath = [MesiboInstance getProfilePicture:mesiboGroupProfile type:MESIBO_FILETYPE_AUTO];
        if(!picturePath)
            picturePath = [MesiboImage getDefaultGroupProfilePath];
    }
    
    _mGroupImage.image = [UIImage imageWithContentsOfFile:picturePath];
        
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor getColor:NAVIGATION_TITLE_COLOR]}];
}

-(void) viewWillAppear:(BOOL)animated {
    [MesiboCommonUtils setNavigationBarColor:self.navigationController.navigationBar color:mPrimaryColor];
    
}

- (void) keyTapPressed {
    [_mGroupNameEditor resignFirstResponder];
    
}

-(IBAction)barButtonBackPressed:(id)sender {
    
    
    ((UserListViewController *)_mParenController).mGroupMembers = _mMemberProfiles;
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)createNewGroup:(id)sender {
    if(_mGroupNameEditor.text.length < GROUP_NAME_LENTH) {
        [MesiboUIAlerts showDialogue:GROUP_NAME_FAIL_MSG withTitle:GROUP_NAME_FAIL_TITLE];
        return;
    }
    if([_mMemberProfiles count] <= 0 ){
        [MesiboUIAlerts showDialogue:CREATE_GROUP_NOMEMEBER_MESSAGE_STRING withTitle:CREATE_GROUP_NOMEMEBER_TITLE_STRING];
        return;
    }
    
    NSMutableArray *members = [NSMutableArray new];
    for(int i = 0; i<[_mMemberProfiles count];i++) {
        
        MesiboUserProfile *mup = [_mMemberProfiles objectAtIndex:i];
        [members addObject:mup.address];
    }
    
    
    MesiboUserProfile *p = [MesiboUserProfile new];
    p.groupid = mGroupId;
    p.name = _mGroupNameEditor.text;
    p.status = nil;
    p.picturePath = mGroupPicturePath;
    
    [[MesiboInstance getDelegates] Mesibo_onSetGroup:self profile:p type:0 members:members handler:^(uint32_t groupid) {
        
        if(groupid <= 0) {
            [MesiboUIAlerts showDialogue:GROUP_CREATION_FAIL_MSG withTitle:GROUP_CREATION_FAIL_TITLE];
            return;
            
        }
        
        MesiboUserProfile *mesiboGroupProfile = [MesiboInstance getGroupProfile:groupid];
        int previousController ;
        
        // TBD Anirudh, can we fix 2,3 ?
        if(mGroupId==0) {
            //mesiboGroupProfile = [[MesiboUserProfile alloc] init];
            previousController = 3 ;
        }else {
            //mesiboGroupProfile = [MesiboInstance getGroupProfile:mGroupId];
            previousController = 2;
        }
        
        
        //TBD, copy image profile (Namitha)
        
        if(mGroupId==0) {
            
            [MesiboUIManager launchMessageViewController:self withUserData:mesiboGroupProfile uidelegate:_mUiDelegate];
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
            int index = (int)[navigationArray count]-2;
            [navigationArray removeObjectAtIndex:index];  // You can pass your index here
            [navigationArray removeObjectAtIndex:index-1];  // You can pass your index here
            [navigationArray removeObjectAtIndex:index-2];  // You can pass your index here
            
            self.navigationController.viewControllers = navigationArray;
            
            
        } else {
            
            UIViewController *popViewController = self.navigationController.viewControllers[self.navigationController.viewControllers.count-previousController-1];
            
            [self.navigationController popToViewController:popViewController animated:YES];
            
        }
        
        
        
    }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return  [_mMemberProfiles count];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(newText.length>MAXLENGTH) {
        return NO;
    }
    
    [_mCharCounter setText:[NSString stringWithFormat:@"%u", (uint32_t)(MAXLENGTH-newText.length)]];
    
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString * resueIdentifier = @"cells";
    
    cell = [tableView dequeueReusableCellWithIdentifier:resueIdentifier];
    if(cell==nil) {
        cell   = [[UITableViewCell alloc]
                  initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:resueIdentifier];
    }
    MesiboUserProfile *mp = [_mMemberProfiles objectAtIndex:indexPath.row];
    
    UIImageView *profileImage = [cell viewWithTag:100];
    UserData *ud = [UserData getUserDataFromProfile:mp];
    [profileImage layoutIfNeeded];
    UIImage *image = [ud getThumbnail];
    if(!image)
        image = [ud getDefaultImage:[MesiboInstance getUiOptions].useLetterTitleImage];
    
    profileImage.image = image;
    profileImage.layer.cornerRadius = profileImage.layer.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    
    UILabel *name = [cell viewWithTag:101];
    name.text = mp.name;
    
    UILabel *status = [cell viewWithTag:102];
    status.text = mp.status;
    
    UIButton *cancelBtn = [cell viewWithTag:103];
    [cancelBtn setTag:indexPath.row];
    [cancelBtn addTarget:self action:@selector(deleteMemeberGroup:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) deleteMemeberGroup : (id) sender {
    int index = (int)[sender tag];
    NSIndexPath *indexPath = [[NSIndexPath alloc]init];
    indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_mMemberProfiles removeObjectAtIndex:indexPath.row];
    //[_mContactsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_mContactsTable reloadData];
            
        } completion:^(BOOL finished) {
            
        }];
        
    });
    
}


- (void)changeProfilePicture:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GROUP_PICTURE_TITLE_STRING
                                                                   message:GROUP_PICTURE_MSG_STRING
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:CAMERA_STRING
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self pickMediaWithFiletype:PICK_CAMERA_IMAGE];
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:PHOTOGALLERY_STRING
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self pickMediaWithFiletype:PICK_VIDEO_GALLERY];
                                                           }];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:CANCEL_STRING
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button cancel");
                                                          }];
    
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
- (void) pickMediaWithFiletype :(int)filetype{
    ImagePicker *im = [ImagePicker sharedInstance];
    im.mParent = self;
    [MesiboUIManager pickImageData:im withParent:self withMediaType:filetype withBlockHandler:^(ImagePickerFile *picker) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(picker.fileType == PICK_CAMERA_IMAGE | picker.fileType == PICK_IMAGE_GALLERY || picker.fileType == PICK_VIDEO_GALLERY) {
                NSLog(@"Returned data %@", [picker description]);
                [MesiboUIManager launchImageEditor:im withParent:self withImage:picker.image title:CROPPER_TITLE hideEditControls:NO showCaption:NO showCropOverlay:YES squareCrop:YES maxDimension:600 withBlock:^BOOL(UIImage *image, NSString *caption) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Your UI code //
                        _mGroupImage.image = image;
                        NSString *fileName = [NSString stringWithFormat:@"group%u.jpg", mGroupId];
                        mGroupPicturePath = [[MesiboInstance getFilePath:MESIBO_FILETYPE_PROFILEIMAGE] stringByAppendingPathComponent:fileName];
                        //NSData *imageData = UIImagePNGRepresentation(image);
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
                        [imageData writeToFile:mGroupPicturePath atomically:YES];
                        MesiboUserProfile *mesiboGroupProfile = [MesiboInstance getGroupProfile:mGroupId];
                        //((UserData*)mesiboGroupProfile.other).userThumbnail = [UIImage imageWithContentsOfFile:mGroupPicturePath];
                        mesiboGroupProfile.picturePath = mGroupPicturePath;
                    });
                    NSLog(@"message data %@",caption);
                    return YES;
                    
                }];
            }});
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
