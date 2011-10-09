//
//  SaveExampleViewController.m
//  SaveExample
//
//  Created by Alexander Blunck on 7/12/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import "SaveExampleViewController.h"

@implementation SaveExampleViewController

@synthesize textField, label;

-(IBAction) loadData:(id)sender {
    NSString *converterString = [saveSystem loadStringForKey:@"savedData"];
    [label setText:converterString];
    if ([converterString integerValue]) {
        NSLog(@"number");
    }
}

-(IBAction) saveData:(id)sender {
    [saveSystem saveString:textField.text withKey:@"savedData"];
    
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    saveSystem = [ABLFXSaveSystemIOS alloc];
    NSLog(@"SaveSystem allocated");
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
