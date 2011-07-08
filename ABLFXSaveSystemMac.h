//
//  ABLFXSaveSystemMac.h
//
//  Created by Alexander Blunck on 5/11/11.
//  Copyright 2011 ablfx. All rights reserved.
//	http://www.ablfx.com

#import <Foundation/Foundation.h>


@interface AblfxSaveSystem : NSObject {

}

- (NSString *) pathForDataFile;

-(void) saveString:(NSString*) string withKey:(NSString*) key;
-(NSString*) loadStringForKey:(NSString*) key;

-(void) saveINT:(int) number withKey:(NSString*) key;
-(int) loadINTForKey:(NSString*) key;

-(void) saveFloat:(float) number withKey:(NSString*) key;
-(float) loadFloatForKey:(NSString*) key;

@end
