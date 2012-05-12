//
//  ABSaveSystem.m
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import "ABSaveSystem.h"
#import "NSData+AES256.h"

#define APPNAME @"AppName"
#define OS @"IOS" /* @"IOS" for iPhone/iPad/iPod & @"MAC" for mac */
#define AESKEY @"MyKeyHere"

@implementation ABSaveSystem

@synthesize superFileName=_superFileName, superOS=_superOS;

+(id) saveSystem {
    return [[self alloc] init];
}

-(id) init {
    self = [super init];
    if (self) {
        if (OS == @"IOS") {
            operatingSystem = ssIOS;
        } else if (OS == @"MAC") {
            operatingSystem = ssMAC;
        } else {
            NSLog(@"ABSaveSystem: OS not set!");
        }
        
        self.superFileName = nil;
    }
    return self;
}

-(NSString*) getPath:(NSString*)fileName {
    
    NSString *returnString;
    
    //If a superOS has been set use that
    if (self.superOS == ssIOS || self.superOS == ssMAC) {
        operatingSystem = self.superOS;
    }
    
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
        NSString *fullFileName = [NSString stringWithFormat:@"%@.absave", fn];
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
        NSString *fullFileName = [NSString stringWithFormat:@"%@.absave", fn];
        returnString = [folder stringByAppendingPathComponent:fullFileName];  
    } else {
        NSLog(@"ABSaveSystem: Operating System not set!");
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
        NSData *binaryFile = [NSData dataWithContentsOfFile:[self getPath:fileName]];
        NSData *dataKey = [[NSString stringWithString:AESKEY] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *decryptedData = [binaryFile decryptedWithKey:dataKey];
        tempDic = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:data forKey:key];
    //[tempDic writeToFile:[self getPath:fileName] atomically:YES];
    
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:tempDic];
    
    NSData *dataKey = [[NSString stringWithString:AESKEY] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [dicData encryptedWithKey:dataKey];
    
    [encryptedData writeToFile:[self getPath:fileName] atomically:YES];
    
    //Release allocated Dictionary
    //[tempDic release];
}

-(void) saveData:(NSData*)data withKey:(NSString*)key {
    [self saveData:data withKey:key fileName:nil];
}

-(NSData*) loadDataForKey:(NSString*)key fileName:(NSString*)fileName {
    NSData *binaryFile = [NSData dataWithContentsOfFile:[self getPath:fileName]];
    NSData *dataKey = [[NSString stringWithString:AESKEY] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = [binaryFile decryptedWithKey:dataKey];
    
    NSMutableDictionary *tempDic = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
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