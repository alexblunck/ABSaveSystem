//
//  ABLFXSaveSystemIOS.m
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import "ABSaveSystem.h"

#define APPNAME @"PastryPanic"
#define OS @"IOS" /* @"IOS" for iPhone/iPad/iPod & @"MAC" for mac */

@implementation ABSaveSystem

@synthesize superFileName=_superFileName;

+(id) saveSystem {
    return [[self alloc] init];
}

-(id) init {
    self = [super init];
    if (self) {
        operatingSystem = ([OS isEqualToString:@"IOS"]) ? ssIOS : ssMAC;
        self.superFileName = nil;
    }
    return self;
}

-(NSString*) getPath:(NSString*)fileName {
    
    NSString *returnString;
    
    //If a superFileName has been set use that, otherwise use basic one or one specified by method input
    NSString *fn;
    if (self.superFileName == nil) {
        fn = (fileName != nil) ? fileName : APPNAME;
    } else {
        fn = self.superFileName;
    }
    
    if (operatingSystem == ssIOS) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullFileName = [NSString stringWithFormat:@"%@.plist", fn];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:fullFileName]; 
        returnString = path;
    } else if (operatingSystem == ssMAC) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //I'd recommend changing "AppName" to your apps name
        NSString *folder = [NSString stringWithFormat:@"~/Library/Application Support/%@/", fn];
        folder = [folder stringByExpandingTildeInPath];
        if ([fileManager fileExistsAtPath: folder] == NO){
            [fileManager createDirectoryAtPath: folder withIntermediateDirectories:NO attributes:nil error:nil];
        }
        //I'd recommend changing "AppName" to your apps name
        NSString *fullFileName = [NSString stringWithFormat:@"%@.plist", fn];
        returnString = [folder stringByAppendingPathComponent:fullFileName];  
    } else {
        NSLog(@"ABLFXSaveSystem: Operating System not set!");
    }
    
    //Shouldn't happen:
    return returnString;
}

-(void) saveData:(NSData *)data withKey:(NSString *)key fileName:(NSString*)fileName {
    //Check if file exits, if so init Dictionary with it's content, otherwise allocate new one
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self getPath:fileName]];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath:fileName]];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:data forKey:key];
    [tempDic writeToFile:[self getPath:fileName] atomically:YES];
    
    //Release allocated Dictionary
    //[tempDic release];
}

-(void) saveData:(NSData*)data withKey:(NSString*)key {
    [self saveData:data withKey:key fileName:nil];
}

-(NSData*) loadDataForKey:(NSString*)key fileName:(NSString*)fileName {
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPath:fileName]];
    NSData *loadedData = [tempDic objectForKey:key];
    
    //[tempDic release];
    
    return loadedData;
}

-(NSData*) loadDataForKey:(NSString*)key {
    return [self loadDataForKey:key fileName:nil];
}

//Helper Methods for the fast saving of booleans, strings, int's and float's

//SAVE BOOLEAN 's
-(void) saveBool:(BOOL) boolean withKey:(NSString*) key {
    NSNumber *boolNumber = [NSNumber numberWithBool:boolean];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:boolNumber];
    [self saveData:data withKey:key];
}
-(BOOL) loadBoolForKey:(NSString*) key {
    NSData *loadedData = [self loadDataForKey:key];
    NSNumber *boolean;
    if (loadedData != NULL) {
        boolean = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    } else {
        boolean = [NSNumber numberWithBool:NO];
    }
    
    return [boolean boolValue];
}
//SAVE BOOLEAN 's END


//SAVE STRINGS
-(void) saveString:(NSString*) string withKey:(NSString*) key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:string];
    [self saveData:data withKey:key];
}
-(NSString*) loadStringForKey:(NSString*) key {
    NSData *loadedData = [self loadDataForKey:key];
    NSString *loadedString;
    if (loadedData != NULL) {
        loadedString = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    } else {
        loadedString = @"N/A";
    }
    
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
    NSData *loadedData = [self loadDataForKey:key];
    NSNumber *loadedNumberObject;
    if (loadedData != NULL) {
        loadedNumberObject = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    } else {
        loadedNumberObject = [NSNumber numberWithInt:0];
    }
    //Convert NSNumber object back to int
    int loadedNumber = (int) [loadedNumberObject intValue];
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
    NSData *loadedData = [self loadDataForKey:key];
    NSNumber *loadedNumberObject;
    if (loadedData != NULL) {
        loadedNumberObject = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    } else {
        loadedNumberObject = [NSNumber numberWithFloat:0];
    }
    //Convert NSNumber object back to int
    float loadedNumber = (float) [loadedNumberObject floatValue];
    return loadedNumber;
}
//SAVE NUMBERS (float) END

 
-(void) dealloc {
	[super dealloc];
}

@end