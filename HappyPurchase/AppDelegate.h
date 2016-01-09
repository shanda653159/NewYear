//
//  AppDelegate.h
//  HappyPurchase
//
//  Created by LD on 15/12/8.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//首页与超值购公用一个控制器
//判断当前navigationcontroller是否首页的navigationcontroller
@property (nonatomic,assign) BOOL isHomePage;

@end

