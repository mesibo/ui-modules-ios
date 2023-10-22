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
//  TODocumentPickerTableViewController.h
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
#import "TODocumentPickerConstants.h"
#import "TODocumentPickerItem.h"
#import "TODocumentPickerConfiguration.h"

@interface TODocumentPickerViewController : UITableViewController

@property (nonatomic, readonly, nonnull)  TODocumentPickerConfiguration *configuration; /* An object that holds the configuration for all controllers */

@property (nonatomic, strong, nullable)   id<TODocumentPickerViewControllerDataSource> dataSource;             /* Data source for file info. Retained by the document picker and shared among all children. */
@property (nonatomic, weak, nullable)     id<TODocumentPickerViewControllerDelegate>   documentPickerDelegate; /* Sends out delegate events to the assigned object */

@property (nonatomic, readonly, nullable) NSString *filePath; /* The file path that this view controller corresponds to */
@property (nonatomic, strong, nullable)   NSArray  *items;    /* All of the items displayed by this view controller. (Setting this will trigger a UI refresh) */

@property (nonatomic, readonly, nonnull)  TODocumentPickerViewController *rootViewController; /* In a navigation chain of picker controllers, the root controller at the front.  */
@property (nonatomic, readonly, nonnull)  NSArray *viewControllers;         /* The chain of document picker view controllers in the navigation stack */

/* Create the base view controller with the initial starting file path, with a default configuration */
- (nullable instancetype)initWithFilePath:(nullable NSString *)filePath;

/* Create an instance with a custom created configuration object */
- (nullable instancetype)initWithConfiguration:(nullable TODocumentPickerConfiguration *)configuration filePath:(nullable NSString *)filePath;

/* Sets the items for the view controller in this chain, controlling that file path */
- (void)setItems:(nullable NSArray<TODocumentPickerItem *> *)items forFilePath:(nullable NSString *)filePath;

/* An initial file path must be specified, so use initWithFilePath: */
- (nonnull instancetype)init __attribute__((unavailable("Must use initWithFilePath: instead.")));
+ (nonnull instancetype)new __attribute__((unavailable("Must use initWithFilePath: instead.")));

@end
