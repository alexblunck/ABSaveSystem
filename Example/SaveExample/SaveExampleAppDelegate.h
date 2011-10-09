//
//  SaveExampleAppDelegate.h
//  SaveExample
//
//  Created by Alexander Blunck on 7/12/11.
//  Copyright 2011 ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SaveExampleViewController;

@interface SaveExampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SaveExampleViewController *viewController;

@end
