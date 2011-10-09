//
//  AblfxSaveSystemIOS.h
//
//  Created by Alexander Blunck on 7/07/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ABLFXSaveSystemIOS : NSObject {
}

-(void) saveString:(NSString*) string withKey:(NSString*) key;
-(NSString*) loadStringForKey:(NSString*) key;

-(void) saveINT:(int) number withKey:(NSString*) key;
-(int) loadINTForKey:(NSString*) key;

-(void) saveFloat:(float) number withKey:(NSString*) key;
-(float) loadFloatForKey:(NSString*) key;

@end
