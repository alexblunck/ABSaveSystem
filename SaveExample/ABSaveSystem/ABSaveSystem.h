//
//  AblfxSaveSystemIOS.h
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {ssIOS, ssMAC} ssOS;

@interface ABSaveSystem : NSObject {
    ssOS operatingSystem;
}

+(id) saveSystem;

-(void) saveData:(NSData *)data withKey:(NSString *)key fileName:(NSString*)fileName;
-(void) saveData:(NSData*)data withKey:(NSString*)key;
-(NSData*) loadDataForKey:(NSString*)key fileName:(NSString*)fileName;
-(NSData*) loadDataForKey:(NSString*)key;

//Helper Methods
-(void) saveBool:(BOOL) boolean withKey:(NSString*) key;
-(BOOL) loadBoolForKey:(NSString*) key;

-(void) saveString:(NSString*) string withKey:(NSString*) key;
-(NSString*) loadStringForKey:(NSString*) key;

-(void) saveINT:(int) number withKey:(NSString*) key;
-(int) loadINTForKey:(NSString*) key;

-(void) saveFloat:(float) number withKey:(NSString*) key;
-(float) loadFloatForKey:(NSString*) key;

@property (nonatomic, strong) NSString *superFileName;
@property (nonatomic) ssOS superOS;

@end
