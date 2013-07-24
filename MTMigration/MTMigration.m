//
//  MTMigration.m
//  Tracker
//
//  Created by Parker Wightman on 2/7/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTMigration.h"

#define MT_MIGRATION_LAST_VERSION_KEY @"MTMigration.lastMigrationVersion"
#define MT_MIGRATION_APP_VERSION_KEY @"MTMigration.appVersion"
#define MT_MIGRATION_LAST_APP_VERSION_KEY @"MTMigration.lastAppVersion"

@implementation MTMigration

+ (void) migrateToVersion:(NSString *)version block:(void (^)())migrationBlock {
	// version > lastMigrationVersion && version <= appVersion
    if ([version compare:[self lastMigrationVersion] options:NSNumericSearch] == NSOrderedDescending &&
        [version compare:[self appVersion] options:NSNumericSearch]           != NSOrderedDescending) {
		
            migrationBlock();

		
            #if DEBUG
                NSLog(@"MTMigration: Running migration for version %@", version);
            #endif
		
		
            [self setLastMigrationVersion:version];
	}
}


+ (void) applicationUpdateBlock:(void (^)())updateBlock {
    if (![[self lastAppVersion] isEqualToString:[self appVersion]]) {
        
        updateBlock();
        
        #if DEBUG
            NSLog(@"MTMigration: Running update Block");
        #endif
        
        [self setLastAppVersion:[self appVersion]];
    }
}



+ (void) reset {
    [self setLastMigrationVersion:nil];
}




+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (void) setLastMigrationVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:MT_MIGRATION_LAST_VERSION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) lastMigrationVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MT_MIGRATION_LAST_VERSION_KEY];

    return (res ? res : @"");
}

+ (void)setLastAppVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:MT_MIGRATION_LAST_APP_VERSION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) lastAppVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MT_MIGRATION_LAST_APP_VERSION_KEY];
    
    return (res ? res : @"");
}

@end
