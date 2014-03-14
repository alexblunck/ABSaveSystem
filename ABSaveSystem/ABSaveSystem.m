//
//  ABSaveSystem.m
//  ABFramework
//
//  Created by Alexander Blunck on 11/11/12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "ABSaveSystem.h"



// Key size is 32 bytes for AES256
#define kKeySize kCCKeySizeAES256



#pragma mark - Categories
#pragma mark - Categories - NSArray
@implementation NSArray (ABSaveSystem)
-(id) safeObjectAtIndex:(NSUInteger)index
{
    if (self.count >= index+1)
    {
        return [self objectAtIndex:index];
    }
    return nil;
}
@end


#pragma mark - Categories - NSData
@implementation NSData (ABSaveSystem)
- (NSData*) makeCryptedVersionWithKeyData:(const void*) keyData ofLength:(int) keyLength decrypt:(bool) decrypt
{
	// Copy the key data, padding with zeroes if needed
	char key[kKeySize];
	bzero(key, sizeof(key));
	memcpy(key, keyData, keyLength > kKeySize ? kKeySize : keyLength);
    
	size_t bufferSize = [self length] + kCCBlockSizeAES128;
	void* buffer = malloc(bufferSize);
    
	size_t dataUsed;
    
	CCCryptorStatus status = CCCrypt(decrypt ? kCCDecrypt : kCCEncrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding | kCCOptionECBMode,
									 key, kKeySize,
									 NULL,
									 [self bytes], [self length],
									 buffer, bufferSize,
									 &dataUsed);
    
	switch(status)
	{
		case kCCSuccess:
			return [NSData dataWithBytesNoCopy:buffer length:dataUsed];
		case kCCParamError:
			NSLog(@"Error: NSDataAES256: Could not %s data: Param error", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCBufferTooSmall:
			NSLog(@"Error: NSDataAES256: Could not %s data: Buffer too small", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCMemoryFailure:
			NSLog(@"Error: NSDataAES256: Could not %s data: Memory failure", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCAlignmentError:
			NSLog(@"Error: NSDataAES256: Could not %s data: Alignment error", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCDecodeError:
			NSLog(@"Error: NSDataAES256: Could not %s data: Decode error", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCUnimplemented:
			NSLog(@"Error: NSDataAES256: Could not %s data: Unimplemented", decrypt ? "decrypt" : "encrypt");
			break;
		default:
			NSLog(@"Error: NSDataAES256: Could not %s data: Unknown error", decrypt ? "decrypt" : "encrypt");
	}
    
	free(buffer);
	return nil;
}
- (NSData*) encryptedWithKey:(NSData*) key
{
	return [self makeCryptedVersionWithKeyData:[key bytes] ofLength:(unsigned int)[key length] decrypt:NO];
}
- (NSData*) decryptedWithKey:(NSData*) key
{
	return [self makeCryptedVersionWithKeyData:[key bytes] ofLength:(unsigned int)[key length] decrypt:YES];
}
@end



#pragma mark - ABSaveSystem
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

+(NSString*) filepathEncrypted:(BOOL)encrypted
{
    ABSaveSystemOS os = [self os];
    
    NSString *fileExt = (encrypted) ? @".abssen" : @".abss";
    NSString *fileName = [NSString stringWithFormat:@"%@%@", [[self appName] lowercaseString], fileExt];
    
    if (os == ABSaveSystemOSIOS)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths safeObjectAtIndex:0];
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

+(NSMutableDictionary*) loadEncryptedDictionary:(BOOL)encrypted
{
    NSData *binaryFile = [NSData dataWithContentsOfFile:[self filepathEncrypted:encrypted]];
    
    if (binaryFile == nil) {
        return nil;
    }
    
    NSMutableDictionary *dictionary;
    //Either Decrypt saved data or just load it
    if (encrypted)
    {
        NSData *dataKey = [ABSAVESYSTEM_AESKEY dataUsingEncoding:NSUTF8StringEncoding];
        NSData *decryptedData = [binaryFile decryptedWithKey:dataKey];
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
+(void) saveData:(NSData*)data key:(NSString*)key encrypted:(BOOL)encrypted
{
    //Check if file exits, if so init Dictionary with it's content, otherwise allocate new one
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self filepathEncrypted:encrypted]];
    NSMutableDictionary *tempDic = nil;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [self loadEncryptedDictionary:encrypted];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:data forKey:key];
    
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
    
    //Either encrypt Data or just save
    if (encrypted)
    {
        NSData *dataKey = [ABSAVESYSTEM_AESKEY dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedData = [dicData encryptedWithKey:dataKey];
        [encryptedData writeToFile:[self filepathEncrypted:YES] atomically:YES];
    }
    else
    {
        [dicData writeToFile:[self filepathEncrypted:encrypted] atomically:YES];
    }
    
}

+(void) saveData:(NSData*)data key:(NSString*)key
{
    [self saveData:data key:key encrypted:ABSAVESYSTEM_ENCRYPTION_ENABLED];
}

+(NSData*) dataForKey:(NSString*)key encrypted:(BOOL)encrypted
{
    NSMutableDictionary *tempDic = [self loadEncryptedDictionary:encrypted];
    
    //Retrieve NSData for specific key
    NSData *loadedData = [tempDic objectForKey:key];
    
    //Check if data exists for key
    if (loadedData != nil)
    {
        return loadedData;
    }
    else
    {
        if (ABSAVESYSTEM_VERBOSE_LOGGING) NSLog(@"ABSaveSystem ERROR: dataForKey:\"%@\" -> data for key does not exist!", key);
    }
    return nil;
}

+(NSData*) dataForKey:(NSString*)key
{
    return [self dataForKey:key encrypted:ABSAVESYSTEM_ENCRYPTION_ENABLED];
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
            if (ABSAVESYSTEM_LOGGING) NSLog(@"ABSaveSystem ERROR: objectForKey:\"%@\" -> saved object is %@ not a %@", key, [object class],  aClass);
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
+(BOOL) exists:(NSString*)key
{
    return [self exists:key encrypted:ABSAVESYSTEM_ENCRYPTION_ENABLED];
}

+(BOOL) exists:(NSString*)key encrypted:(BOOL)encrypted
{
    id data = [self dataForKey:key encrypted:encrypted];
    return (data != nil);
}

+(void) logSavedValues:(BOOL)encrypted
{
    NSString *baseLogMessage = (encrypted) ? @"ABSaveSystem: logSavedValues (Encrypted)" : @"ABSaveSystem: logSavedValues";
    
    NSMutableDictionary *tempDic= [self loadEncryptedDictionary:encrypted];
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
    [self truncateEncrypted:NO];
    [self truncateEncrypted:YES];
}

+(void) truncateEncrypted:(BOOL)encrypted
{
    NSString *filepath = [self filepathEncrypted:encrypted];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:nil];
    }
}

+(void) removeValueForKey:(NSString*)key
{
    [self removeValueForKey:key encrypted:ABSAVESYSTEM_ENCRYPTION_ENABLED];
}

+(void) removeValueForKey:(NSString*)key encrypted:(BOOL)encrypted
{
    NSMutableDictionary *tempDic = [self loadEncryptedDictionary:encrypted];
    [tempDic removeObjectForKey:key];
    
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
    
    if (encrypted)
    {
        NSData *dataKey = [ABSAVESYSTEM_AESKEY dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedData = [dicData encryptedWithKey:dataKey];
        [encryptedData writeToFile:[self filepathEncrypted:YES] atomically:YES];
    }
    else
    {
        NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
        [dicData writeToFile:[self filepathEncrypted:NO] atomically:YES];
    }
}

@end
