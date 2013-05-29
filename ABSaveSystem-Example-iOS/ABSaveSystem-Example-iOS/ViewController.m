//
//  ViewController.m
//  ABSaveSystem-Example-iOS
//
//  Created by Alexander Blunck on 5/29/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import "ViewController.h"

//1. Import ABSaveSystem header
#import "ABSaveSystem.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Save Data
    //See ABSaveSystem.h for all available methods
    
    //Save NSArray
    [ABSaveSystem saveObject:@[@"One", @"Two", @"Three"] key:@"myArray"];
    
    //Save NSDate
    [ABSaveSystem saveDate:[NSDate date] key:@"myDate"];
    
    //Save Boolean
    [ABSaveSystem saveBool:YES key:@"myBool"];
    
    //Save Integer
    [ABSaveSystem saveInteger:23 key:@"myInteger"];
    
    //Save Float
    [ABSaveSystem saveFloat:10.0f key:@"myFloat"];
    
    
    //Load Data
    NSArray *myArray = [ABSaveSystem objectForKey:@"myArray"];
    NSDate *myDate = [ABSaveSystem dateForKey:@"myDate"];
    BOOL myBool = [ABSaveSystem boolForKey:@"myBool"];
    NSInteger myInteger = [ABSaveSystem integerForKey:@"myInteger"];
    CGFloat myFloat = [ABSaveSystem floatForKey:@"myFloat"];
    
    NSLog(@"Loaded Object:%@", myArray);
    NSLog(@"Loaded NSDate:%@", myDate);
    NSLog(@"Loaded BOOL:%@", (myBool)?@"YES":@"NO");
    NSLog(@"Loaded Integer:%li", (long)myInteger);
    NSLog(@"Loaded CFGloat:%f", myFloat);
    
    
    //Encryption
    //By Default ABSaveSystem saves all data to a binary file unencrypted
    //You can change this behaviour by either adding following before importing the header file:
    //#define ABSS_ENCRYPTION_ENABLED YES or using follwoing method
    NSData *mySecretData = [NSKeyedArchiver archivedDataWithRootObject:@234];
    [ABSaveSystem saveData:mySecretData key:@"boughtCoins" encryption:YES];
    
    NSNumber *boughtCoins = [NSKeyedUnarchiver unarchiveObjectWithData:[ABSaveSystem dataForKey:@"boughtCoins" encryption:YES]];
    NSLog(@"Loaded encrypted NSData:%@", boughtCoins);
    
    
    //Misc
    
    //Log All saved data
    [ABSaveSystem logSavedValues];
    
    //Delete all saved data
    [ABSaveSystem truncate];
}

@end
