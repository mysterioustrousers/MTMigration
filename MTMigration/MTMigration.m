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

@implementation MTMigration

+ (void) migrateToVersion:(NSString *)version block:(void (^)())migrationBlock {
	// version > lastMigrationVersion && version <= appVersion
	if ([version compare:[self lastMigrationVersion]] == NSOrderedDescending &&
		[version compare:[self appVersion]]           != NSOrderedDescending) {
		
			migrationBlock();
		
		
			#if DEBUG
				NSLog(@"MTMigration: Running migration for version %@", version);
			#endif
		
		
			[self setLastMigrationVersion:version];
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

@end
