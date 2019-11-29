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
#import "MesiboMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

// user MUST registerclass using MESIBO_CELL_IDENTIFIER
#define MESIBO_CELL_IDENTIFIER @"MesiboViewHolderCell"

@protocol MesiboTableControllerDelegate <NSObject>

@required
- (void) share:(NSString *) text image:(UIImage *)image;
- (BOOL) loadMoreMessages;
- (void) enableSelectionActionButtons:(BOOL)enable buttons:(nullable NSArray *) buttons;
- (void) forwardMessages:(NSArray *) msgids;
- (void) reply:(id)data;

@optional
@end

@interface MesiboTableController : NSObject <MesiboDelegate, UITableViewDelegate , UITableViewDataSource>

-(void) setup:(id)parent tableView:(UITableView *)tableView model:(MesiboMessageModel *)model delegate:(id)delegate uidelegate:(id)uidelegate;

-(void) insert:(MesiboMessage *) m;
//-(void) deleteMessages:(NSArray *) msgs type:(int)type;
//-(id) get:(int)row;

//-(void) setPeer:(NSString *)peer groupid:(uint32_t)groupid query:(NSString *)query;
-(void) start;
-(void) stop;

-(void) scrollToBottom:(BOOL)animated;
-(void) scrollToLatestChat:(BOOL)animation;

-(void) reloadTable:(BOOL)scrollToLatest;
-(void) reloadRow:(NSInteger)row;
-(void) reloadRows:(NSArray *)rows;
-(void) reloadRows:(NSInteger)start end:(NSInteger)end;
//-(void) reloadMessage:(id)m;

-(BOOL) isSelectionMode;
-(void) addSelectedMessage:(id)data;
-(BOOL) isSelected:(id)data;
-(BOOL) cancelSelectionMode;

-(void) delete:(nullable id)sender;
-(void) forward:(id)sender;
-(void) resend:(id)sender;
-(void) reply:(id)sender;
-(void) share:(id)sender;

-(void)insertInTable:(NSInteger)row section:(NSInteger)section showLatest:(BOOL)showLatest animate:(BOOL)animate;

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;
@end

NS_ASSUME_NONNULL_END
