//
//  ABLFXSaveSystemIOS.m
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import "ABLFXSaveSystemIOS.h"

@implementation ABLFXSaveSystemIOS

-(id) init {self = [super init];if (self) { 
}return self;}

-(NSString*) getPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ABLFXSaveSystem.plist"]; 
    return path;
}

//SAVE STRINGS
-(void) saveString:(NSString*) string withKey:(NSString*) key {
    //Check if file exits, if so init Dictionary with it's content, otherwise allocate new one
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self getPath]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:string forKey:key];
    [tempDic writeToFile:[self getPath] atomically:YES];
    
    //Release allocated Dictionary
    [tempDic release];
    
}
-(NSString*) loadStringForKey:(NSString*) key {
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    NSString *loadedString = [tempDic2 objectForKey:key];
    //[tempDic2 release];
    return loadedString;
}
//SAVE STRINGS END


//SAVE NUMBERS (int)
-(void) saveINT:(int) number withKey:(NSString*) key{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self getPath]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    }
    //turn passed INT into NSNumber object
    NSNumber *numberObject = [NSNumber numberWithInt:number];
    [tempDic setObject:numberObject forKey:key];
    [tempDic writeToFile:[self getPath] atomically:YES];
    
    [tempDic release];
}
-(int) loadINTForKey:(NSString*) key{
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    //Convert NSNumber object back to int
    NSNumber *loadedNumberObject = [tempDic2 objectForKey:key];
    int loadedNumber = (int) [loadedNumberObject integerValue];
    [tempDic2 release];
    return loadedNumber;
}
//SAVE NUMBERS (int) END


//SAVE NUMBERS (float)
-(void) saveFloat:(float) number withKey:(NSString*) key{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self getPath]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    }
    //turn passed Float into NSNumber object
    NSNumber *numberObject = [NSNumber numberWithFloat:number];
    [tempDic setObject:numberObject forKey:key];
    [tempDic writeToFile:[self getPath] atomically:YES];
    [tempDic release];
}
-(float) loadFloatForKey:(NSString*) key{
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    //Convert NSNumber object back to int
    NSNumber *loadedNumberObject = [tempDic2 objectForKey:key];
    float loadedNumber = (float) [loadedNumberObject floatValue];
    [tempDic2 release];
    return loadedNumber;
}
//SAVE NUMBERS (float) END

 
-(void) dealloc {
	[super dealloc];
}

@end