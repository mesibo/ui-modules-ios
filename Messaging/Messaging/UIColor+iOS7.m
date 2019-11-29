//
//  UIColor+iOS7.m
//  FFCircularProgressView
//
//  Created by Fabiano Francesconi on 16/07/13.
//  Copyright (c) 2013 Fabiano Francesconi. All rights reserved.
//

#import "UIColor+iOS7.h"

@implementation UIColor (iOS7)

+ (UIColor *) ios7Blue {
    return [self colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
}

+ (UIColor *) ios7Gray {
    return [self colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
}

+(UIColor *) getColor:(uint32_t) color {

    return [UIColor colorWithRed:((float)((color>>16)&0xFF))/255.0 green:((float)((color>>8)&0xFF))/255.0 blue:((float)((color)&0xFF))/255.0 alpha:((float)((color>>24)&0xFF))/255.0];
}

@end
