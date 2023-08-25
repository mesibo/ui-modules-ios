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

#import "MesiboViewHolder.h"

@interface MesiboViewHolder() {
    BOOL mCustom;
    UIViewController *mParent;
    MesiboTableController *mTable;
}
@end

@implementation MesiboViewHolder

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self reset];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self reset];
    return self;
}

-(void) reset {
    mCustom = NO;
    mParent = nil;
    mTable = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCustomCell {
    mCustom = YES;
}

-(BOOL) isCustomCell {
    return mCustom;
}

-(void) setParent:(UIViewController *) parent {
    mParent = parent;
}

-(UIViewController *) getParent {
    return mParent;
}

-(void) setTableController:(MesiboTableController *)tc {
    mTable = tc;
}

-(MesiboTableController *) getTableController {
    return mTable;
}

-(UIView *) getAccessoryView {
    return nil;
}

-(BOOL) isSelectionMode {
    return [mTable isSelectionMode];
}

-(void) addSelectedMessage:(id)data {
    [mTable addSelectedMessage:data];
}

-(BOOL) isSelected:(id)data {
    return [mTable isSelected:data];
}

-(void) delete:(nullable id)sender {
    [mTable delete:(id)sender];
}

-(void) forward:(id)sender {
    [mTable forward:(id)sender];
}

-(void) resend:(id)sender {
    [mTable resend:(id)sender];
}

-(void) share:(id)sender {
    [mTable share:(id)sender];
}

-(void) reply:(id)sender {
    [mTable reply:(id)sender];
}


@end
