//
//  ImageTransformer.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/12/14.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation ImageTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
