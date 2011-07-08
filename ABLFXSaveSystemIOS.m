//
//  ABLFXSaveSystemIOS.m
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import "AblfxSaveSystemIOS.h"

@implementation AblfxSaveSystemIOS

-(id) init {self = [super init];if (self) { 
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    //edit following if you want a different name for the saved file
    path = [documentsDirectory stringByAppendingPathComponent:@"ABLFXSaveSystem.plist"]; 
}return self;}

//SAVE STRINGS
-(void) saveString:(NSString*) string withKey:(NSString*) key {
    //Check if file exits, if so init Dictionary with it's content, otherwise allocate new one
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    
    //Populate Dictionary with to save value/key and write to file
    [tempDic setObject:string forKey:key];
    [tempDic writeToFile:path atomically:YES];
    
    //Release allocated Dictionary
    [tempDic release];
    
}
-(NSString*) loadStringForKey:(NSString*) key {
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSString *loadedString = [tempDic2 objectForKey:key];
    //[tempDic2 release];
    return loadedString;
}
//SAVE STRINGS END


//SAVE NUMBERS (int)
-(void) saveINT:(int) number withKey:(NSString*) key{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    //turn passed INT into NSNumber object
    NSNumber *numberObject = [NSNumber numberWithInt:number];
    [tempDic setObject:numberObject forKey:key];
    [tempDic writeToFile:path atomically:YES];
    
    [tempDic release];
}
-(int) loadINTForKey:(NSString*) key{
    NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    //Convert NSNumber object back to int
    NSNumber *loadedNumberObject = [tempDic2 objectForKey:key];
    int loadedNumber = (int) [loadedNumberObject integerValue];
    [tempDic2 release];
    return loadedNumber;
}
//SAVE NUMBERS (int) END


//SAVE NUMBERS (float)
-(void) saveFloat:(float) number withKey:(NSString*) key{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSMutableDictionary *tempDic;
    if (fileExists == NO) {
        tempDic = [[NSMutableDictionary alloc] init];
    } else {
        tempDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    //turn passed Float into NSNumber object
    NSNumber *numberObject = [NSNumber numberWithFloat:number];
    [tempDic setObject:numberObject forKey:key];
    [tempDic writeToFile:path atomically:YES];
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
//SAVE NUMBERS (float) END

 
-(void) dealloc {
	[super dealloc];
}

@end
