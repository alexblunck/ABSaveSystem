//
//  ABLFXSaveSystemIOS.m
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import "ABLFXSaveSystem.h"

#define APPNAME @"AppName"

@implementation ABLFXSaveSystem

@synthesize operatingSystem=_operatingSystem;

-(id) initWithOS:(ssOS)operatingSystem {
    self.operatingSystem = operatingSystem;
    return self;
}

-(id) init {self = [super init];if (self) {
    NSLog(@"ABLFXSaveSystem: use 'initWithOS:(ssOS)operatingSystem' initializer!");
}return self;}

-(NSString*) getPath {
    if (self.operatingSystem == ssIOS) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@.plist", APPNAME];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName]; 
        return path;
    } else if (self.operatingSystem == ssMAC) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //I'd recommend changing "AppName" to your apps name
        NSString *folder = [NSString stringWithFormat:@"~/Library/Application Support/%@/", APPNAME];
        folder = [folder stringByExpandingTildeInPath];
        if ([fileManager fileExistsAtPath: folder] == NO){
            [fileManager createDirectoryAtPath: folder withIntermediateDirectories:NO attributes:nil error:nil];
        }
        //I'd recommend changing "AppName" to your apps name
        NSString *fileName = [NSString stringWithFormat:@"%@.plist", APPNAME];
        return [folder stringByAppendingPathComponent: fileName];  
    } else {
        NSLog(@"ABLFXSaveSystem: Operating System not set! --- Don't forget following when allocating the SaveSystem: [[ABLFXSaveSystem alloc] initWithOS:ssIOS]; or [[ABLFXSaveSystem alloc] initWithOS:ssMAC];");
    }
    
    //Shouldn't happen:
    return nil;
}


-(void) saveData:(NSData*)data withKey:(NSString*)key {
    //Check if file exits, if so init Dictionary with it's content, otherwise allocate new one
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self getPath]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:data forKey:key];
    [tempDic writeToFile:[self getPath] atomically:YES];
    
    //Release allocated Dictionary
    [tempDic release];
}

-(NSData*) loadDataForKey:(NSString*)key {
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    NSData *loadedData = [tempDic objectForKey:key];
    return loadedData;
}

//Helper Methods for the fast saving of Strings, int's and float's
//SAVE STRINGS
-(void) saveString:(NSString*) string withKey:(NSString*) key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:string];
    [self saveData:data withKey:key];
}
-(NSString*) loadStringForKey:(NSString*) key {
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    NSData *loadedData = [tempDic objectForKey:key];
    NSString *loadedString = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    
    [tempDic release];
    
    return loadedString;
}
//SAVE STRINGS END


//SAVE NUMBERS (int)
-(void) saveINT:(int) number withKey:(NSString*) key{
    NSNumber *numberObject = [NSNumber numberWithInt:number];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:numberObject];
    [self saveData:data withKey:key];
}
-(int) loadINTForKey:(NSString*) key{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    NSData *loadedData = [tempDic objectForKey:key];
    NSNumber *loadedNumberObject = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    
    //Convert NSNumber object back to int
    int loadedNumber = (int) [loadedNumberObject intValue];
    
    [tempDic release];
    
    return loadedNumber;
}
//SAVE NUMBERS (int) END


//SAVE NUMBERS (float)
-(void) saveFloat:(float) number withKey:(NSString*) key{
    NSNumber *numberObject = [NSNumber numberWithFloat:number];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:numberObject];
    [self saveData:data withKey:key];
}
-(float) loadFloatForKey:(NSString*) key{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath]];
    NSData *loadedData = [tempDic objectForKey:key];
    NSNumber *loadedNumberObject = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    
    //Convert NSNumber object back to int
    float loadedNumber = (float) [loadedNumberObject floatValue];
    
    [tempDic release];
    
    return loadedNumber;
}
//SAVE NUMBERS (float) END

 
-(void) dealloc {
	[super dealloc];
}

@end