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

#import "MesiboModel.h"
#import "MesiboMessageViewHolder.h"
#import "MesiboMessageView.h"

@interface MesiboModel ()
{
    BOOL mMode;
    BOOL mEnableTimestamp;
    BOOL mReverseOrder;
    BOOL mLastTimestampInserted;
    NSMutableArray *mList;
    NSMutableDictionary *mMap;
    NSMutableDictionary *mDateMap;
    NSMutableDictionary *mIndexPathMap;
    MesiboTableController *mTable;
}
@end

@implementation MesiboModel

-(id)init
{
    self = [super init];
    if (self)
    {
        [self reset];
    }
    return self;
}

-(void) reset {
    mList = [[NSMutableArray alloc] init] ;
    mMap = [[NSMutableDictionary alloc] init];
    mDateMap = [[NSMutableDictionary alloc] init];
    mIndexPathMap = [[NSMutableDictionary alloc] init];
    
    mMode = MODEL_MODE_MESSAGE;
    mEnableTimestamp = YES;
    mReverseOrder = NO;
    mLastTimestampInserted = NO;
}

-(void) setMode:(int)mode {
    mMode = mode;
    if(MODEL_MODE_MESSAGE == mMode) {
        mEnableTimestamp = YES;
        mReverseOrder = NO;
    } else {
        mEnableTimestamp = NO;
        mReverseOrder = NO;
    }
}

-(void) setTable:(MesiboTableController *) table {
    mTable = table;
}

-(void) enableTimestamp:(BOOL)enable {
    mEnableTimestamp = enable;
}

-(void) enableReverseOrder:(BOOL)enable {
    mReverseOrder = enable;
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
        [mTable reloadTable:YES];
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
                
                [mTable reloadRow:i];
                return;
                /*
                 UiData *c =(UiData *) [location getData];
                 MesiboMessageViewHolder *vU = (MesiboMessageViewHolder *)[c getViewHolder];
                 
                 if(vU != nil ) {
                 vU.chatPicture.image = location.image;
                 [mTable reloadData];
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
        
        [mTable reloadTable:YES];
    } else if([m isRealtimeMessage]) {
        [mTable insertInTable:0 section:0 showLatest:YES animate:YES];
    }
    
    // if message is being sent - move to bottom
    if([m isInOutbox] && [m isRealtimeMessage]) {
        [mTable scrollToBottom:YES];
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
            [mTable insertInTable:0 section:0 showLatest:YES animate:YES];
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

-(void) Mesibo_OnMessageStatus:(MesiboParams *)params {
    
    if(params.groupid > 0 && [params isMessageStatusInProgress]) return;
    
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
        [mTable reloadRow:i];
        return;
    }
    
    [[m getMesiboMessage] setStatus:params.status];
    
    //TBD. update table view for row i
    
    
    
    MesiboMessageViewHolder *vh = [m getViewHolder];
    if(!vh)
        return;
    
    [vh updateStatusIcon:params.status];
    
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
        [mTable reloadTable:NO];
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
    
    [mTable reloadRows:0 end:i-1];
}

-(BOOL) Mesibo_onFileTransferProgress:(MesiboFileInfo *)file {
    NSLog(@"File Progress: %d", [file getProgress]);
    MesiboMessageView *c = (MesiboMessageView *)[file getData];
    
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


@end
