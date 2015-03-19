//
//  MTMigration.m
//  Tracker
//
//  Created by Parker Wightman on 2/7/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTMigration.h"


static NSString * const MTMigrationLastVersionKey      = @"MTMigration.lastMigrationVersion";
static NSString * const MTMigrationLastAppVersionKey   = @"MTMigration.lastAppVersion";

static NSString * const MTMigrationLastBuildKey      = @"MTMigration.lastMigrationBuild";
static NSString * const MTMigrationLastAppBuildKey   = @"MTMigration.lastAppBuild";


@implementation MTMigration


+ (void) migrateToVersion:(NSString *)version block:(MTExecutionBlock)migrationBlock {
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


+ (void) migrateToBuild:(NSString *)build block:(MTExecutionBlock)migrationBlock
{
    // build > lastMigrationBuild && build <= appVersion
    if ([build compare:[self lastMigrationBuild] options:NSNumericSearch] == NSOrderedDescending &&
        [build compare:[self appBuild] options:NSNumericSearch]           != NSOrderedDescending) {
        migrationBlock();

        #if DEBUG
            NSLog(@"MTMigration: Running migration for build %@", build);
        #endif

        [self setLastMigrationBuild:build];
    }
}


+ (void) applicationUpdateBlock:(MTExecutionBlock)updateBlock {
    if (![[self lastAppVersion] isEqualToString:[self appVersion]]) {
        updateBlock();

        #if DEBUG
            NSLog(@"MTMigration: Running update Block for version %@", [self appVersion]);
        #endif

        [self setLastAppVersion:[self appVersion]];
    }
}


+ (void) buildNumberUpdateBlock:(MTExecutionBlock)updateBlock {
    if (![[self lastAppBuild] isEqualToString:[self appBuild]]) {
        updateBlock();
        
        #if DEBUG
            NSLog(@"MTMigration: Running update Block for build %@", [self appBuild]);
        #endif
        
        [self setLastAppBuild:[self appBuild]];
    }
}


+ (void) reset {
    [self setLastMigrationVersion:nil];
    [self setLastAppVersion:nil];
    [self setLastMigrationBuild:nil];
    [self setLastAppBuild:nil];
}


+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}


+ (NSString *)appBuild {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}


+ (void) setLastMigrationVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:MTMigrationLastVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void) setLastMigrationBuild:(NSString *)build {
    [[NSUserDefaults standardUserDefaults] setValue:build forKey:MTMigrationLastBuildKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *) lastMigrationVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MTMigrationLastVersionKey];

    return (res ? res : @"");
}


+ (NSString *) lastMigrationBuild {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MTMigrationLastBuildKey];

    return (res ? res : @"");
}


+ (void)setLastAppVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:MTMigrationLastAppVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setLastAppBuild:(NSString *)build {
    [[NSUserDefaults standardUserDefaults] setValue:build forKey:MTMigrationLastAppBuildKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *) lastAppVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MTMigrationLastAppVersionKey];

    return (res ? res : @"");
}


+ (NSString *) lastAppBuild {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:MTMigrationLastAppBuildKey];

    return (res ? res : @"");
}


@end
