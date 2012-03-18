//
//  MacViewController.m
//  SaveExample
//
//  Created by Alexander Blunck on 18.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "MacViewController.h"
#import "ABLFXSaveSystem.h"
#import "Person.h"

@implementation MacViewController

-(IBAction)load:(id)sender {
    NSLog(@"load...");
    
    ABLFXSaveSystem *saveSystem = [[ABLFXSaveSystem alloc] initWithOS:ssMAC];
    
    Person *loadedPerson = [NSKeyedUnarchiver unarchiveObjectWithData:[saveSystem loadDataForKey:@"person"]];
    NSString *formatedString = [NSString stringWithFormat:@"%@, %i", loadedPerson.name, loadedPerson.age];
    
    loadField.stringValue = formatedString;
    
    [saveSystem release];
}

-(IBAction)save:(id)sender {
     NSLog(@"save...");
    
    ABLFXSaveSystem *saveSystem = [[ABLFXSaveSystem alloc] initWithOS:ssMAC];
    
    Person *newPerson = [Person new];
    newPerson.name = nameField.stringValue;
    newPerson.age = ageField.intValue;
    
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:newPerson];
    
    [saveSystem saveData:personData withKey:@"person"];
    
    [saveSystem release];
}

@end
