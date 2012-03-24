//
//  AblfxSaveSystemIOS.h
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {ssIOS, ssMAC} ssOS;

@interface ABLFXSaveSystem : NSObject {
    
}

@property (nonatomic) ssOS operatingSystem;

-(id) initWithOS:(ssOS)operatingSystem ;

-(void) saveData:(NSData*)data withKey:(NSString*)key;
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

@end
