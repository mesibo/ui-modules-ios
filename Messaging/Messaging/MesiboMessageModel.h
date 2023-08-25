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

#import <Foundation/Foundation.h>
#import "Mesibo/Mesibo.h"
#import "MessageData.h"

#define MESIBO_MODEL_MESSAGE   0
#define MESIBO_MODEL_SUMMARY      1

NS_ASSUME_NONNULL_BEGIN

@protocol MesiboMessageModelDelegate <NSObject>

@required
- (void) scrollToBottom:(BOOL)animated;
- (void) scrollToLatestChat:(BOOL)animated;

- (void) reloadTable:(BOOL)scrollToLatest;
- (void) reloadRow:(NSInteger)row;
- (void) reloadRows:(NSArray *)rows;
- (void) reloadRows:(NSInteger)start end:(NSInteger)end;
- (void) insertRow:(NSInteger)row;
- (void) onMessageStatus:(int)status;
- (void) onPresence:(int)presence;
- (void) onProfileUpdate;
- (void) onShutdown;
@optional
@end

@interface MesiboMessageModel : NSObject <MesiboDelegate>

-(void) reset;
-(void) setDestination:(MesiboMessageProperties *)params ;
-(BOOL) loadMessages:(int)count;
-(void) start;
-(void) pause;
-(void) stop;
-(void) updateConnectionStatus;
-(void) enableTimestamp:(BOOL)enable;
-(void) enableReverseOrder:(BOOL)enable;
-(void) enableCallLogs:(BOOL)enable;
-(void) enableMessages:(BOOL)enable;
-(void) enableReadReceipt:(BOOL)enable;
-(void) insert:(MesiboMessage *) m;
-(void) setMessageStatus:(uint64_t)msgid status:(int)status;
-(void) deleteMessage:(MessageData *)m remote:(BOOL)remote refresh:(BOOL)refresh;
-(void) deleteMessage:(uint64_t)msgid refresh:(BOOL)refresh;
-(MessageData *) get:(int)row;
-(NSInteger) count;
-(void) serach:(NSString *)query;


//TBD. instead of this, we should have protocol/delegate
-(void) setDelegate:(id) delegate;
-(int) lastStatus;

@end

NS_ASSUME_NONNULL_END
