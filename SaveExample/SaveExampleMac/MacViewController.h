//
//  MacViewController.h
//  SaveExample
//
//  Created by Alexander Blunck on 18.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MacViewController : NSViewController {
    IBOutlet NSTextField *nameField;
    IBOutlet NSTextField *ageField;
    IBOutlet NSTextField *loadField;
}

-(IBAction)load:(id)sender;
-(IBAction)save:(id)sender;

@end
