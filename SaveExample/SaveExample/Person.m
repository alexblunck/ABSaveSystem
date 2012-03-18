//
//  Person.m
//  SaveExample
//
//  Created by Alexander Blunck on 18.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name=_name, age=_age;

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        NSNumber *numberObject;
        numberObject = [aDecoder decodeObjectForKey:@"age"];
        self.age = [numberObject intValue];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    NSNumber *numberObject = [NSNumber numberWithInt:self.age];
    [aCoder encodeObject:numberObject forKey:@"age"];
}

@end
