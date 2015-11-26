//
//  ImageStore.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/31.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore()

@property(nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation ImageStore

+(instancetype)sharedStore
{
    static ImageStore *sharedStore = nil;
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore =[[self alloc]initPrivate];
    });
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"Use+[sharedStore]" userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

-(UIImage *)imageForKey:(NSString *)key
{
    return self.dictionary[key];
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
