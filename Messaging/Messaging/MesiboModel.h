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
#import "MesiboTableController.h"

#import "MesiboMessageView.h"

#define MODEL_MODE_MESSAGE   0
#define MODEL_MODE_LIST      1

NS_ASSUME_NONNULL_BEGIN

@protocol MesiboModelDelegate <NSObject>

@required
- (void) scrollToBottom:(BOOL)animated;
- (void) scrollToLatestChat:(BOOL)animation;

- (void) reloadTable:(BOOL)scrollToLatest;
- (void) reloadRow:(NSInteger)row;
- (void) reloadRows:(NSArray *)rows;
- (void) reloadMessage:(id)m;
@optional
@end

@interface MesiboModel : NSObject 

-(void) reset;
-(void) setMode:(int)mode ;
-(void) enableTimestamp:(BOOL)enable;
-(void) enableReverseOrder:(BOOL)enable;
-(void) insert:(MesiboMessage *) m;
//-(void) deleteMessages:(NSArray *) msgs type:(int)type;
-(void) deleteMessage:(MesiboMessageView *) msg type:(int)type refresh:(BOOL)refresh;
-(MesiboMessageView *) get:(int)row;

-(void) Mesibo_OnMessageStatus:(MesiboParams *)params;
-(BOOL) Mesibo_onFileTransferProgress:(MesiboFileInfo *)file;

-(NSInteger) count;

//TBD. instead of this, we should have protocol/delegate
-(void) setTable:(MesiboTableController *) table;

@end

NS_ASSUME_NONNULL_END
