//
//  AppDelegate.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/13.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

