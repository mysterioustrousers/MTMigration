//
//  MTMigration.h
//  Tracker
//
//  Created by Parker Wightman on 2/7/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMigration : NSObject

+ (void) migrateToVersion:(NSString *)version block:(void (^)())migrationBlock;

+ (void) reset;

@end
