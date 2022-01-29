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

#import "MesiboMessageModel.h"
#import "MesiboMessageViewHolder.h"
#import "MesiboMessageView.h"

@interface MesiboMessageModel ()
{
    MesiboParams *mParams;
    MesiboProfile *mProfile;
    //BOOL mMode;
    BOOL mEnableTimestamp;
    BOOL mEnableMessages;
    BOOL mEnableCalls;
    BOOL mEnableReadReceipt;
    BOOL mReverseOrder;
    BOOL mLastTimestampInserted;
    BOOL mHasMoreMessages;
    NSMutableArray *mList;
    NSMutableDictionary *mMap;
    NSMutableDictionary *mDateMap;
    NSMutableDictionary *mIndexPathMap;
    MesiboReadSession *mReadSession;
    int mLastMessageStatus;
    //MesiboTableController *mTable;
    id mDelegate;
}
@end

@implementation MesiboMessageModel

-(id)init
{
    self = [super init];
    if (self)
    {
        mReadSession = nil;
        
        [self reset];
    }
    return self;
}

-(void) reset {
    mList = [[NSMutableArray alloc] init] ;
    mMap = [[NSMutableDictionary alloc] init];
    mDateMap = [[NSMutableDictionary alloc] init];
    mIndexPathMap = [[NSMutableDictionary alloc] init];
    mParams = nil;
    mHasMoreMessages = YES;
    
    //mMode = MESIBO_MODEL_MESSAGE;
    mEnableTimestamp = YES;
    mEnableMessages = YES;
    mEnableReadReceipt = YES;
    mEnableCalls = YES;
    mReverseOrder = NO;
    mLastTimestampInserted = NO;
    if(mReadSession)
        [mReadSession stop];
    mReadSession = nil;
    mLastMessageStatus  = -1;
}

-(void) setDestination:(MesiboParams *)params {
    mParams = params;
    if(!mParams)
        mEnableTimestamp = NO;
    else {
        mProfile = [MesiboInstance getProfile:mParams.peer groupid:mParams.groupid];
    }
    
    mReadSession = [MesiboReadSession new];
    if(mParams) {
        [mReadSession initSession:mParams.peer groupid:mParams.groupid query:nil delegate:self];
        [mReadSession enableReadReceipt:mEnableReadReceipt];
        [mReadSession enableMissedCalls:mEnableCalls];
    }
    else {
        [mReadSession initSession:nil groupid:0 query:nil delegate:self];
        [mReadSession enableSummary:YES];
    }
    
    [mReadSession start];
    
}

-(void) start {
    [self updateConnectionStatus];
    [MesiboInstance addListener:self];
    if(mReadSession)
        [mReadSession enableReadReceipt:YES];
}

-(void) pause {
    if(mReadSession)
        [mReadSession enableReadReceipt:NO];
}

-(void) stop {
    [MesiboInstance removeListner:self];
    if(mReadSession)
        [mReadSession stop];
}

-(void) updateConnectionStatus {
    int b = [MesiboInstance getConnectionStatus];
    [self Mesibo_OnConnectionStatus:b];
}

-(void) Mesibo_OnSync:(int)count {
    if(count > 0) {
        mHasMoreMessages = YES;
        id thiz = self;
        [MesiboInstance runInThread:YES handler:^{
            [thiz loadMessages:count];
        }];
    }
}
-(BOOL) loadMessages:(int)count {
    if(!mHasMoreMessages)
        return NO;
    
    if(0 == count)
        count = 25;
    
    int rv = [mReadSession read:count];
    
    mHasMoreMessages = NO;
    if(count == rv) {
        mHasMoreMessages = YES;
    } else {
        [mReadSession sync:count listener:self];
    }
    return YES;
}

-(void) setDelegate:(id) delegate {
    mDelegate = delegate;
}

-(void) enableReadReceipt:(BOOL)enable {
    mEnableReadReceipt = enable;
}

-(void) enableTimestamp:(BOOL)enable {
    mEnableTimestamp = enable;
}

-(void) enableCallLogs:(BOOL)enable {
    mEnableCalls = enable;
}

-(void) enableMessages:(BOOL)enable {
    mEnableMessages = enable;
}

-(void) enableReverseOrder:(BOOL)enable {
    mReverseOrder = enable;
}

-(BOOL) isForMe:(MesiboMessage *) m {
    if([m isRealtimeMessage]) {
        //[self updateUserActivity:params activity:MESIBO_ACTIVITY_NONE];
    }
    return [m compare:mParams.peer groupid:mParams.groupid];
}

-(BOOL) isForMeParam:(MesiboParams *) m {
    if([m isRealtimeMessage]) {
        //[self updateUserActivity:params activity:MESIBO_ACTIVITY_NONE];
    }
    return [m compare:mParams.peer groupid:mParams.groupid];
}

-(int) lastStatus {
    return mLastMessageStatus;
}

/* Message mode
 1) insert
 2) if presence, update presence
 
 Message List mode
 1) find and remove the object
 2) insert at top
 3) if presence, update presence but not reshuffle
 */

// check if the message is presence, then start timer instead if replacing
-(void) insert:(MesiboMessage *)m {
    
   //NSString *ms = [m getMessageAsString];
    
    //TBD, should we do it here or let user control it
    if(![m isMissedCall] && 0 != [m getType])
        return;
    
    if([m isDbMessage] && [m isLastMessage]) {
        NSLog(@"last");
    }
    
    //WHY???
    if([m isEmpty]) {
        [mDelegate reloadTable:YES];
        return;
    }
    
    if([m isPresence]) {
        
    }
    
    //happens for real-time
    if([m isCall] && ![m isMissedCall])
        return;
    
    
    // if realtime, add new message at top (0). if from database, bottom
    BOOL reverseOrder = ![m isRealtimeMessage];
    if(mReverseOrder)
        reverseOrder = !reverseOrder;
    
    MesiboMessageView *data = [MesiboMessageView new];
    [data setType:MESSAGEVIEW_MESSAGE];
    [data setMessage:m];
    
    // depending on the order, we add timestamp after or before message
    [self insertTimestamp:data];
    
    MesiboFileInfo *file = nil;
    MesiboLocation *loc = nil;
    
    if([m hasMedia]) {
        file = m.media.file;
        loc = m.media.location;
        
        //TBD, let's do it from VC on need basis
        if(file) {
            //if(file.image==nil) {
            //    file.image = [MesiboImage getFileTypeImage:[file getPath]];
            //}
            
            [file setData:data];
            [file setListener:self];
        }
        
        if(loc) {
            if(loc.update) {
                int i = 0;
                MesiboMessageView *u = nil;
                for(u in mList) {
                    if(m.mid == [u getMid]) {
                        break;
                    }
                    
                    i++;
                }
                
                if(!u) return;
                
                [mDelegate reloadRow:i];
                return;
                /*
                 UiData *c =(UiData *) [location getData];
                 MesiboMessageViewHolder *vU = (MesiboMessageViewHolder *)[c getViewHolder];
                 
                 if(vU != nil ) {
                 vU.chatPicture.image = location.image;
                 [mDelegate reloadData];
                 }
                 
                 */
            } else {
                [loc setData:data];
                //[loc set]
            }
        }
        
    }
    
    if(!reverseOrder) {
        [mList insertObject:data atIndex:0];
    } else {
        [mList insertObject:data atIndex:[mList count]];
        
    }
    
    [self updateMessageMap:m.mid message:data];
    
    if([m isDbMessage] && [m isLastMessage]) {
        MesiboMessageView *data = [MesiboMessageView new];
        [data setType:MESSAGEVIEW_TIMESTAMP];
        [data setMessage:m];
        [mList insertObject:data atIndex:[mList count]];
        mLastTimestampInserted = YES;
        
        [mDelegate reloadTable:YES];
    } else if([m isRealtimeMessage]) {
        [mDelegate insertRow:0];
    }
    
    // if message is being sent - move to bottom
    if([m isInOutbox] && [m isRealtimeMessage]) {
        [mDelegate scrollToBottom:YES];
        if([data getViewHolder] != nil) {
            //TBD
            //[(MesiboMessageViewHolder *)([data getViewHolder]) startProgressBar];
            
        }
    }
    
}

-(void) updateMessageMap:(uint64_t)mid message:(MesiboMessageView *)m {
    if(m) {
        [mMap setObject:m forKey:@(mid)];
    } else {
        [mMap removeObjectForKey:@(mid)];
    }
}

-(void) insertTimestamp:(MesiboMessageView *)m {
     if(!mEnableTimestamp) return;
    
    
    
    MesiboMessage *mm = [m getMesiboMessage];
    MesiboMessageView *lm = nil;
    
    if(![mm isRealtimeMessage] && mLastTimestampInserted && [mList count] > 0) {
        MesiboMessageView *ld = [self get:(int)([mList count]-1)];
        if(MESSAGEVIEW_TIMESTAMP == [ld getType]) {
            [mList removeObject:ld];
        }
        mLastTimestampInserted = NO;
    }
    
    NSString *date = [m getDate];
    
    if([mm isRealtimeMessage]) {
        if([mList count] > 0) {
            lm = [self get:0];
        }
        
        if(!lm || [date caseInsensitiveCompare:[lm getDate]] != NSOrderedSame) {
            
            MesiboMessageView *data = [MesiboMessageView new];
            [data setType:MESSAGEVIEW_TIMESTAMP];
            [data setMessage:[m getMesiboMessage]];
            [mList insertObject:data atIndex:0];
            [mDelegate insertRow:0];
        }
        return;
    }
    
    if([mList count] > 0) {
        lm = [self get:(int)([mList count]-1)];
    }
    
    if(lm && [date caseInsensitiveCompare:[lm getDate]] != NSOrderedSame) {
        MesiboMessageView *data = [MesiboMessageView new];
        [data setType:MESSAGEVIEW_TIMESTAMP];
        [data setMessage:[lm getMesiboMessage]];
        [mList insertObject:data atIndex:[mList count]];
    }

}

-(void) updateTopTimestamp {
    if(!mEnableTimestamp) return;
}

-(void) updateStatus:(MesiboParams *)params {
    
    // a quick validating if message exists
    MesiboMessageView *data = [mMap objectForKey:@(params.mid)];
    if(nil == data) return;
    
    if(MESIBO_MSGSTATUS_READ == params.status) {
        [self setReadStatus];
        return;
    }
    
    int i = 0;
    MesiboMessageView *m = nil;
    for(m in mList) {
        if(params.mid == [m getMid]) {
            break;
        }
        
        i++;
    }
    
    if(!m) return;
    
    if([params isDeleted]) {
        [[m getMesiboMessage] setDeleted];
        [m resetHeight];
        [mDelegate reloadRow:i];
        return;
    }
    
    [[m getMesiboMessage] setStatus:params.status];
    
    //TBD. update table view for row i
    
    
    
    MesiboMessageViewHolder *vh = [m getViewHolder];
    if(!vh)
        return;
    
    [vh updateStatusIcon:params.status];
    
    // It's best to update status icon rather than updating whole cell
    
    //MesiboMessageViewHolder* cell = [_mChatTable cellForRowAtIndexPath:nip];
    //[cell updateStatusIcon:status];
}

-(void) setMessageStatus:(uint64_t)msgid status:(int)status {
    MesiboParams *p = [MesiboParams new];
    p.mid = msgid;
    p.status = status;
    p.origin = MESIBO_ORIGIN_REALTIME;
    [self Mesibo_OnMessageStatus:p];
}

-(void) deleteWithTimestamp:(MesiboMessageView *)m {
    BOOL hasDate = YES; // default YES for latest message case
    int i = 0;
    MesiboMessageView *d = nil;
    for(d in mList) {
        if([d getMid] == [m getMid]) {
            break;
        }
        // we are checking is the message newer than our message is actually a timestampo
        hasDate = (MESSAGEVIEW_TIMESTAMP == [d getType]);
        i++;
    }
    
    // if we still have messages for this date, we don't delete timestamp
    if(!d || !hasDate) {
        [mList removeObject:m]; // first case (!d) should not happen, so we just delete
        return;
    }
    
    //i  points to message
    if(i+1 < [mList count]) {
        MesiboMessageView *p = [self get:i+1];
        if(MESSAGEVIEW_TIMESTAMP == [p getType])
            [mList removeObject:p];
    }
    
    [mList removeObject:m];
}

-(void) deleteMessage:(MesiboMessageView *)m remote:(BOOL)remote refresh:(BOOL)refresh {
    if(MESSAGEVIEW_TIMESTAMP == [m getType]) return;
    
    if(!remote) {
        // instead of this we can just mark object as deleted so that
        // we can make height zero
        if(mEnableTimestamp)
            [self deleteWithTimestamp:m];
        else
            [mList removeObject:m];
    }
    else
        [[m getMesiboMessage] setDeleted];
    
    if(refresh) {
        [mDelegate reloadTable:NO];
    }
}

-(void) setReadStatus {
    
    int i = 0;
    
    for(MesiboMessageView *m in mList) {
        if(MESIBO_MSGSTATUS_READ == [[m getMesiboMessage] getStatus])
            break;
        
        if(MESIBO_MSGSTATUS_DELIVERED == [[m getMesiboMessage] getStatus]) {
            [[m getMesiboMessage] setStatus:MESIBO_MSGSTATUS_READ];
            i++;
        }
    }
    
    [mDelegate reloadRows:0 end:i-1];
}

-(BOOL) onFileTransferProgress:(MesiboFileInfo *)file {
    NSLog(@"File Progress: %d", [file getProgress]);
    MesiboMessageView *c = (MesiboMessageView *)[file getData];
    
    if(!c) return YES;
    
    MesiboMessageViewHolder *vh = [c getViewHolder];
    if(!vh)
      return YES;
    
    
    
    [vh updateFileProgress:file];
    return NO;
}

-(MesiboMessageView *) get:(int)row {
    MesiboMessageView *uidata = [mList objectAtIndex:row];
    if(!uidata) return uidata;
    uidata.mShowName = NO;
    MesiboMessage *m = [uidata getMesiboMessage];
    if(!m) return uidata;
    if([m getGroupId] > 0) {
        uidata.mShowName = YES;
        
        int count = (int) [mList count];
        if(row == count-1)
            return uidata;
        
        MesiboMessageView *prevdata = [mList objectAtIndex:row+1];
        if(!prevdata) return uidata;
        
        MesiboMessage *pm = [prevdata getMesiboMessage];
        if(!pm) return uidata;
        
        if([pm isIncoming] && ![m hasMedia] && ![pm hasMedia]) {
            
            NSString *peer = [m getSenderAddress];
            NSString *prevpeer = [pm getSenderAddress];
            
            if(peer &&  prevpeer && [peer isEqualToString:prevpeer]) {
                uidata.mShowName = NO;
            }
        }
        
    }
    return uidata;
}

-(NSInteger) count {
    return [mList count];
}

-(void) Mesibo_OnMessage:(MesiboMessage *)m {
    if(!mParams) {
        //handle user list
        return;
    }
    
    if(![self isForMe:m]) return;
    
    //Missed call has type
    if(![m isMissedCall] && 0 != [m getType])
        return;
    
    [self insert:m];
}


-(void) Mesibo_OnMessageStatus:(MesiboParams *)params {
    if(!mParams) {
        //handle user list
        return;
    }
    
    //TBD. onMessageStatus is always from someone, never group
    if(![self isForMeParam:params]) return;
    
    if(params.groupid > 0 && [params isMessageStatusInProgress]) return;
    
    int status = params.status;
    mLastMessageStatus = status;
    
    [mDelegate onMessageStatus:status];
    [self updateStatus:params];
}

-(void) Mesibo_OnConnectionStatus:(int)status {
    NSLog(@"OnConnectionStatus status: %d", status);
    if(MESIBO_STATUS_SHUTDOWN == status) {
        [mDelegate onShutdown];
        return;
    }
    
    if(MESIBO_STATUS_ONLINE == status)
        [mDelegate onPresence:MESIBO_ACTIVITY_ONLINE];
    else
        [mDelegate onPresence:MESIBO_ACTIVITY_NONE];
}

-(void) Mesibo_onActivity:(MesiboParams *)params activity:(int)activity {
    if(![self isForMeParam:params]) return;
    
    [mDelegate onPresence:activity];
    
}

-(void) Mesibo_OnMessage:(MesiboParams *)params data:(NSData *)data {
}
-(void) Mesibo_onFile:(MesiboParams *)params file:(MesiboFileInfo *)file{
}
- (void) Mesibo_onLocation:(MesiboParams *)params location:(MesiboLocation *)location {
}

- (BOOL) Mesibo_onFileTransferProgress:(MesiboFileInfo *)file {
    return [self onFileTransferProgress:file];
}

-(void) Mesibo_onProfileUpdated:(MesiboProfile *)profile {
    
    if(profile != mProfile)
        return;
    
    if([MesiboInstance isUiThread]) {
        [mDelegate onProfileUpdate];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [mDelegate onProfileUpdate];
    });
    
}

@end
