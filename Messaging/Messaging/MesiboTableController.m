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

#import "MesiboTableController.h"

#import "MesiboMessageViewHolder.h"
#import "MesiboImage.h"
#import "MesiboUI.h"

@interface MesiboTableController() {
    UITableView *mTable;
    MesiboMessageModel *mModel;
    BOOL mSendEnabled;
    __weak id mListener;
    __weak id mUiListener;
    __weak UIViewController * mParent;
    BOOL mScrolledToLatestOnce;
    MesiboMessageViewHolder *mHeightCalculator;
    
    NSMutableDictionary *mSelectedMessages;
    NSArray *mSelectActionButton;
    UIButton *mSelectButton;
    int mSelectionMode;
    MesiboMessageScreen *mScreen;
    MesiboMessageRow *msgrow;
}
@end


@implementation MesiboTableController

-(id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    mTable = nil;
    mModel = nil;
    mSendEnabled = YES;
    mScrolledToLatestOnce = NO;
    mHeightCalculator = nil;
    mSelectionMode = SELECTION_NONE;
    mSelectButton = nil;
    mScreen = nil;
    msgrow = [MesiboMessageRow new];

    return self;
}

-(void) setTable:(UITableView *)table {
    
    
}

-(void) setup:(id)parent screen:(MesiboMessageScreen *)screen model:(MesiboMessageModel *)model delegate:(id)delegate uidelegate:(id)uidelegate {
    mModel = model;
    mTable = screen.table;
    mScreen = screen;
    
    mListener = delegate;
    mUiListener = uidelegate;
    mParent = parent;
    
    if(![delegate conformsToProtocol:@protocol(MesiboTableControllerDelegate)]) {
        //[NSException raise:@"MesiboDelegateException" format:@"MesiboTableControllerDelegate not implemented"];
    }
    
}

-(void) start {
    
}

-(void) stop {
    
}

-(void) enableSend:(BOOL)enable {
    mSendEnabled = enable;
}

-(void) insert:(MesiboMessage *)message {
    if([message isRealtimeMessage]) {
        CGPoint offset1 = mTable.contentOffset;
        if(offset1.y > 35) {
            offset1.y -=35; // one line offset to notify user about new message has come
            [mTable setContentOffset:offset1 animated:YES];
        }
    }
}


-(void)insertInTable:(NSInteger)row section:(NSInteger)section  {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [mTable beginUpdates];
    if(section > 0) {
        //[mTable insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [mTable insertRowsAtIndexPaths:@[indexPath]
                  withRowAnimation:UITableViewRowAnimationTop];
    [mTable endUpdates];
    
}

-(void)insertInTable:(NSInteger)row section:(NSInteger)section showLatest:(BOOL)showLatest animate:(BOOL)animate {
    animate = NO;
    if(!animate) {
        [self insertInTable:row section:section];
        if(showLatest)
            [self scrollToLatestChat:YES];
        return;
    }
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self insertInTable:row section:section];
        }
     
        completion:^(BOOL finished) {
            // completion code
            if(showLatest) {
                [self scrollToLatestChat:YES];
                [self scrollToBottom:YES];
            }
        }
     ];
    
}


-(void) reloadTable:(BOOL)scrollToLatest {
    
    [MesiboInstance runInThread:YES handler:^{
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if(!mScrolledToLatestOnce) {
                [self scrollToLatestChat:YES];
                [self scrollToBottom:NO];
            }
        }];
        [mTable reloadData];
        [CATransaction commit];
        
    }];
}


-(void) reload:(MessageData *) m {
    MesiboMessageViewHolder *vh = [m getViewHolder];
    if(!vh) return;
    
    NSIndexPath *nip = [mTable indexPathForCell:vh];
    if(nil == nip)
        return;
    
    [mTable beginUpdates];
    [mTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:nip] withRowAnimation:UITableViewRowAnimationNone];
    [mTable endUpdates];
}

-(void) reloadRows:(NSArray *)rows {
    
    NSMutableArray *nip = [NSMutableArray new];
    
    for(NSNumber *r in rows) {
        NSIndexPath *i = [NSIndexPath indexPathForRow:[r integerValue] inSection:0];
        [nip insertObject:i atIndex:[nip count]];
    }
    
    [mTable beginUpdates];
    [mTable reloadRowsAtIndexPaths:nip withRowAnimation:UITableViewRowAnimationNone];
    [mTable endUpdates];
}

-(void) reloadRows:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *nip = [NSMutableArray new];
    
    for(; start <= end; start++) {
        NSIndexPath *i = [NSIndexPath indexPathForRow:start inSection:0];
        [nip insertObject:i atIndex:[nip count]];
    }
    
    [mTable beginUpdates];
    [mTable reloadRowsAtIndexPaths:nip withRowAnimation:UITableViewRowAnimationNone];
    [mTable endUpdates];
}

- (void) reloadRow:(NSInteger)row {
    [self reloadRows:row end:row];
}

-(void) updateMessageStatus:(int) row status:(int)status {
    MesiboMessageViewHolder *vh = [self getViewHolder:row];
    if(!vh) return;
    [vh updateStatusIcon:status];
}

-(MesiboMessageViewHolder *) getViewHolder:(int) row {
    NSIndexPath *pip = [NSIndexPath indexPathForRow:row inSection:0];
    MesiboMessageViewHolder* cell = [mTable cellForRowAtIndexPath:pip];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return mDisplayMsgCnt;
    return [mModel count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    if (c.accessoryType == UITableViewCellAccessoryCheckmark) {
        [c setAccessoryType:UITableViewCellAccessoryNone];
    }
}

-(void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    // if you have an accessory view
    cell.accessoryView.transform = CGAffineTransformMakeScale (1,-1);
    
    return;
    
#if 0
    // Set the cells background color
    if ([self isRowZeroVisible] /*&& isEarlierMessageInDB */) {
        _loadEarlyMessageBtn.alpha = 1;
        
    }else {
        _loadEarlyMessageBtn.alpha = 0;
        
        
    }
    
    if([indexPath row] == [[self.mMessageList indexPathForLastMessage] row]){
        //end of loading
        //for example [activityIndicator stopAnimating];
        [self scrollToBottom:NO];
    }
#endif
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = (int) [indexPath row];
    
    MessageData *message = [mModel get:row];
    
    //if(MESSAGEVIEW_TIMESTAMP == [message getType])
      //  return MESSAGE_DATE_SECTION_HEIGHT;
    
    CGFloat height = [message getHeight];
    if(height > 0.1) {
        return height;
    }
    
    if(mUiListener) {
        MesiboMessage *m = [message getMesiboMessage];
    
        [msgrow reset];
        msgrow.message = m;
        
        CGFloat height = [mUiListener MesiboUI_onGetCustomRowHeight:mScreen row:msgrow];
        
        if(height >= 0) {
            [message setHeight:height];
            return height;
        }
    }
    
    // we are using a dummy cell for heigh calculation.
    // TBD, later reuse this cell so that it can be directly assigned
    if(!mHeightCalculator) {
        mHeightCalculator =  [[MesiboMessageViewHolder alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"height"];
    }
    
    [mHeightCalculator setMessage:message indexPath:nil];
    return [message getHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = (int) [indexPath row];
    MesiboMessage *msg = [[mModel get:row] getMesiboMessage];
    
    if(mUiListener) {
        [msgrow reset];
        msgrow.message = msg;
        
        UITableViewCell *cell = [mUiListener MesiboUI_onGetCustomRow:mScreen row:msgrow];
        
        //custom delegate can return null
        if(cell)
            return cell;
    }
    
    MesiboMessageViewHolder *cell = [tableView dequeueReusableCellWithIdentifier:MESIBO_CELL_IDENTIFIER];
    if (!cell) {
        cell = [[MesiboMessageViewHolder alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MESIBO_CELL_IDENTIFIER];
    }
    
    [cell setTableController:self];
    
    MessageData *old = [cell getMessage];
    
    if(old && [old getViewHolder] == cell)
        [[cell getMessage] setViewHolder:nil];
    
    MessageData *m = [mModel get:row];
    
    [cell setMessage:m indexPath:indexPath];
    
    [[cell getMessage]  setViewHolder:cell];
    
    [cell setParent:mParent];
    
    cell.accessoryView = [cell getAccessoryView];
    
    if(mUiListener) {
        
        [msgrow reset];
        msgrow.row = cell;
        msgrow.message = msg;
        [cell setMesiboRow:msgrow];
        [mUiListener MesiboUI_onUpdateRow:mScreen row:msgrow last:YES];
    }
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(mSelectionMode)
        return NO;
    
    if(mUiListener) {
        
    }
    
    /* Allow the context menu to be displayed on every cell */
    
    return YES;
}

- (BOOL) tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    if (action == @selector(delete:) || action == @selector(copy:) || action == @selector(resend:)
        || action == @selector(forward:) || action == @selector(share:)){
        return YES;
    }
    
    return NO;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSLog(@"Content %@ %f,%f", @(currentOffset), co.x, co.y);
    
    /*
     if(currentOffset < 1000.0) {
     [self loadMoreMessages];
     }
     */
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 100.0) {
        //MesiboTableControllerDelegate *l = (MesiboTableControllerDelegate *)mListener;
        if(![mListener loadMessages]) {
        }
    }
}

- (void) scrollToBottom:(BOOL)animated {
    if([mModel count] == 0) return;
    
    [mTable setContentOffset:CGPointZero animated:animated];
    return;
    
}

- (void)scrollToLatestChat:(BOOL)animation {
    if([mModel count] == 0) return;
    
    mScrolledToLatestOnce = YES;
    
    [mTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  atScrollPosition:UITableViewScrollPositionTop animated:animation];
}

-(void)share :(id) sender {
    
        MesiboMessageViewHolder *cell = sender;
        
        NSString *text = [[cell getMessage] getMessage];
        
        NSMutableArray *sharingItems = [NSMutableArray new];
        
        if (text) {
            [sharingItems addObject:text];
        }
    
        if ([[cell getMessage]  hasThumbnail]) {
            MessageData *mv = [cell getMessage];
            NSString *path = [mv getPath];
            UIImage *image = [mv getImage];
            
            if(image) [sharingItems addObject:image];
            else if(path) {
                NSURL *url = [NSURL fileURLWithPath:path];
                [sharingItems addObject:url];
            }
            //[sharingItems addObject:[[cell getMessage]  getImage]];
        }

        /* TBD, temporarily disabled
         if (cell.message.mImagePath) {
         [sharingItems addObject:cell.message.mImagePath];
         }
         */
        //[mListener share:<#(id)#>]
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
        [mParent presentViewController:activityController animated:YES completion:nil];
    
}

-(BOOL) isSelected:(id)data {
    if(SELECTION_NONE == mSelectionMode || !data)
        return NO;
    
    MessageData *message = (MessageData *) data;
    uint64_t mid = [message getMid];
    if(!mid) return NO;
    
    NSNumber *key = @(mid);
    // remove object if exist, else add it - select unselect
    MessageData *m = [mSelectedMessages objectForKey:key];
    if(m) return YES;
    return NO;
}

-(void) addSelectedMessage:(id)data {
    
    if(SELECTION_NONE == mSelectionMode)
        return;
    
    MessageData *message = data;
    
    NSNumber *key = @([message getMid]);
    MessageData *m = [mSelectedMessages objectForKey:key];
    if(m) {
        [mSelectedMessages removeObjectForKey:key];
    } else {
        //restrict number of messages in forward mode (but not in multiple delete mode)
        if(SELECTION_FORWARD == mSelectionMode && [mSelectedMessages count] >= 10)
            return;
        
        [mSelectedMessages setObject:message forKey:key];
    }
    
    [self reload:message];
    //[self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:mIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(BOOL) isSelectionMode {
    return (mSelectionMode != SELECTION_NONE);
}


-(void) createSelectButton {
    if(mSelectButton) return;

    mSelectButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [mSelectButton setImage:[MesiboImage imageNamed:@"ic_forward_white.png"] forState:UIControlStateNormal];
    [mSelectButton addTarget:self action:@selector(onSelectedMessagesAction:)forControlEvents:UIControlEventTouchUpInside];
    [mSelectButton setFrame:CGRectMake(0, 0, UIBAR_BUTTON_SIZE, UIBAR_BUTTON_SIZE)];
    UIBarButtonItem *selectButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mSelectButton];

    mSelectActionButton = @[selectButtonItem];

}

//TBD, move this into delegate
-(void) startSelectionMode:(id)sender mode:(int)mode {
    mSelectionMode = mode;
    
    [self createSelectButton];
    UIImage *image;
    if(SELECTION_FORWARD == mode)
        image = [MesiboImage imageNamed:@"ic_forward_white.png"];
    else
        image = [MesiboImage imageNamed:@"ic_delete_white.png"];
    
    [mSelectButton setImage:image forState:UIControlStateNormal];
    
    [mListener enableSelectionActionButtons:YES buttons:mSelectActionButton];
    
    //mParent.navigationItem.rightBarButtonItems = mSelectActionButton;
    
    mSelectedMessages = [NSMutableDictionary new];
    
    MesiboMessageViewHolder *cell = sender;
    [cell clicked];
    
    // we have to reload data as all cells needs to be updated
    [mTable reloadData];
}

-(void) deleteSelectedMessages:(BOOL) remote {
    uint64_t ids[32];
    int count = 0;
    for (id key in mSelectedMessages) {
        MessageData *m = [mSelectedMessages objectForKey:key];
        ids[count++] = [m getMid];
        
        [mModel deleteMessage:m remote:remote refresh:NO];
        
        if(count == 32) {
            if(remote) {
                [MesiboInstance wipeAndRecallMessages:ids count:count];
            } else {
                [MesiboInstance deleteMessages:ids count:count];
            }
            count = 0;
        }
    }
    
    if(count > 0) {
        if(remote) {
            [MesiboInstance wipeAndRecallMessages:ids count:count];
        } else {
            [MesiboInstance deleteMessages:ids count:count];
        }
    }
    
    [self cancelSelectionMode];
    //uint64_t mmid = [self.mMessageList removeMessageFromMessageData:indexPath];
    //int rv = [MesiboInstance deleteMessage:mmid];
    
}

-(UIAlertAction *) addDeleteAlert:(UIAlertController *)view title:(NSString *)title type:(int) type {
    return [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
        if(type >= 0)
            [self deleteSelectedMessages:(type >0)];
        else
            [self cancelSelectionMode];
            
        
        //Do some thing here
        [view dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void) promptAnddeleteMessage {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    MesiboUiDefaults *opt = [MesiboUI getUiDefaults];
    
    UIAlertAction* forall = [self addDeleteAlert:view title:opt.deleteForEveryoneTitle type:1];
    UIAlertAction* forme = [self addDeleteAlert:view title:opt.deleteForMeTitle type:0];
    UIAlertAction* cancel = [self addDeleteAlert:view title:opt.cancelTitle type:-1];
    
    [view addAction:forall];
    [view addAction:forme];
    [view addAction:cancel];
    [mParent presentViewController:view animated:YES completion:nil];
}

-(IBAction) onSelectedMessagesAction:(id)sender {
    
    if(SELECTION_DELETE == mSelectionMode) {
        
        int maxInterval = [MesiboInstance getMessageRetractionInterval];
        BOOL deleteForAll = YES;
        //TBD, we just need to check oldest message, not all
        for (id key in mSelectedMessages) {
            MessageData *m = [mSelectedMessages objectForKey:key];
            MesiboMessage *mm = [m getMesiboMessage];
            
            uint64_t elapsed = (([MesiboInstance getTimestamp] - mm.ts)/1000);
            
            if(![mm isOutgoing] || [mm isFailed] || [mm isDeleted] || elapsed > maxInterval) {
                deleteForAll = NO;
                break;
            }
        }
        
        if(deleteForAll) {
            [self promptAnddeleteMessage];
            //do not cancel selection mode here else selected messages will be gone
            return;
        }
        
        [self deleteSelectedMessages:NO];
        
        //uint64_t mmid = [self.mMessageList removeMessageFromMessageData:indexPath];
        //int rv = [MesiboInstance deleteMessage:mmid];
        [self cancelSelectionMode];
        return;
    }
    
    NSArray *keys = [mSelectedMessages keysSortedByValueUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
        MessageData *s1 = (MessageData *)obj1;
        MessageData *s2 = (MessageData *)obj2;
        MesiboMessage *m1 = [s1 getMesiboMessage];
        MesiboMessage *m2 = [s2 getMesiboMessage];
        if(m1.ts == m2.ts)
            return NSOrderedSame;
        
        // we need loweset timestamp at top
        if(m1.ts > m2.ts)
            return NSOrderedDescending;
        
        return NSOrderedAscending;
    }];
    
    NSMutableArray *vals = [[NSMutableArray alloc] init];
    for (id object in keys) {
        MessageData *d = [mSelectedMessages objectForKey:object];
        MesiboMessage *m = [d getMesiboMessage];
        
        if(![m isRichMessage] || ![m isFileTransferRequired]) {
            [vals addObject:@(m.mid)];
        }
        
        //NSLog(@"%@ %@", @(m.mTimestampMs), m.mMessage);
    }
    
    //Forward messages
    [self cancelSelectionMode];
    
    [mListener forwardMessages:vals];
    
}

-(BOOL) cancelSelectionMode {
    if(SELECTION_NONE == mSelectionMode) return NO;
    
    if(mSelectedMessages) {
        [mSelectedMessages removeAllObjects];
    }
    
    mSelectionMode = SELECTION_NONE;
    [mListener enableSelectionActionButtons:NO buttons:nil];
    //self.navigationItem.rightBarButtonItems = mUserButtons;
    
    [mTable reloadData];
    return YES;

}




-(void)copy :(id) sender {
    
    if([sender isKindOfClass:[MesiboMessageViewHolder class]]) {
        MesiboMessageViewHolder *cell = sender;
        MessageData *m = [cell getMessage];
        
        //NSString *stringText = cell.message.mReplyMess;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if([m hasThumbnail]) {
            pasteboard.image = [m getImage];
        } else {
            pasteboard.string = [m getMessage];
        }
    }
}

- (void)paste:(id)sender {
    NSLog(@"paste hook");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if(nil != pasteboard.string) {
        NSLog(@"pasting text: %@", pasteboard.string);
    }
    else if(nil != pasteboard.image) {
        NSLog(@"pasting image: %@", pasteboard.string);
    }
    
}

-(void)resend :(id) sender {
    
    MesiboMessageViewHolder *cell = sender;
    
    MessageData *m = [cell getMessage];
    MesiboMessage *mm = [m getMesiboMessage];
    
    [mm setStatus:MESIBO_MSGSTATUS_OUTBOX];
    
    
    if([mm isFailed]) {
        [mm resend];
    }
}


- (void)delete:(nullable id)sender {
    
    MesiboMessageViewHolder *cell = sender;
    //NSIndexPath *indexPath = [mTable indexPathForCell:cell];
    [self startSelectionMode:cell mode:SELECTION_DELETE];
}

-(void)forward :(id) sender {
    MesiboMessageViewHolder *cell = sender;
    [self startSelectionMode:cell mode:SELECTION_FORWARD];
}

- (void)favorite:(id)sender {
    MesiboMessageViewHolder *cell = sender;
    MessageData *m = [cell getMessage];
    [m toggleFavourite];
    [mTable reloadData];
}

- (void)reply:(id)sender {
    [mListener reply:sender];
}


// Not in use - only for reference
-(BOOL)isRowZeroVisible {
    NSArray *indexes = [mTable indexPathsForVisibleRows];
    for (NSIndexPath *index in indexes) {
        if (index.row == 0 && index.section==0) {
            return YES;
        }
    }
    
    return NO;
}

@end
