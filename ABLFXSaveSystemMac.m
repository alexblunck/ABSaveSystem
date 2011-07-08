//
//  ABLFXSaveSystemMac.m
//
//  Created by Alexander Blunck on 5/11/11.
//  Copyright 2011 ablfx. All rights reserved.
// 	http://www.ablfx.com

#import "AblfxSaveSystem.h"

@implementation AblfxSaveSystem

-(id) init {self = [super init];if (self) { 
}return self;}

- (NSString *) pathForDataFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //I'd recommend changing "AppName" to your apps name
    NSString *folder = @"~/Library/Application Support/AppName/";
    folder = [folder stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath: folder] == NO)
    {
        //[fileManager createDirectoryAtPath: folder attributes: nil];
        [fileManager createDirectoryAtPath: folder withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    //I'd recommend changing "AppName" to your apps name
    NSString *fileName = @"AppName.plist";
    return [folder stringByAppendingPathComponent: fileName];    
}

//SAVE STRINGS
-(void) saveString:(NSString*) string withKey:(NSString*) key {
    //Check if file exits, if so init Dictionary with it's content, otherwise allocate new one
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self pathForDataFile]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathForDataFile]];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:string forKey:key];
    [tempDic writeToFile:[self pathForDataFile] atomically:YES];
    
    //Release allocated Dictionary
    [tempDic release];
    
}
-(NSString*) loadStringForKey:(NSString*) key {
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathForDataFile]];
    NSString *loadedString = [tempDic2 objectForKey:key];
    //[tempDic2 release];
    return loadedString;
}
//SAVE STRINGS


//SAVE NUMBERS (int)
-(void) saveINT:(int) number withKey:(NSString*) key{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self pathForDataFile]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathForDataFile]];
    }
    //turn passed INT into NSNumber object
    NSNumber *numberObject = [NSNumber numberWithInt:number];
    [tempDic setObject:numberObject forKey:key];
    [tempDic writeToFile:[self pathForDataFile] atomically:YES];
    
    [tempDic release];
}
-(int) loadINTForKey:(NSString*) key{
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathForDataFile]];
    //Convert NSNumber object back to int
    NSNumber *loadedNumberObject = [tempDic2 objectForKey:key];
    int loadedNumber = (int) [loadedNumberObject integerValue];
    [tempDic2 release];
    return loadedNumber;
}
//SAVE NUMBERS (int)


//SAVE NUMBERS (float)
-(void) saveFloat:(float) number withKey:(NSString*) key{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self pathForDataFile]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathForDataFile]];
    }
    //turn passed Float into NSNumber object
    NSNumber *numberObject = [NSNumber numberWithFloat:number];
    [tempDic setObject:numberObject forKey:key];
    [tempDic writeToFile:[self pathForDataFile] atomically:YES];
    [tempDic release];
}
-(float) loadFloatForKey:(NSString*) key{
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    //Convert NSNumber object back to int
    NSNumber *loadedNumberObject = [tempDic2 objectForKey:key];
    float loadedNumber = (float) [loadedNumberObject floatValue];
    [tempDic2 release];
    return loadedNumber;
}
//SAVE NUMBERS (float)

 
-(void) dealloc {
	[super dealloc];
}

@end
