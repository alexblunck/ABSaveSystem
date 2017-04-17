ABSaveSystem
==
ABSaveSystem - Obj-C Helper class for iOS and Mac OS X to save NSData, other Objects and primitive data types to persistant storage.


### Basics
ABSaveSystem consists only of static methods, so all you need to do is add the ABSaveSystem .h / .m files and import the header
```objective-c 
#import "ABSaveSystem.h"
```
All data is saved into a binary file named appname.abss, in the Documents directory on iOS or the "Application Support/appname>" directory on OS X.

### Save 
```objective-c
//NSData
[ABSaveSystem saveData:myData key:@"myData"];

//NSString
[ABSaveSystem saveString:@"Hello World" key:@"myString"];

//Object conformign to NSCoding protocol
[ABSaveSystem saveObject:myObject key:@"myObject"];

//NSInteger
[ABSaveSystem saveInteger:23 key:@"myInteger"];

//CGFloat
[ABSaveSystem saveFloat:10.0f key:@"myFloat"];

//BOOL
[ABSaveSystem saveBool:YES key:@"myBool"];

//Check ABSaveSystem header for all available methods
```

### Load
```objective-c
//NSData
NSData *myData = [ABSaveSystem dataForKey:@"myData"];

//NSInteger
NSInteger myInteger = [ABSaveSystem integerForKey:@"myInteger"];

//The other load methods follow the same naming convention
```

### Encryption
```objective-c
/*
By Default ABSaveSystem saves all data to a binary file unencrypted
You can change this behaviour by either adding following directive before importing the header file:
*/
#define ABSS_ENCRYPTION_ENABLED YES 

//...or using following methods to save/load data:

NSData *mySecretData = [NSKeyedArchiver archivedDataWithRootObject:@234];
[ABSaveSystem saveData:mySecretData key:@"boughtCoins" encryption:YES];
    
NSNumber *boughtCoins = [NSKeyedUnarchiver unarchiveObjectWithData:[ABSaveSystem dataForKey:@"boughtCoins" encryption:YES]];
```

## Misc
```objective-c
//Log all saved values
[ABSaveSystem logSavedValues];

//Delete all saved data
[ABSaveSystem truncate];

//Turn off logging, add following directive before importing header:
#define ABSS_LOGGING NO

//Set a custom key for encryption (Recommended), add following directive before importing header:
#define ABSS_AESKEY @"MySecretKey"
```

##### LICENSE
ABSaveSystem is licensed under the MIT License. Check the LICENSE file, of course attribution is always a nice thing.
