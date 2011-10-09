//
//  SaveExampleViewController.h
//  SaveExample
//
//  Created by Alexander Blunck on 7/12/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ABLFXSaveSystemIOS.h"

@interface SaveExampleViewController : UIViewController {
    ABLFXSaveSystemIOS *saveSystem;
    
    IBOutlet UITextField *textField;
    IBOutlet UILabel *label;
}
-(IBAction) saveData:(id) sender;
-(IBAction) loadData:(id) sender;

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *label;

@end
