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
#import "MessageData.h"
#import "MesiboUI.h"

@interface MesiboMessageModel ()
{
    MesiboMessageProperties *mParams;
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

-(void) setDestination:(MesiboMessageProperties *)params {
    mParams = params;
    if(!mParams)
        mEnableTimestamp = NO;
    else {
        mProfile = [MesiboInstance getProfile:mParams.peer groupid:mParams.groupid];
    }
    
    if(mParams) {
        mReadSession = [mProfile createReadSession:self];
        [mReadSession enableReadReceipt:mEnableReadReceipt];
        [mReadSession enableMissedCalls:mEnableCalls];
    }
    else {
        mReadSession = [[MesiboReadSession alloc] initWith:self];
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
    [self Mesibo_onConnectionStatus:b];
}

-(void) Mesibo_onSync:(NSInteger)count {
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
    }
    return [m compare:mParams.peer groupid:mParams.groupid];
}

-(BOOL) isForMeParam:(MesiboMessageProperties *) m {
    if([m isRealtimeMessage]) {
    }
    return [m compare:mParams.peer groupid:mParams.groupid];
}

-(int) lastStatus {
    return mLastMessageStatus;
}

-(void) redrawMessage:(uint64_t)msgid {
    MessageData *u = nil;
    int i = 0;
    for(u in mList) {
        if(msgid == [u getMid]) {
            break;
        }
        
        i++;
    }
    
    if(!u) return;
    
    [mDelegate reloadRow:i];
}

//TBD, date to be fixed
-(BOOL) reloadIfLastDbMessage:(MesiboMessage *)m {
    if([m isDbMessage] && [m isLastMessage]) {
        [mDelegate reloadTable:YES];
        return YES;
    }
    return NO;
}
-(void) insert:(MesiboMessage *)m {
    
    if(![m isMissedCall] && MESIBO_MSGSTATUS_E2E != [m getStatus]  && 0 != [m getType])
        return;
    
    if([m isDbMessage] && [m isLastMessage]) {
        NSLog(@"last");
    }
    
    //happens for real-time
    if([m isCall] && ![m isMissedCall])
        return;
    
    
    BOOL reverseOrder = ![m isRealtimeMessage];
    if(mReverseOrder)
        reverseOrder = !reverseOrder;
    
    MessageData *data = [MessageData new];
    [data setType:MESSAGEVIEW_MESSAGE];
    [data setMessage:m];
    
    [self insertTimestamp:data];
    
    if(!reverseOrder) {
        [mList insertObject:data atIndex:0];
    } else {
        [mList insertObject:data atIndex:[mList count]];
        
    }
    
    [self updateMessageMap:m.mid message:data];
    
    if([m isDbMessage] && [m isLastMessage]) {
        MessageData *data = [MessageData new];
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
            
        }
    }
}

-(void) updateMessageMap:(uint64_t)mid message:(MessageData *)m {
    if(m) {
        [mMap setObject:m forKey:@(mid)];
    } else {
        [mMap removeObjectForKey:@(mid)];
    }
}

-(MessageData *) findMessage:(uint64_t)mid {
    return [mMap objectForKey:@(mid)];
}

-(void) insertTimestamp:(MessageData *)m {
     if(!mEnableTimestamp) return;
    
    MesiboMessage *mm = [m getMesiboMessage];
    MessageData *lm = nil;
    
    if(![mm isRealtimeMessage] && mLastTimestampInserted && [mList count] > 0) {
        MessageData *ld = [self get:(int)([mList count]-1)];
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
            
            MessageData *data = [MessageData new];
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
        MessageData *data = [MessageData new];
        [data setType:MESSAGEVIEW_TIMESTAMP];
        [data setMessage:[lm getMesiboMessage]];
        [mList insertObject:data atIndex:[mList count]];
    }

}

-(void) updateTopTimestamp {
    if(!mEnableTimestamp) return;
}

-(void) updateStatus:(MesiboMessage *)msg {
    
    MessageData *data = [mMap objectForKey:@(msg.mid)];
    if(nil == data) return;
    
    int position = [data getPosition];
    if(position < 0) return;
    
    if([msg isDeleted]) {
        [data setDeleted:YES];
        [data resetHeight];
        [mDelegate reloadRow:position];
        return;
    }
    
    if([msg isReadByPeer]) {
        int i = 0;
        BOOL found = NO;
        for(MessageData *m in mList) {
            MesiboMessage *pm = [m getMesiboMessage];
            
            if(pm == msg || pm.mid == msg.mid)
                found = YES;
            
            if(pm == msg || !found) {
                i++;
                continue;
            }
            
            if([pm isReadByPeer])
                break;
            
            if([pm isDelivered] || [pm isSent]) {
                [pm setStatus:MESIBO_MSGSTATUS_READ];
                i++;
            }
        }
        
        if(i < 1) i = 1;
        [mDelegate reloadRows:0 end:i-1];
        return;
    }
    
    
    MesiboMessageViewHolder *vh = [data getViewHolder];
    if(!vh)
        return;
    
    [vh updateStatusIcon:msg.status];
}

-(void) deleteWithTimestamp:(MessageData *)m {
    BOOL hasDate = YES; // default YES for latest message case
    int i = 0;
    MessageData *d = nil;
    for(d in mList) {
        if([d getMid] == [m getMid]) {
            break;
        }
        // we are checking is the message newer than our message is actually a timestampo
        hasDate = (MESSAGEVIEW_TIMESTAMP == [d getType]);
        i++;
    }
    
    if(!d || !hasDate) {
        [mList removeObject:m]; // first case (!d) should not happen, so we just delete
        return;
    }
    
    if(i+1 < [mList count]) {
        MessageData *p = [self get:i+1];
        if(MESSAGEVIEW_TIMESTAMP == [p getType])
            [mList removeObject:p];
    }
    
    [mList removeObject:m];
}

-(void) deleteMessage:(MessageData *)m remote:(BOOL)remote refresh:(BOOL)refresh {
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
        [m setDeleted:YES];
    
    if(refresh) {
        [mDelegate reloadTable:NO];
    }
}

    
-(MessageData *) get:(int)row {
    MessageData *uidata = [mList objectAtIndex:row];
    if(!uidata) return uidata;

    MesiboMessage *m = [uidata getMesiboMessage];
    if(!m) return uidata;
    if([m isGroupMessage]) {
        
        int count = (int) [mList count];
        if(row == count-1)
            return uidata;
        
        MessageData *prevdata = [mList objectAtIndex:row+1];
        if(!prevdata) return uidata;
        
        [uidata checkPreviousData:prevdata];
    }
    return uidata;
}

-(NSInteger) count {
    return [mList count];
}

-(void) Mesibo_onMessage:(MesiboMessage *)m {
    if(!mParams) {
        return;
    }
    
    if(![self isForMe:m]) return;
    
    if(![m isMissedCall] && MESIBO_MSGSTATUS_E2E != [m getStatus] && 0 != [m getType]) {
        [self reloadIfLastDbMessage:m];
        return;
    }
    
    if(MESIBO_MSGSTATUS_E2E == [m getStatus]) {
        if(![MesiboE2EEInstance isEnabled]) {
            [self reloadIfLastDbMessage:m];
            return;
        }
        
        if(![MesiboUI getUiDefaults].e2eeActive) {
            [self reloadIfLastDbMessage:m];
            return;
        }
    }
    
    [self insert:m];
}

-(void) Mesibo_onEndToEndEncryption:(MesiboProfile *)profile status:(int)status {
    NSLog(@"Mesibo_onEndToEndEncryption: %d", status);
}

-(void) Mesibo_onMessageUpdate:(MesiboMessage *)msg {
    MessageData *data = [mMap objectForKey:@(msg.mid)];
    if(nil == data) return;
    
    int position = [data getPosition];
    if(position < 0) return;
    
    if(![msg isFileTransferInProgress]) {
        [mDelegate reloadRow:position];
        return;
    }
        
    MesiboMessageViewHolder *vh = [data getViewHolder];
    if(!vh) return;
    
    [vh setProgress:[msg getProgress]];
}

-(void) Mesibo_onMessageStatus:(MesiboMessage *)params {
    MessageData *md = [self findMessage:params.mid];
    if(!md) return;
    
    if(![self isForMeParam:params]) return;
    
    if(params.groupid > 0 && [params isMessageStatusInProgress]) return;
    
    int status = params.status;
    mLastMessageStatus = status;
    
    [mDelegate onMessageStatus:status];
    [self updateStatus:params];
}

-(void) Mesibo_onConnectionStatus:(NSInteger)status {
    if(MESIBO_STATUS_SHUTDOWN == status) {
        [mDelegate onShutdown];
        return;
    }
    
    if(MESIBO_STATUS_ONLINE == status)
        [mDelegate onPresence:MESIBO_PRESENCE_ONLINE];
    else
        [mDelegate onPresence:MESIBO_PRESENCE_NONE];
}

-(void) Mesibo_onPresence:(MesiboPresence *)message {
    
    if(![self isForMeParam:message]) return;
    
    [mDelegate onPresence:message.presence];
    
}

-(void) Mesibo_onProfileUpdated:(MesiboProfile *)profile {
     
    if(!profile || profile != mProfile)
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
