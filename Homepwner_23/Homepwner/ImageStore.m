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

-(NSString *)imagePathForKey:(NSString *)key;

@end

@implementation ImageStore

+(instancetype)sharedStore
{
    static ImageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
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
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
        
    }
    return self;
}

-(void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    NSString *imagePath = [self imagePathForKey:key];
    
    //从图片提取jpeg格式的数据，压缩质量0.5
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
//    return self.dictionary[key];
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *path = [self imagePathForKey:key];
        
        result = [UIImage imageWithContentsOfFile:path];
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"error unable to find %@", path);
        }
    }
    return result;
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *path = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}



@end
