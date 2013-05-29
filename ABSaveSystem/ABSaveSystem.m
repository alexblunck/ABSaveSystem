//
//  ABSaveSystem.m
//  ABFramework
//
//  Created by Alexander Blunck on 11/11/12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "ABSaveSystem.h"

@implementation ABSaveSystem

#pragma mark - Helper
+(NSString*) appName
{
    NSString *bundlePath = [[[NSBundle mainBundle] bundleURL] lastPathComponent];
    return [[bundlePath stringByDeletingPathExtension] lowercaseString];
}

+(ABSaveSystemOS) os
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    return ABSaveSystemOSIOS;
#else
    return ABSaveSystemOSMacOSX;
#endif
}

+(NSString*) filePathEncryption:(BOOL)encryption
{
    ABSaveSystemOS os = [self os];
    
    NSString *fileExt = (encryption) ? @".abssen" : @".abss";
    NSString *fileName = [NSString stringWithFormat:@"%@%@", [[self appName] lowercaseString], fileExt];
    
    if (os == ABSaveSystemOSIOS)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
        return path;
    }
    else if (os == ABSaveSystemOSMacOSX)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *folderPath = [NSString stringWithFormat:@"~/Library/Application Support/%@/", [self appName]];
        folderPath = [folderPath stringByExpandingTildeInPath];
        if ([fileManager fileExistsAtPath:folderPath] == NO)
        {
            [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return  [folderPath stringByAppendingPathComponent:fileName];
    }

    return nil;
}

+(NSMutableDictionary*) loadDictionaryEncryption:(BOOL)encryption
{
    NSData *binaryFile = [NSData dataWithContentsOfFile:[self filePathEncryption:encryption]];
    
    if (binaryFile == nil) {
        return nil;
    }
    
    NSMutableDictionary *dictionary;
    //Either Decrypt saved data or just load it
    if (encryption)
    {
        NSData *decryptedData = [self decryptData:binaryFile withKey:ABSS_AESKEY];
        dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    }
    else
    {
        dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:binaryFile];
    }
    
    return dictionary;
}



#pragma mark - Objects
#pragma mark - NSData
+(void) saveData:(NSData*)data key:(NSString*)key encryption:(BOOL)encryption
{
    //Check if file exits, if so init Dictionary with it's content, otherwise allocate new one
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self filePathEncryption:encryption]];
    NSMutableDictionary *tempDic = nil;
    if (fileExists)
    {
        tempDic = [self loadDictionaryEncryption:encryption];
    }
    else
    {
       tempDic = [NSMutableDictionary dictionary];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:data forKey:key];
    
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
    
    //Either encrypt Data or just save
    if (encryption)
    {
        NSData *encryptedData = [self encryptData:dicData withKey:ABSS_AESKEY];
        [encryptedData writeToFile:[self filePathEncryption:YES] atomically:YES];
    }
    else
    {
        [dicData writeToFile:[self filePathEncryption:encryption] atomically:YES];
    }
    
}

+(void) saveData:(NSData*)data key:(NSString*)key
{
    [self saveData:data key:key encryption:ABSS_ENCRYPTION_ENABLED];
}

+(NSData*) dataForKey:(NSString*)key encryption:(BOOL)encryption
{
    NSMutableDictionary *tempDic = [self loadDictionaryEncryption:encryption];
    
    //Retrieve NSData for specific key
    NSData *loadedData = [tempDic objectForKey:key];
    
    //Check if data exists for key
    if (loadedData != nil)
    {
        return loadedData;
    }
    else
    {
        if (ABSS_LOGGING) NSLog(@"ABSaveSystem ERROR: dataForKey:\"%@\" -> data for key does not exist!", key);
    }
    return nil;
}

+(NSData*) dataForKey:(NSString*)key
{
    return [self dataForKey:key encryption:ABSS_ENCRYPTION_ENABLED];
}

#pragma mark - Object
+(void) saveObject:(id<NSCoding>)object key:(NSString*)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self saveData:data key:key];
}

+(id) objectForKey:(NSString*)key checkClass:(Class)aClass
{
    NSData *data = [self dataForKey:key];
    if (data != nil)
    {
        //Check that the correct kind of class was retrieved from storage (skip check if aClass is not set)
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([object isKindOfClass:aClass] || aClass == nil)
        {
            return object;
        }
        else
        {
            if (ABSS_LOGGING) NSLog(@"ABSaveSystem ERROR: objectForKey:\"%@\" -> saved object is %@ not a %@", key, [object class],  aClass);
        }
    }
    return nil;
}

+(id) objectForKey:(NSString*)key
{
    return [self objectForKey:key checkClass:nil];
}


#pragma mark - NSString
+(void) saveString:(NSString*)string key:(NSString*)key
{
    [self saveObject:string key:key];
}

+(NSString*) stringForKey:(NSString*)key
{
    return [self objectForKey:key checkClass:[NSString class]];
}


#pragma mark - NSNumber
+(void) saveNumber:(NSNumber*)number key:(NSString*)key
{
    [self saveObject:number key:key];
}

+(NSNumber*) numberForKey:(NSString*)key
{
    return [self objectForKey:key checkClass:[NSNumber class]];
}


#pragma mark - NSDate
+(void) saveDate:(NSDate*)date key:(NSString*)key
{
    [self saveObject:date key:key];
}

+(NSDate*) dateForKey:(NSString*)key
{
    return [self objectForKey:key checkClass:[NSDate class]];
}



#pragma mark - Primitives
#pragma mark - NSInteger
+(void) saveInteger:(NSInteger)integer key:(NSString*)key
{
    [self saveNumber:[NSNumber numberWithInteger:integer] key:key];
}

+(NSInteger) integerForKey:(NSString*)key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number integerValue];
    }
    return 0;
}


#pragma mark - CGFloat
+(void) saveFloat:(CGFloat)aFloat key:(NSString*)key
{
    [self saveNumber:[NSNumber numberWithFloat:aFloat] key:key];
}

+(CGFloat) floatForKey:(NSString*)key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number floatValue];
    }
    return 0.0f;
}


#pragma mark - BOOL
+(void) saveBool:(BOOL)boolean key:(NSString*)key
{
    [self saveNumber:[NSNumber numberWithBool:boolean] key:key];
}

+(BOOL) boolForKey:(NSString*)key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number boolValue];
    }
    return NO;
}



#pragma mark - Misc
+(void) logSavedValues
{
    [self logSavedValues:NO];
    [self logSavedValues:YES];
}

+(void) logSavedValues:(BOOL)encrypted
{
    NSString *baseLogMessage = (encrypted) ? @"ABSaveSystem: logSavedValues (Encrypted)" : @"ABSaveSystem: logSavedValues";
    
    NSMutableDictionary *tempDic= [self loadDictionaryEncryption:encrypted];
    if (tempDic == nil)
    {
        NSLog(@"%@ -> NO DATA SAVED!", baseLogMessage);
        return;
    }
    
    NSLog(@"%@ -> START LOG", baseLogMessage);
        
    [tempDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         NSString *valueString = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        
         NSLog(@"%@ -> Key:%@ -> %@", baseLogMessage, key, valueString);
     }];
    
    NSLog(@"%@ -> END LOG", baseLogMessage);
}

+(void) truncate
{
    NSMutableDictionary *tempDic = [self loadDictionaryEncryption:NO];
    [tempDic removeAllObjects];
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
    [dicData writeToFile:[self filePathEncryption:NO] atomically:YES];
    
    NSMutableDictionary *tempDicEnc = [self loadDictionaryEncryption:YES];
    [tempDicEnc removeAllObjects];
    NSData *encryptedData = [self encryptData:dicData withKey:ABSS_AESKEY];
    [encryptedData writeToFile:[self filePathEncryption:YES] atomically:YES];
}



#pragma mark - Helper
+(NSData*) makeCryptedVersionOfData:(NSData*)data withKeyData:(const void*)keyData ofLength:(long) keyLength decrypt:(bool)decrypt
{
	int keySize = kCCKeySizeAES256;
    char key[kCCKeySizeAES256];
	bzero(key, sizeof(key));
	memcpy(key, keyData, keyLength > keySize ? keySize : keyLength);
    
	size_t bufferSize = [data length] + kCCBlockSizeAES128;
	void* buffer = malloc(bufferSize);
    
	size_t dataUsed;
    
	CCCryptorStatus status = CCCrypt(decrypt ? kCCDecrypt : kCCEncrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding | kCCOptionECBMode,
									 key, keySize,
									 NULL,
									 [data bytes], [data length],
									 buffer, bufferSize,
									 &dataUsed);
    
	switch(status)
	{
		case kCCSuccess:
			return [NSData dataWithBytesNoCopy:buffer length:dataUsed];
		default:
			if (ABSS_LOGGING) NSLog(@"ABSaveSystem: ERROR -> Failed to encrypt/decrypt!");
	}
    
	free(buffer);
	return nil;
}

+(NSData*) encryptData:(NSData*)data withKey:(NSString*)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	return [self makeCryptedVersionOfData:data withKeyData:[keyData bytes] ofLength:[keyData length] decrypt:false];
}

+(NSData*) decryptData:(NSData*)data withKey:(NSString*)key
{
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    return [self makeCryptedVersionOfData:data withKeyData:[keyData bytes] ofLength:[keyData length] decrypt:true];
}

@end
