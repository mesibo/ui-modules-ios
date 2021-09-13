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

#import "UserListViewController.h"
#import "MesiboMessageViewController.h"
//#import "ProfileHandler.h"
#import "MesiboImage.h"
#import "UIImage+Tint.h"
#import "UIColors.h"
#import "MesiboCommonUtils.h"
#import "MesiboUIAlerts.h"
#import "CreateNewGroupViewController.h"
#import "LetterTitleImage.h"
#import "MesiboConfiguration.h"
#import "MesiboUIManager.h"
#import "Includes.h"


@implementation UserListViewController

{
    
    NSMutableArray *mUsersList;
    // for housing serached messaged from database and userlist in "forward to user" list
    NSMutableArray *mCommonNFilterArray;
    NSMutableArray *mTableList;
    //NSMutableDictionary *mProfilesLookup;
    UILabel *mUserStatusLbl;
    UILabel *mUserNameLbl;
    CGRect mShowUserStatusFrm;
    CGRect mHideUserStatusFrm;
    MesiboUiOptions *mMesiboUIOptions;
    
    BOOL mIsMessageSearching;
    // comon utility array for searching and deplying section in "forward to user" list
    NSMutableArray *mUtilityArray;
    
    NSMutableArray *mSelectedMembers;
    
    NSBundle *mMessageBundle;
    NSTimer* mUiUpdateTimer;
    uint64_t mTiUpdateTimestamp;
    
    UIColor *mStatusColor, *mTypingColor, *mPrimaryColor;
    int mTotalUnreadCount;
    MesiboReadSession *mReadSession;
    
    NSMutableArray* mGroupMembers;
    MesiboProfile* mGroupProfile ;
}

-(void) setGroupMembers:(NSMutableArray *)members {
    mGroupMembers = members;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mReadSession = nil;
    mTotalUnreadCount = 0;
    mUiUpdateTimer = nil;
    mTiUpdateTimestamp = 0;
    mMesiboUIOptions = [MesiboUI getUiOptions];
    mUsersList = [[NSMutableArray alloc] init];
    mCommonNFilterArray = [[NSMutableArray alloc] init];
    mUtilityArray = [[NSMutableArray alloc] init];
    mSelectedMembers = [[NSMutableArray alloc] init];
    mGroupMembers = [[NSMutableArray alloc] init];
    
    
    mPrimaryColor = [UIColor getColor:0xff00868b];
    if(mMesiboUIOptions.mToolbarColor)
        mPrimaryColor = [UIColor getColor:mMesiboUIOptions.mToolbarColor];
    
    
    //mPrimaryColor = [UIColor getColor:0xff00868b];
    
    mStatusColor = [UIColor getColor:mMesiboUIOptions.mUserListStatusColor];
    mTypingColor = [UIColor getColor:mMesiboUIOptions.mUserListTypingIndicationColor];
    
    // [[UINavigationBar appearance] setTintColor: mPrimaryColor];
    // self.navigationController.navigationBar.barTintColor = mPrimaryColor;
    
    if(_mForwardGroupid) {
        mGroupProfile = [MesiboInstance getGroupProfile:_mForwardGroupid];
        [MesiboInstance addListener:self];
        if(mGroupProfile && (!mGroupMembers || !mGroupMembers.count)) {
            [[mGroupProfile getGroupProfile] getMembers:256 restart:YES listener:self];
        }
    }
    
    
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    
    if(nil == bundleURL) {
        
    }
    
    [self updateTitles:_mNewContactChooser];
    
    mMessageBundle = [[NSBundle alloc] initWithURL:bundleURL];
    _mUsersTableView.delegate = self;
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[MesiboImage imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    if(_mNewContactChooser == USERLIST_MESSAGE_MODE && !mMesiboUIOptions.enableBackButton)
        self.navigationItem.leftBarButtonItem = nil;
    
    if(_mNewContactChooser != USERLIST_MESSAGE_MODE)  {
        if(_mNewContactChooser==USERLIST_FORWARD_MODE) {
            UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button1 setImage:[MesiboImage imageNamed:@"ic_forward_white.png"] forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(forwardMessageToContacts)forControlEvents:UIControlEventTouchUpInside];
            [button1 setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
            UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
            self.navigationItem.rightBarButtonItem = barButton1;
            
        } else if (_mNewContactChooser == USERLIST_SELECTION_GROUP || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE) {
            UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button1 setImage:[MesiboImage imageNamed:@"ic_group_add_white.png"] forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(createNewGroup)forControlEvents:UIControlEventTouchUpInside];
            [button1 setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
            UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
            self.navigationItem.rightBarButtonItem = barButton1;
            
        }
        
    }else {
        
        if (_mNewContactChooser == USERLIST_MESSAGE_MODE) {
            NSArray *btnArray = [[MesiboInstance getDelegates] Mesibo_onGetMenu:self type:0 profile:nil];
            NSMutableArray *barBtnArray = [[NSMutableArray alloc] init];
            for(int i = 0 ; i < [btnArray count]; i++) {
                UIButton *button = [btnArray objectAtIndex:i];
                [button addTarget:self action:@selector(uiBarButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
                [button setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
                UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
                [barBtnArray insertObject:barButton atIndex:0];
            }
            
            if(mMesiboUIOptions.enableMessageButton && (!btnArray || !btnArray.count)) {
                UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
                [button setImage:[UIImage imageNamed:@"ic_message_white"] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
                [button setTag:0];
                [button addTarget:self action:@selector(uiBarButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
                [barBtnArray insertObject:barButton atIndex:0];
            }
            
            self.navigationItem.rightBarButtonItems = barBtnArray;
            
        }
        
        UIFont *titleFont = [UIFont boldSystemFontOfSize:NAVBAR_TITLE_FONT_SIZE];;
        CGSize size = [mMesiboUIOptions.messageListTitle sizeWithAttributes:@{NSFontAttributeName: titleFont}];
        
        CGSize titleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_TITLEVIEW_WIDTH, 0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor getColor:NAVIGATION_TITLE_COLOR];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = titleFont;
        titleLabel.text = mMesiboUIOptions.messageListTitle;
        titleLabel.tag = 21;
        
        [titleLabel sizeToFit];
        
        UIFont *subtitleFont = [UIFont systemFontOfSize:NAVBAR_SUBTITLE_FONT_SIZE];
        size = [@"Connecting" sizeWithAttributes:@{NSFontAttributeName: subtitleFont}];
        CGSize subtitleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleSize.height, NAVBAR_TITLEVIEW_WIDTH, 0)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.textColor = [UIColor getColor:NAVIGATION_TITLE_COLOR];
        subTitleLabel.font = [UIFont systemFontOfSize:NAVBAR_SUBTITLE_FONT_SIZE];
        subTitleLabel.text = @". . . . .  . . . . . . . . ";
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.tag = 20;
        [subTitleLabel sizeToFit];
        
        UIView *twoLineTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(subTitleLabel.frame.size.width, titleLabel.frame.size.width), titleSize.height + subtitleSize.height)];
        [twoLineTitleView addSubview:titleLabel];
        [twoLineTitleView addSubview:subTitleLabel];
        
        float widthDiff = subTitleLabel.frame.size.width - titleLabel.frame.size.width;
        
        if (widthDiff > 0) {
            CGRect frame = titleLabel.frame;
            frame.origin.x = widthDiff / 2;
            titleLabel.frame = CGRectIntegral(frame);
        }else{
            CGRect frame = subTitleLabel.frame;
            frame.origin.x = abs((int)(widthDiff) / 2);
            subTitleLabel.frame = CGRectIntegral(frame);
        }
        
        self.navigationItem.titleView = twoLineTitleView;
        
        mUserStatusLbl = subTitleLabel;
        mUserNameLbl = titleLabel;
        mUserStatusLbl.text = mMesiboUIOptions.connectingIndicationTitle;
        
        mShowUserStatusFrm = mUserNameLbl.frame;
        CGRect frame = mShowUserStatusFrm;
        frame.origin.y += NAVBAR_TITLE_FONT_DISPLACEMENT;
        
        mHideUserStatusFrm = frame;
        
        mUserNameLbl.frame = mHideUserStatusFrm;
        
        self.navigationItem.leftItemsSupplementBackButton = YES;
        mUserStatusLbl.hidden = YES;
        
    }
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = nil;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    BOOL enableSearch = mMesiboUIOptions.enableSearch;
    
    if(USERLIST_FORWARD_MODE == _mNewContactChooser || USERLIST_EDIT_GROUP_MODE == _mNewContactChooser)
        enableSearch = NO;
    
    
    if(enableSearch) {
        _mUsersTableView.tableHeaderView = self.searchController.searchBar;
        // we want to be the delegate for our filtered table so did SelectRowAtIndexPath is called for both tables
        //self.searchResultsController.tableView.delegate = self;
        self.searchController.delegate = self;
        self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
        self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
        self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
        [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
        _mUsersTableView.allowsMultipleSelectionDuringEditing = NO;
        _mUsersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.definesPresentationContext = YES;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    
}

- (void) updateTitles: (int) mode {
    if(mode == USERLIST_MESSAGE_MODE)
        self.title = mMesiboUIOptions.messageListTitle ;
    else if(mode == USERLIST_CONTACTS_MODE)
        self.title = mMesiboUIOptions.selectContactTitle ;
    else if(mode == USERLIST_FORWARD_MODE)
        self.title = mMesiboUIOptions.forwardTitle ;
    else if(mode == USERLIST_SELECTION_GROUP)
        self.title = mMesiboUIOptions.selectGroupContactsTitle ;
    else if(mode == USERLIST_EDIT_GROUP_MODE)
        self.title = mMesiboUIOptions.selectGroupContactsTitle ;
    
}

- (void) uiBarButtonPressed: (id) sender {
    int tag = (int) [(UIBarButtonItem*)sender tag];
    if(tag == 0 ){
        [self launchSelfViewController];
    } else {
        
        [[MesiboInstance getDelegates] Mesibo_onMenuItemSelected:self type:0 profile:nil item:tag];
    }
    
}

-(void) launchSelfViewController {
    
    [MesiboUIManager launchUserListViewcontroller:self withChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"] withContactChooser:USERLIST_CONTACTS_MODE withForwardMessageData:nil withMembersList:nil withForwardGroupName:nil withForwardGroupid:0];
}


-(void) refreshTable:(NSIndexPath *)indexPath {
    if(mUiUpdateTimer) {
        [mUiUpdateTimer invalidate];
        mUiUpdateTimer = nil;
    }
    
    mTiUpdateTimestamp = [MesiboInstance getTimestamp];
    
    if(nil == indexPath) {
        [_mUsersTableView reloadData];
        return;
    }
    
    @try {
        UITableViewCell *cell = [_mUsersTableView cellForRowAtIndexPath:indexPath];
        if(cell)
            [self updateCell:cell index:indexPath];
    }
    @catch(NSException *e) {
        [_mUsersTableView reloadData];
    }
    //[_mUsersTableView endUpdates];
}

-(void) refreshTable {
    [self refreshTable:nil];
}

-(void) addToLookup:(MesiboProfile *) profile {
    NSString *key = [profile getAddress];
    if([profile getGroupId]) {
        key = [NSString stringWithFormat:@"group%u", [profile getGroupId]];
    }
    
}

-(void) lookup:(MesiboProfile *) profile {
    NSString *key = [profile getAddress];
    if([profile getGroupId]) {
        key = [NSString stringWithFormat:@"group%u", [profile getGroupId]];
    }
    
}

-(void) updateNotificationBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = mTotalUnreadCount;
}

-(void) addNewMessage:(MesiboParams *)params message:(NSString *)message {
    
    if(mUiUpdateTimer) {
        [mUiUpdateTimer invalidate];
        mUiUpdateTimer = nil;
    }
    
    if(params.groupid && !params.groupProfile)
        return;
    
    if(!mIsMessageSearching) {
        mTableList = mUsersList;
    } else {
        mTableList = mCommonNFilterArray;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(u_int64_t)params.ts/1000.0];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    MesiboProfile *mp = params.profile;
    if(params.groupProfile)
        mp = params.groupProfile;
    
    if(mp == nil ) {
        NSLog(@"NIL PROFILE - MUST NOT HAPPEN");
        NSLog(@" Crash %@ (message: %@)", [NSThread callStackSymbols], message);
        //return;
    }
    
    //depending on whether to show group or user in search results
    /*
     TBD, this is a bad implementation, the search results are shown based on
     list of user profile and last message, so here entirely new profile is being allocated
     along with new userData. MUST be fixed. We should also take care to not pass this profile anywhere
     */
    if(YES && mIsMessageSearching) {
        NSLog(@"Searching");
        mp = [params.profile cloneProfile];
        
        if(params.groupProfile) {
            mp = [params.groupProfile cloneProfile];
        }
    }
    
    int days = [MesiboInstance daysElapsed:params.ts];
    if(0 == days) {
        [dateFormatter1 setDateFormat:@"HH:mm"];
    } else {
        // We need to fix date in Table to show yesterday etc, right now no space
        [dateFormatter1 setDateFormat:@"dd/MM/yy"];
    }
    
    UserData *oud = [UserData getUserDataFromProfile:mp];
    
    [oud setLastMessage:message];
    [oud setMessage:params.mid time:[dateFormatter1 stringFromDate:date] status:params.status deleted:[params isDeleted] msg:message];
    
    oud.messageStatus = params.status;
    
    mTotalUnreadCount -= [oud getUnreadCount];
    if(mTotalUnreadCount < 0)
        mTotalUnreadCount = 0;
    
    if([MesiboInstance isReading:params]) {
        [oud setUnreadCount:0];
    }
    else{
        if(MESIBO_ORIGIN_DBSUMMARY == params.origin/* || MESIBO_ORIGIN_DBMESSAGE == params.origin */) {
            [oud setUnreadCount:[mp getUnreadCount]];
        }
        else if(MESIBO_ORIGIN_REALTIME == params.origin){
            [oud setUnreadCount:[oud getUnreadCount]+1];
        }
    }
    
    mTotalUnreadCount += [oud getUnreadCount];
    
    if(MESIBO_ORIGIN_REALTIME == params.origin) {
        [self updateNotificationBadge];
    }
    
    // we will receive DB messages also so we can't avoid this
    //create message map
    if(YES || (!mIsMessageSearching && MESIBO_ORIGIN_DBSUMMARY != params.origin && MESIBO_ORIGIN_DBMESSAGE != params.origin)) {
        for(int i=0; i< [mTableList count]; i++) {
            
            MesiboProfile *up = (MesiboProfile *)mTableList[i];
            UserData *ud = [UserData getUserDataFromProfile:up];
            
            if([params compare:[ud getPeer] groupid:[ud getGroupId]]) {
                [mTableList removeObjectAtIndex:i];
                break ;
            }
        }
    }
    
    
    int count  = 0;
    if(MESIBO_ORIGIN_DBSUMMARY == params.origin || MESIBO_ORIGIN_DBMESSAGE == params.origin)
        count = (int) [mTableList count];
    
    [UserData getUserDataFromProfile:mp]; //initialize `other` right away as it's getting checked in onUserProfileUpdated
    [mTableList insertObject:mp atIndex:count];
    
    if(MESIBO_ORIGIN_REALTIME == params.origin) {
        
        uint64_t ts = [MesiboInstance getTimestamp];
                
        if((ts - mTiUpdateTimestamp) > 2000) {
            [self refreshTable:nil];
            return;
        }
        
        NSTimeInterval to = 2.0; // 1 second
        if((ts - params.ts) < 5000) {
            to = 0.5; //half second
        }
        
        mTiUpdateTimestamp = ts; // so that it doesn't keep updating
        
        mUiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:to target: self
                                                        selector:@selector(refreshTable) userInfo: nil repeats: NO];
    }
    
    return ;
}

-(void) updateUiIfLastMessage:(MesiboParams *)params {
    if(![params isLastMessage]) return;
    [MesiboInstance runInThread:YES handler:^{
        [self refreshTable:nil];
        [self updateNotificationBadge];
    }];
}

-(void) Mesibo_OnMessage:(MesiboMessage *)message {
    
}

-(void) Mesibo_OnMessage:(MesiboParams *)params data:(NSData *)data {
    if(_mNewContactChooser != USERLIST_MESSAGE_MODE)
        return;
    
    if([params isCall] && ![params isMissedCall]) {
        [self updateUiIfLastMessage:params];
        return;
    }
    
    if(params.groupid && !params.groupProfile) {
        [self updateUiIfLastMessage:params];
        return;
    }
    
    UserData *ud = [UserData getUserDataFromParams:params];
    if(ud)
        [ud clearTyping];
    
    if(0 == [data length]) {
        [self updateUiIfLastMessage:params];
        return;
    }
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if([params isMissedCall]) {
        
        if([params isVideoCall]) {
            msg = MISSEDVIDEOCALL_STRING;
        } else {
            msg = MISSEDVOICECALL_STRING;
        }
        
    }else if([params isDeleted]) {
        msg = MESSAGEDELETED_STRING;
    }
    
    [self addNewMessage:params message:msg];
    [self updateUiIfLastMessage:params];
}

-(void) Mesibo_onFile:(MesiboParams *)params file:(MesiboFileInfo *)file {
    if(_mNewContactChooser != USERLIST_MESSAGE_MODE)
        return;
    
    NSString *fileType = ATTACHMENT_STRING;
    if(MESIBO_FILETYPE_IMAGE == file.type)
        fileType = IMAGE_STRING;
    else if(MESIBO_FILETYPE_VIDEO == file.type)
        fileType = VIDEO_STRING;
    else if(MESIBO_FILETYPE_LOCATION == file.type)
        fileType = LOCATION_STRING;
    
    [self addNewMessage:params message:fileType];
    [self updateUiIfLastMessage:params];
}

-(void) Mesibo_onLocation:(MesiboParams *)params location:(MesiboLocation *)location {
    if(_mNewContactChooser != USERLIST_MESSAGE_MODE)
        return;
    if(!params) return; // if location update
    [self addNewMessage:params message:LOCATION_STRING];
    [self updateUiIfLastMessage:params];
}

-(void) Mesibo_OnMessageStatus:(MesiboParams *)params {
    if(_mNewContactChooser != USERLIST_MESSAGE_MODE)
        return;
    
    if(MESIBO_ORIGIN_REALTIME == params.origin && params.groupid && [params isMessageStatusInProgress]) return;
    
    for(int j=0;j<[mUsersList count];j++) {
        
        MesiboProfile *personz =[mUsersList objectAtIndex:j];
        UserData *oud = (UserData *) [personz getUserData];
        
        if(params.mid == [oud getMid]) {
            
            oud.messageStatus = params.status;
            [oud setDeleted:[params isDeleted]];
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
            UITableViewCell* cell = [_mUsersTableView cellForRowAtIndexPath:indexPath];
            
            UILabel *pInfo = (UILabel*)[cell viewWithTag:102];
            [self setUserRow:[MesiboImage getStatusIcon:params.status] WithText:[oud getLastMessage] OnLabel:pInfo];
            
        }
    }
}

-(void) Mesibo_OnConnectionStatus:(int)status {
    //NSLog(@"OnConnectionStatus status: %d", status);
    
    if(status == MESIBO_STATUS_ONLINE) {
        [self updateContactsSubTitle:mMesiboUIOptions.onlineIndicationTitle];
    } else if(status == MESIBO_STATUS_CONNECTING) {
        [self updateContactsSubTitle:mMesiboUIOptions.connectingIndicationTitle];
    } else if(status == MESIBO_STATUS_SUSPEND) {
        [self updateContactsSubTitle:mMesiboUIOptions.suspendedIndicationTitle];
    } else if(status == MESIBO_STATUS_NONETWORK) {
        [self updateContactsSubTitle:mMesiboUIOptions.noNetworkIndicationTitle];
        
    } else if(status == MESIBO_STATUS_SHUTDOWN) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self updateContactsSubTitle:mMesiboUIOptions.offlineIndicationTitle];
    }
}


-(void) Mesibo_onActivity:(MesiboParams *)params activity:(int)activity {
    if(MESIBO_ACTIVITY_TYPING != activity && MESIBO_ACTIVITY_TYPINGCLEARED != activity && MESIBO_ACTIVITY_LEFT != activity) {
        return;
    }
    
    if(!params.profile)
        return;
    
    if(params.groupid && !params.groupProfile)
        return;
    
    MesiboProfile *mp = params.profile;
    if(params.groupProfile)
        mp = params.groupProfile;
    
    UserData *ud = [UserData getUserDataFromProfile:mp];
    
    if(MESIBO_ACTIVITY_LEFT == activity)
        [ud clearTyping];
    else
        [ud setTyping:(params.groupid > 0)?params.profile:nil];
    
    [self refreshTable:[ud getUserListPosition]];
    
}



-(void) updateContacts:(MesiboProfile *) profile {
    if(!profile) {
        [self showUserList:YES];
        return;
    }
    
    
    if(![profile getUserData]) {
        //NSLog(@"No message for %@", profile.name);
        return;
    }
    
    
    UserData *ud = [UserData getUserDataFromProfile:profile];
    if(ud) {
        NSIndexPath *indexPath = [ud getUserListPosition];
        if(!indexPath)
            return;
        
        MesiboProfile *mp = [self getProfileAtIndexPath:indexPath];
        
        // this can only happen when position moved or table refreshd
        if(mp && mp != profile) {
            NSLog(@"====================== Profile at indexpath mismatched\n");
            return;
        }
        
        [self refreshTable:indexPath];
    }
    
    return;
    
}

-(void) Mesibo_onProfileUpdated:(MesiboProfile *)profile {
    
    // check before adding to up thread
    if(profile && ![profile getUserData])
        return;
    
    if([MesiboInstance isUiThread]) {
        [self updateContacts:profile];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateContacts:profile];
        
    });
    
}

-(void) Mesibo_onGroupMembers:(MesiboProfile *) groupProfile members:(NSArray *)members {
    if(_mNewContactChooser != USERLIST_EDIT_GROUP_MODE)
        return;
    
    [mGroupMembers removeAllObjects];
    for(int i=0; i < members.count; i++) {
        MesiboGroupMember *m = members[i];
        MesiboProfile *u = [m getProfile];
        [mGroupMembers addObject:u];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateContacts:nil];
        
    });
}

-(void) updateContactsSubTitle :(NSString *)status {
    
    if(status.length ==0) {
        
        mUserStatusLbl.hidden = YES;
        mUserStatusLbl.text = @"";
        
        [UIView animateWithDuration:0.2 delay:1.0 options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             mUserNameLbl.frame = mHideUserStatusFrm;
                         }
                         completion:^(BOOL finished){
                         }];
        
    }else {
        
        mUserStatusLbl.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             mUserNameLbl.frame = mShowUserStatusFrm;
                         }
                         completion:^(BOOL finished){
                             
                             mUserStatusLbl.hidden = NO;
                             mUserStatusLbl.text = status;
                             
                         }];
        
    }
}

-(NSSet *) getGroupMembers:(NSString*) members {
    if(!members)
        return nil;
    
    NSArray *s = [members componentsSeparatedByString: @":"];
    if(!s || s.count < 2)
        return nil;
    
    NSArray *users = [s[1] componentsSeparatedByString: @","];
    if(!users)
        return nil;
    
    return [NSSet setWithArray:users];
}


- (void) showUserList:(BOOL)animated {
    int b = [MesiboInstance getConnectionStatus];
    [self Mesibo_OnConnectionStatus:b];
    
    [MesiboCommonUtils setNavigationBarColor:self.navigationController.navigationBar color:mPrimaryColor];
    
    if(_mNewContactChooser == USERLIST_MESSAGE_MODE) {
        mTotalUnreadCount = 0;
        [mUsersList removeAllObjects];
        [self.tableView reloadData];
        
        [MesiboInstance addListener:self];
        
        if(mReadSession)
            [mReadSession endSession];
        
        // end all sessions so that they do not send read receipts
        [MesiboReadSession endAllSessions];
        
        mReadSession = [MesiboReadSession new];
        [mReadSession initSession:nil groupid:0 query:nil delegate:self];
        [mReadSession enableSummary:YES];
        
        int rc = [mReadSession read:USERLIST_READ_MESSAGE_COUNT];
        if(0 == rc) {
            
        }
        
    }else {
        
        
        MesiboProfile *mp;
        NSMutableArray *tempArray = (NSMutableArray *)[MesiboInstance getSortedProfiles];
        mUsersList = [tempArray mutableCopy];
        
        if(mUsersList.count > 0) {
            for(int i=(int)(mUsersList.count-1);  i >= 0; i--) {
                MesiboProfile *profile= [mUsersList objectAtIndex:i];
                
                [profile setMark:NO];
                
                if([profile getGroupId] == 0  && (nil == [profile getAddress] || [profile getAddress].length == 0 ))
                    [mUsersList removeObject:profile];
                else if(_mNewContactChooser == USERLIST_SELECTION_GROUP || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE) {
                    if([profile getGroupId] > 0)
                        [mUsersList removeObject:profile];
                    
                }
            }
        }
        
        
        if(_mNewContactChooser == USERLIST_CONTACTS_MODE && [mMesiboUIOptions.createGroupTitle length] > 0) {
            mp = [[MesiboProfile alloc] init];
            [mp setName:mMesiboUIOptions.createGroupTitle];
            NSString *imageFile = [[MesiboCommonUtils getBundle] pathForResource :[NSString stringWithFormat:@"group"] ofType:@"png"];
            [mp setImageFromFile:imageFile];
            [mp setLookedup:YES];

            UserData *od = [[UserData alloc] init];
            od.lastMessage=CREATE_NEW_GROUP_DISCRIPTION;
            [od setUnreadCount:0];
            [od setFixedImage:YES];
            [od setThumbnail:[MesiboImage getDefaultGroupImage]];
            [mp setUserData:od];
            mp.status =@"Create a new group?";
            [mUsersList insertObject:mp atIndex:0];
        }
        
        if(_mNewContactChooser == USERLIST_FORWARD_MODE  ) {
            
            [mUtilityArray removeAllObjects];
            [mCommonNFilterArray removeAllObjects];
            if(mMesiboUIOptions.showRecentInForward)
                mUtilityArray = [[MesiboInstance getRecentProfiles] mutableCopy];
            mCommonNFilterArray = [mUsersList mutableCopy];
            
        }
        
        if(mGroupMembers && mGroupMembers.count > 0 && (_mNewContactChooser == USERLIST_SELECTION_GROUP || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE)) {
            for(int i=0; i < mGroupMembers.count;  i++) {
                MesiboProfile *profile= [mGroupMembers objectAtIndex:i];
                [profile setMark:YES];
            }
            
            // when we return from createNewGroup, it may again pass the same
            if(mUtilityArray != mGroupMembers)
                [mUtilityArray removeAllObjects];
            
            [mCommonNFilterArray removeAllObjects];
            
            mUtilityArray = [mGroupMembers mutableCopy];
            mCommonNFilterArray = [mUsersList mutableCopy];
            
        }
        
        [_mUsersTableView reloadData];
        
    }
}

-(IBAction)barButtonBackPressed:(id)sender {
    if(_mNewContactChooser == USERLIST_FORWARD_MODE || _mNewContactChooser == USERLIST_SELECTION_GROUP || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE) {
        for(int i=0;  i< mUsersList.count; i++) {
            MesiboProfile *profile= [mUsersList objectAtIndex:i];
            [profile setMark:NO];
            
        }
    }
   
    if(_mNewContactChooser == USERLIST_MESSAGE_MODE && self.parentViewController && !self.parentViewController.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
   
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if(_mNewContactChooser == USERLIST_FORWARD_MODE || USERLIST_EDIT_GROUP_MODE == _mNewContactChooser) {
        if (section==0)
            return  [mUtilityArray count];
        else
            return [mCommonNFilterArray count];
    }
    
    if (section==0) {
        if ([self isSearching])
            return  [mUtilityArray count];
        else
            return [mUsersList count];
    }else if (section==1) {
        return [mCommonNFilterArray count];
    }
    else
        return 0;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    if(_mNewContactChooser == USERLIST_FORWARD_MODE  ) {
        if(mMesiboUIOptions.showRecentInForward)
            mUtilityArray = [[[MesiboInstance getRecentProfiles] filteredArrayUsingPredicate:resultPredicate] mutableCopy];
        mCommonNFilterArray = [[mUsersList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    } else {
        mUtilityArray = [[mUsersList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
}



- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    
    NSString *searchString = aSearchController.searchBar.text;
    //NSLog(@"searchString=%@", searchString);
    [self filterContentForSearchText:searchString
                               scope:[[self.searchController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    if(![searchString isEqualToString:@""] && _mNewContactChooser==USERLIST_MESSAGE_MODE) {
        mIsMessageSearching = YES;
        [mCommonNFilterArray removeAllObjects];
        //Don't set SUMMARY flag for search
        if(mReadSession)
            [mReadSession stop];
        
        mReadSession = [MesiboReadSession new];
        [mReadSession initSession:nil groupid:0 query:searchString delegate:self];
        
        [mReadSession read:50];
        
    }else {
        mIsMessageSearching = NO;
        [self showUserList:YES];
        
    }
    [_mUsersTableView reloadData];
    
    
    return ;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    
    mIsMessageSearching = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [mUtilityArray removeAllObjects];
        [mCommonNFilterArray removeAllObjects];
        if(mMesiboUIOptions.showRecentInForward)
            mUtilityArray = [[MesiboInstance getRecentProfiles] mutableCopy];
        mCommonNFilterArray = [mUsersList mutableCopy];
        [self refreshTable];
        //[_mUsersTableView reloadData];
        
    });
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.searchController setActive:NO];
    
    [self showUserList:animated];
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    [MesiboInstance setAppInForeground:self screenId:0 foreground:YES];
    int b = [MesiboInstance getConnectionStatus];
    [self Mesibo_OnConnectionStatus:b];
    NSLog(@"viewDidAppear: userviewcontroller: %d", b);
    
}

-(void) viewDidDisappear:(BOOL)animated {
    //[MesiboInstance setAppInForeground:self screenId:0 foreground:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(_mNewContactChooser == USERLIST_FORWARD_MODE || USERLIST_EDIT_GROUP_MODE == _mNewContactChooser) {
        
        if(mUtilityArray.count==0)
            return 0;
        else
            return SECTION_CELL_HEIGHT;
        
    }
    
    if(!mIsMessageSearching) {
        return  0;
    } else {
        
        if(mUtilityArray.count==0 && section==0)
            return 0;
        if(mCommonNFilterArray.count==0 &&  section==1)
            return 0;
    }
    
    return SECTION_CELL_HEIGHT;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, SECTION_CELL_HEIGHT);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor getColor:BACKGROUND_SEARCH_SECTION_HEAD];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    if(_mNewContactChooser == USERLIST_FORWARD_MODE || USERLIST_EDIT_GROUP_MODE == _mNewContactChooser) {
        if(section==0) {
            if(_mNewContactChooser == USERLIST_FORWARD_MODE)
                label.text = RECENT_USERS_STRING;
            else
                label.text = GROUP_MEMBERS_STRING;
            
        } else {
            label.text = ALL_USER_LIST_STRING;
            
        }
        
        
    } else {
        
        if(section==0) {
            
            if([mUtilityArray count]==0)
                label.text = @"";
            else
                label.text = [NSString stringWithFormat:SEARCH_USERS_STRING, (int)[mUtilityArray count]];
            
            
        }
        else {
            if([mCommonNFilterArray count]==0)
                label.text = @"";
            else
                label.text = [NSString stringWithFormat:SEARCH_MESSAGES_STRING,(int) [mCommonNFilterArray count]];
            
        }
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    label.center = view.center;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    return  view;
    
}

-(void)onTypingTimer:(NSTimer *)timer {
    MesiboProfile *mp = (MesiboProfile *) [timer userInfo];
    if(!mp)
        return;
    
    UserData *oud = [UserData getUserDataFromProfile:mp];
    NSIndexPath *index = [oud getUserListPosition];
    if(index)
        [self refreshTable:index];
}

-(BOOL) isSearching {
    return (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]);
}

#pragma mark - Table view data source

-(void) updateCell:(UITableViewCell *)cell index:(NSIndexPath *)indexPath {
    MesiboProfile *mp = [self getProfileAtIndexPath:indexPath];
    
    if(!mp) {
        NSLog(@"Nil profile in updateCell");
        return;
    }
   
    UILabel *pName = (UILabel*)[cell viewWithTag:101];
    
    NSString *name = [mp getName];
    if(!name || !name.length) {
        if([mp getAddress])
            name = [mp getAddress];
        else
            name = [NSString stringWithFormat:@"Group %u", [mp getGroupId]];
    }
    
    pName.text = name;
    
    UIImageView *pImage = (UIImageView *)[cell viewWithTag:100];
    [pImage layoutIfNeeded];
    
    UserData *ud = [UserData getUserDataFromProfile:mp];
    [ud setUserListPosition:indexPath];
    
    UIImage *profileImage = [ud getThumbnail];
    
    if(!profileImage) {
        profileImage = [ud getDefaultImage:mMesiboUIOptions.useLetterTitleImage];
        [ud setThumbnail:profileImage];
    }
    
    
    [pImage setImage:profileImage];
    pImage.layer.cornerRadius = pImage.frame.size.width/2;
    pImage.layer.masksToBounds = YES;
    //pImage.image = [self imageNamed:mp.picturePath];
    NSString *messageDetail ;
    
    if(_mNewContactChooser != USERLIST_MESSAGE_MODE) {
        
        UILabel *pInfo = (UILabel*)[cell viewWithTag:102];
        pInfo.text = @"";
        //[self setImageIcon:nil WithText:mp.status OnLabel:pInfo];
        UILabel *alertInfo = (UILabel*)[cell viewWithTag:105];
        UILabel *timeDetails = (UILabel*)[cell viewWithTag:104];
        alertInfo.alpha = 0;
        timeDetails.alpha=0;
        if([mp getStatus])
            pInfo.text = [mp getStatus];
        messageDetail = [mp getStatus];
        
    }else {
        
        //messageDetail = ((OtherUserData *)(mp.other)).lastMessage;
        UserData *oud = [UserData getUserDataFromProfile:mp];
        messageDetail = [oud getLastMessage];
        
        UILabel *timeDetails = (UILabel*)[cell viewWithTag:104];
        timeDetails.text = [oud getTime];
        
        UILabel *alertInfo = (UILabel*)[cell viewWithTag:105];
        
        int newMessage = [oud getUnreadCount];
        
        //newMessage = 1;
        if(newMessage) {
            alertInfo.hidden = NO;
            [alertInfo layoutIfNeeded];
            //int radius = alertInfo.frame.size.height/2;
            alertInfo.layer.cornerRadius = alertInfo.frame.size.height/2;
            alertInfo.layer.masksToBounds = YES;
            alertInfo.text = [NSString stringWithFormat:@"%d",newMessage];
            
        } else {
            alertInfo.hidden = YES;
        }
        
        int status = [oud getMessageStatus];
        
        UILabel *pInfo = (UILabel*)[cell viewWithTag:102];
        
        BOOL typing = [ud isTyping];
        
        if(typing) {
            [pInfo setTextColor:mTypingColor];
            
            NSString *typingText = STATUS_TYPING;
            MesiboProfile *typingProfile = [ud getTypingProfile];
            
            if(typingProfile) {
                NSString *name = [typingProfile getName];
                if(!name)
                    name = [typingProfile getAddress];
                
                typingText = [NSString stringWithFormat:@"%@ is %@", name, STATUS_TYPING];
            }
            
            [pInfo setText:typingText];
            
        } else {
            [pInfo setTextColor:mStatusColor];
            [self setUserRow:[MesiboImage getStatusIcon:status] WithText:messageDetail OnLabel:pInfo];
        }
        
        [pInfo sizeToFit];
        
    }
    
    if(_mNewContactChooser ==USERLIST_FORWARD_MODE || _mNewContactChooser == USERLIST_SELECTION_GROUP || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE) {
        
        if(cell.accessoryView == nil) {
            
            UIImageView *accView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            if([mp isMarked]) {
                accView.image = [MesiboImage getCheckedImage];
            }else{
                accView.image = [MesiboImage getUnCheckedImage];
            }
            [accView setTag:33];
            cell.accessoryView = accView;
            
        }else {
            
            UIImageView *accView = (UIImageView *)[cell.accessoryView viewWithTag:33];
            if([mp isMarked]) {
                accView.image = [MesiboImage getCheckedImage];
            }else{
                accView.image = [MesiboImage getUnCheckedImage];
            }
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString * resueIdentifier = @"cells";
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:resueIdentifier];
    if(cell==nil) {
        cell   = [[UITableViewCell alloc]
                  initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:resueIdentifier];
        
    }
    
    [self updateCell:cell index:indexPath];
    
    return cell;
}

-(NSString *)trim:(NSString *)string {
    return [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//TBD, here some crashs
-(void)setUserRow:(UIImage*)statusImage WithText:(NSString*)strText OnLabel:(UILabel *)lbl{
    if(!strText) {
        strText = @"";
    }
    
    if(!lbl) {
        NSLog(@"Should not happen");
        return;
    }
    
    NSTextAttachment *messageStatus = [[NSTextAttachment alloc] init];
    NSTextAttachment *messageType = [[NSTextAttachment alloc] init];
    
    NSString *text = [self trim:strText];
    if([text isEqualToString:[self trim:MESSAGEDELETED_STRING]]) {
        messageType.image = [MesiboImage getDeletedMessageIcon];
        strText = MESSAGEDELETED_STRING;
        statusImage = nil;
    }
    else if([text isEqualToString:[self trim:IMAGE_STRING]])
        messageType.image = [MesiboImage imageNamed:@"ic_photo_18pt" color:USERLIST_ICON_COLOR];
    else if([text isEqualToString:[self trim:VIDEO_STRING]])
        messageType.image = [MesiboImage imageNamed:@"ic_videocam_18pt" color:USERLIST_ICON_COLOR];
    else if([text isEqualToString:[self trim:ATTACHMENT_STRING]])
        messageType.image = [MesiboImage imageNamed:@"ic_attach_file_18pt" color:USERLIST_ICON_COLOR];
    else if([text isEqualToString:[self trim:LOCATION_STRING]])
        messageType.image = [MesiboImage imageNamed:@"ic_location_on_18pt" color:USERLIST_ICON_COLOR];
    else if([text isEqualToString:[self trim:MISSEDVIDEOCALL_STRING]])
        messageType.image = [MesiboImage getMissedCallIcon:YES];
    else if([text isEqualToString:[self trim:MISSEDVOICECALL_STRING]])
        messageType.image = [MesiboImage getMissedCallIcon:NO];
    
    if(messageType.image) {
        messageType.bounds = CGRectIntegral( CGRectMake(0, -3, USERLIST_STATUS_ICON_SIZE, USERLIST_STATUS_ICON_SIZE));
    }
    
    if(statusImage) {
        
        messageStatus.image = statusImage;
        messageStatus.bounds = CGRectIntegral( CGRectMake(0, -3, USERLIST_STATUS_ICON_SIZE, USERLIST_STATUS_ICON_SIZE));
        
    }
    
    NSString* newString = strText;
    
    
    NSMutableAttributedString *attachmentString = nil;
    NSMutableAttributedString *subAttachmentString = nil;
    NSMutableAttributedString *finalString = nil;
    
    
    if(nil != messageStatus)
        attachmentString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:messageStatus]];
    
    if(nil != messageType)
        subAttachmentString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:messageType]];
    
    finalString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *myString = nil;
    if(newString)
        myString= [[NSMutableAttributedString alloc] initWithString:newString];
    //NSMutableAttributedString *space= [[NSMutableAttributedString alloc] initWithString:@"\u00a0\u00a0"];
    //NSMutableAttributedString *space= [[NSMutableAttributedString alloc] initWithString:@"\u00a0"];
    NSMutableAttributedString *space= [[NSMutableAttributedString alloc] initWithString:@""];
    //NSMutableAttributedString *space= [[NSMutableAttributedString alloc] initWithString:@"\u00a0"];
    
    if(statusImage) {
        [finalString appendAttributedString:attachmentString ];
        [finalString appendAttributedString:space ];
    }
    
    if(messageType.image) {
        [finalString appendAttributedString:subAttachmentString ];
        [finalString appendAttributedString:space ];
    }
    
    [finalString appendAttributedString:myString];
    if(lbl)
        lbl.attributedText = finalString;
}

-(MesiboProfile *) getProfileAtIndexPath:(NSIndexPath *)indexPath {
    MesiboProfile *mp = nil;
    
    @try {
        
        if(_mNewContactChooser == USERLIST_FORWARD_MODE || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE ) {
            
            if(indexPath.section == 0) {
                if(mUtilityArray.count > indexPath.row)
                    mp =[mUtilityArray objectAtIndex:indexPath.row];
            }
            else {
                if(mCommonNFilterArray.count > indexPath.row)
                    mp =[mCommonNFilterArray objectAtIndex:indexPath.row];
            }
            
            
        } else {
            //mp =[mUsersList objectAtIndex:indexPath.row];
            if ([self isSearching]) {
                if(indexPath.section==0)
                    mp =[mUtilityArray objectAtIndex:indexPath.row];
                else
                    mp =[mCommonNFilterArray objectAtIndex:indexPath.row];
            }else {
                if(mUsersList.count > indexPath.row)
                    mp =[mUsersList objectAtIndex:indexPath.row];
            }
            
        }
    } @catch(NSException *e) {
        mp = nil;
        NSLog(@"Exception getProfileAtIndexPath: mode %d searching %d section %d %@", _mNewContactChooser, [self isSearching]?1:0, (int) indexPath.section, e);
    }
    
    
    return mp;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MesiboProfile *mp = [self getProfileAtIndexPath:indexPath];
    
    if(self.mNewContactChooser== USERLIST_FORWARD_MODE || _mNewContactChooser == USERLIST_SELECTION_GROUP || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *accView = (UIImageView *)[cell.accessoryView viewWithTag:33];
        
        if([mp isMarked]) {
            accView.image = [MesiboImage getUnCheckedImage];
        }else{
            accView.image = [MesiboImage getCheckedImage];
        }
        [mp toggleMark];
        
        [_mUsersTableView reloadData];
        return;
    }
    
    if(mMesiboUIOptions.createGroupTitle && [[mp getName] isEqualToString:mMesiboUIOptions.createGroupTitle]){
        [MesiboUIManager launchUserListViewcontroller:self  withChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"] withContactChooser:USERLIST_SELECTION_GROUP withForwardMessageData:nil withMembersList:nil withForwardGroupName:nil withForwardGroupid:0];
        return;
    }
    
    // TBD, don't directly use mp as it may be locally allocated due to bad search implementation
    mp = [MesiboInstance getProfile:[mp getAddress] groupid:[mp getGroupId]];
    
    [MesiboUIManager launchMessageViewController:self withUserData:mp uidelegate:_mUiDelegate];
    self.searchController.active = NO;
    
}


-(void)tableView:(UITableView *)tableView didDeSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.mNewContactChooser==USERLIST_FORWARD_MODE || _mNewContactChooser == USERLIST_SELECTION_GROUP || _mNewContactChooser == USERLIST_EDIT_GROUP_MODE) {
        //cv.forwardedMesage = _fwdMessage;
        MesiboProfile *mp;
        if ([self isSearching]) {
            mp =[mUtilityArray objectAtIndex:indexPath.row];
            
        }else {
            mp =[mUsersList objectAtIndex:indexPath.row];
        }
        
        [mp setMark:NO];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *accView = (UIImageView *)[cell.accessoryView viewWithTag:33];
        accView.image = [MesiboImage getUnCheckedImage];
        
    }
    return;
    
}

-(void) forwardToContact:(MesiboProfile *) profile {
    [profile setMark:NO];
    MesiboParams *mesiboParamsUser = (MesiboParams *) [[MesiboParams alloc] init];
    
    if([profile getGroupId])
        [mesiboParamsUser setGroup:[profile getGroupId]];
    else
        [mesiboParamsUser setPeer:[profile getAddress]];
    
    for(NSNumber *msgid in _fwdMessage) {
        [MesiboInstance forwardMessage:mesiboParamsUser msgid:[MesiboInstance random] forwardid:[msgid unsignedLongLongValue]];
    }
    
}

-(void) forwardMessageToContacts {
    
    MesiboProfile *profile = nil, *forwardTo = nil;
    int count = 0;
    for(int i=0;  i< mUtilityArray.count; i++) {
        profile= [mUtilityArray objectAtIndex:i];
        
        if([profile isMarked]) {
            forwardTo = profile;
            [self forwardToContact:profile];
            //NSArray *p = [MesiboInstance getRecentProfiles];
            count++;
        }
    }
    
    
    for(int i=0;  i< mCommonNFilterArray.count; i++) {
        profile= [mCommonNFilterArray objectAtIndex:i];
        if([profile isMarked]) {
            forwardTo = profile;
            [self forwardToContact:profile];
            //NSArray *p = [MesiboInstance getRecentProfiles];
            count++;
        }
    }
    
    if(!count) {
        [MesiboUIAlerts showDialogue:FORWARD_ALERT_MESSAGE withTitle:FORWARD_ALERT_TITLE];
    } else {
        
        if(count > 1) {
            [self.navigationController popViewControllerAnimated:NO];
            return;
        }
        
        [MesiboUIManager launchMessageViewController:self withUserData:forwardTo uidelegate:_mUiDelegate];
        
        
        
        //[_mUsersTableView reloadData];
        //[self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

-(void) createNewGroup {
    [mSelectedMembers removeAllObjects];
    
    // We must add members from original array because they won't be in mUserList
    for(int i=0;  i< mGroupMembers.count; i++) {
        MesiboProfile *profile= [mGroupMembers objectAtIndex:i];
        if([profile isMarked]) {
            [profile setMark:NO];
            [mSelectedMembers addObject:profile];
            
        }
    }
    
    
    for(int i=0;  i< mUsersList.count; i++) {
        MesiboProfile *profile= [mUsersList objectAtIndex:i];
        if([profile isMarked]) {
            [profile setMark:NO];
            [mSelectedMembers addObject:profile];
        }
    }
    
    if(![mSelectedMembers count]) {
        [MesiboUIAlerts showDialogue:CREATE_NEW_GROUP_ALERT_MESSAGE withTitle:CREATE_NEW_GROUP_ALERT_TITLE];
        
    } else {

        [MesiboUIManager launchCreatNewGroupController:self withMemeberProfiles:mSelectedMembers existingMembers:mGroupMembers  withGroupId:_mForwardGroupid modifygroup:(_mNewContactChooser == USERLIST_EDIT_GROUP_MODE) uidelegate:_mUiDelegate];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundView = nil;
    
    if(_mNewContactChooser == USERLIST_FORWARD_MODE || USERLIST_EDIT_GROUP_MODE == _mNewContactChooser ||  mIsMessageSearching) {
        int count = 0;
        count += (mUtilityArray.count > 0) ? 1:0;
        count += (mCommonNFilterArray.count > 0) ? 1:0;
        if(count > 0)
            return 2;
        
    } else { //if (_mNewContactChooser == USERLIST_MESSAGE_MODE) {
        if(mUsersList.count > 0)
            return 1;
    }
    
    
    // Display a message when the table is empty
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    messageLabel.text = mMesiboUIOptions.emptyUserListMessage;
    if ([self isSearching])
        messageLabel.text = SEARCH_IS_NOT_AVAILABLE;
    
    messageLabel.textColor = [UIColor getColor:EMPTY_USERLIST_MESAGE_FONT_COLOR];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:EMPTY_USERLIST_MESAGE_FONT_NAME size:EMPTY_USERLIST_MESAGE_FONT_SIZE];
    [messageLabel sizeToFit];
    
    self.tableView.backgroundView = messageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if(_mNewContactChooser==USERLIST_FORWARD_MODE || USERLIST_EDIT_GROUP_MODE == _mNewContactChooser) {
        return NO;
    }
    
    return YES;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:DELETE_TITLE_STRING handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if(_mNewContactChooser != USERLIST_MESSAGE_MODE) {
            MesiboProfile *mp = [mUsersList objectAtIndex:indexPath.row];
            [mUsersList removeObjectAtIndex:indexPath.row];
            [_mUsersTableView beginUpdates];
            [_mUsersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_mUsersTableView endUpdates];
            //[MesiboInstance removeProfile:mp.address groupid:0];
            

            //[MesiboInstance deleteProfile:mp refresh:YES forced:NO];
            
        } else {
            
            // Delete  here
            MesiboProfile *mp = [mUsersList objectAtIndex:indexPath.row];
            
            [mUsersList removeObjectAtIndex:indexPath.row];
            [_mUsersTableView beginUpdates];
            [_mUsersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_mUsersTableView endUpdates];
            [MesiboInstance deleteMessages:[mp getAddress] groupid:[mp getGroupId] ts:0];
            
        }
        
    }];
    
    deleteRow.backgroundColor = [UIColor redColor];
    
    if(_mNewContactChooser != USERLIST_MESSAGE_MODE)
        return @[]; // we don't allow deleting contact, TBD, this should be customizable
    else
        return @[deleteRow];
    
}


-(void)dealloc {
    [_searchController.view removeFromSuperview]; // It works!
}
@end







