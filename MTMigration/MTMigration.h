//
//  MTMigration.h
//  Tracker
//
//  Created by Parker Wightman on 2/7/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^MTExecutionBlock)(void);


@interface MTMigration : NSObject

+ (void) migrateToVersion:(NSString *)version block:(MTExecutionBlock)migrationBlock;

+ (void) applicationUpdateBlock:(MTExecutionBlock)updateBlock;

+ (void) reset;

@end
