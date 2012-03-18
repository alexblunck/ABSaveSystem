//
//  ViewController.m
//  SaveExample
//
//  Created by Alexander Blunck on 18.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@implementation ViewController

//Load Data
-(IBAction) loadData:(id)sender {
    Person *loadedPerson = [NSKeyedUnarchiver unarchiveObjectWithData:[saveSystem loadDataForKey:@"person"]];
    NSString *formatedString = [NSString stringWithFormat:@"%@, %i", loadedPerson.name, loadedPerson.age];
    label.text = formatedString;
}

//Save Data
-(IBAction) saveData:(id)sender {
    Person *newPerson = [Person new];
    newPerson.name = nameField.text;
    newPerson.age = [ageField.text intValue];
    
    NSData *personData = [NSKeyedArchiver archivedDataWithRootObject:newPerson];
    
    [saveSystem saveData:personData withKey:@"person"];
}

- (void)viewDidLoad{   
    [super viewDidLoad];
    
    //Allocate the SaveSystem
    saveSystem = [[ABLFXSaveSystem alloc] initWithOS:ssIOS];
    
    //Load the Person Object with the key "person"
    Person *loadedPerson = [NSKeyedUnarchiver unarchiveObjectWithData:[saveSystem loadDataForKey:@"person"]];
    NSString *formatedString = [NSString stringWithFormat:@"%@, %i", loadedPerson.name, loadedPerson.age];
    if (![formatedString isEqualToString:@"(null), 0"]) {
        label.text = formatedString;
    } else {
        label.text = @"Nothing Saved";
    }
    
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
