//
//  ViewController.h
//  SaveExample
//
//  Created by Alexander Blunck on 18.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ABSaveSystem.h"

@interface ViewController : UIViewController {
    ABSaveSystem *saveSystem;

    IBOutlet UITextField *nameField;
    IBOutlet UITextField *ageField;
    IBOutlet UILabel *label;
}
-(IBAction) saveData:(id) sender;
-(IBAction) loadData:(id) sender;


@end
