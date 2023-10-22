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

//
//  TODocumentPickerDefines.h
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import <Foundation/FOundation.h>

@class TODocumentPickerViewController;
@class TODocumentPickerItem;

/*
 The default content styles that the controller implements.
 */
typedef NS_ENUM(NSInteger, TODocumentPickerViewControllerStyle) {
    TODocumentPickerViewControllerStyleLightContent,
    TODocumentPickerViewControllerStyleDarkContent
};

/* 
 The various sorting orders in which the picker can display the files. 
*/
typedef NS_ENUM(NSInteger, TODocumentPickerSortType) {
    TODocumentPickerSortTypeNameAscending=0,
    TODocumentPickerSortTypeNameDescending,
    TODocumentPickerSortTypeDateAscending,
    TODocumentPickerSortTypeDateDescending,
    TODocumentPickerSortTypeSizeAscending,
    TODocumentPickerSortTypeSizeDescending
};

//-------------------------------------------------------------------------
// The data source protocol for objects charged with loading the file information to display

@protocol TODocumentPickerViewControllerDataSource <NSObject>

@required

/**
 Called by the view controller when it wants to obtain a list of items for the folder at the end of the file path.
 Whether the data source subsequently hands off this request asynchronously or not, when completed, the data source
 must call the 'updateItemsForFilePath' block.
 
 @param filePath The file path with which to download file information
 */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker
             requestItemsForFilePath:(nonnull NSString *)filePath
                   completionHandler:(nonnull void (^)(NSArray<TODocumentPickerItem *> * _Nullable items))completionHandler;

@optional

/**
 If an asynchronous request for files is currently in progress and the representing view controller is canceled,
 (eg, if the user hits 'back' before it completes), this method will be called to give the request a chance to cancel.
 
 @param filePath The file path with which to cancel loading
 */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker cancelRequestForFilePath:(nonnull NSString *)filePath;

/** 
 After a table cell has been configured for display, this method allows for additional custom configuration of the cell after the fact.
 */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker configureCell:(nonnull UITableViewCell *)cell withItem:(nonnull TODocumentPickerItem *)item;

/**
 The title that will appear in the navigation bar for the folder at this file path.
 If not implemented, defautl behaviour is to return simply the folder name from the filePath string
 */
- (nullable NSString *)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker titleForFilePath:(nullable NSString *)filePath;

@end

//-------------------------------------------------------------------------

@protocol TODocumentPickerViewControllerDelegate <NSObject>

@optional

/* User either tapped a single item, or selected multiple items and hit 'choose' */
- (void)documentPickerViewController:(nonnull TODocumentPickerViewController *)documentPicker didSelectItems:(nonnull NSArray<TODocumentPickerItem *> *)items inFilePath:(nullable NSString *)filePath;

@end

//-------------------------------------------------------------------------

// Theming Attributes

extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeBackgroundColor;                     /* Background color of the table view */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableSeparatorColor;                 /* Color of the table cell divider lines */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableCellTitleColor;                 /* Color of the title text label in each cell */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableCellDetailTextColor;            /* Color of the subtitle text label in each cell */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableCellAccessoryTintColor;         /* Color of the arrow accessory icon */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableCellIconTintColor;              /* Tint color of the icons in each cell */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableSectionHeaderBackgroundColor;   /* Background color of each section header */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableSectionTitleColor;              /* Color of the text in each section header */
extern NSString *  _Nonnull const TODocumentPickerViewControllerThemeAttributeTableSectionIndexColor;              /* Tint color of the scrollable section index column */
