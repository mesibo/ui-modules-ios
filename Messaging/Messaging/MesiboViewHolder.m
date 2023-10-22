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
