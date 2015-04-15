//
//  MTMigrationTests.m
//  MTMigrationTests
//
//  Created by Parker Wightman on 2/7/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTMigrationTests.h"
#import "MTMigration.h"

#define kDefaultWaitForExpectionsTimeout 2.0

@implementation MTMigrationTests

- (void)testMigrationReset
{
	[MTMigration reset];
    
    XCTestExpectation *expectingBlock1Run = [self expectationWithDescription:@"Expecting block to be run for version 0.9"];
	[MTMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock1Run fulfill];
	}];
    
    XCTestExpectation *expectingBlock2Run = [self expectationWithDescription:@"Expecting block to be run for version 1.0"];
	[MTMigration migrateToVersion:@"1.0" block:^{
        [expectingBlock2Run fulfill];
	}];
	
	[MTMigration reset];

    XCTestExpectation *expectingBlock3Run = [self expectationWithDescription:@"Expecting block to be run AGAIN for version 0.9"];
	[MTMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock3Run fulfill];
	}];
    
    XCTestExpectation *expectingBlock4Run = [self expectationWithDescription:@"Expecting block to be run AGAIN for version 1.0"];
	[MTMigration migrateToVersion:@"1.0" block:^{
        [expectingBlock4Run fulfill];
	}];
    
    [self waitForAllExpectations];
}

- (void)testMigratesOnFirstRun
{
	[MTMigration reset];

    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Should execute migration after reset"];
	[MTMigration migrateToVersion:@"1.0" block:^{
        [expectationBlockRun fulfill];
	}];
	
    [self waitForAllExpectations];
}

- (void)testMigratesOnce
{
	[MTMigration reset];
	
    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Expecting block to be run"];
	[MTMigration migrateToVersion:@"1.0" block:^{
        [expectationBlockRun fulfill];
	}];
	
	[MTMigration migrateToVersion:@"1.0" block:^{
        XCTFail(@"Should not execute a block for the same version twice.");
	}];
	
    [self waitForAllExpectations];
}

- (void)testMigratesPreviousBlocks
{
	[MTMigration reset];
	
    XCTestExpectation *expectingBlock1Run = [self expectationWithDescription:@"Expecting block to be run for version 0.9"];
	[MTMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock1Run fulfill];
	}];
	
    XCTestExpectation *expectingBlock2Run = [self expectationWithDescription:@"Expecting block to be run for version 1.0"];
	[MTMigration migrateToVersion:@"1.0" block:^{
        [expectingBlock2Run fulfill];
	}];
	
    [self waitForAllExpectations];
}

- (void)testMigratesInNaturalSortOrder
{
	[MTMigration reset];
	
    XCTestExpectation *expectingBlock1Run = [self expectationWithDescription:@"Expecting block to be run for version 0.9"];
	[MTMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock1Run fulfill];
	}];
    
    [MTMigration migrateToVersion:@"0.1" block:^{
        XCTFail(@"Should use natural sort order, e.g. treat 0.10 as a follower of 0.9");
    }];
	
    XCTestExpectation *expectingBlock2Run = [self expectationWithDescription:@"Expecting block to be run for version 0.10"];
	[MTMigration migrateToVersion:@"0.10" block:^{
        [expectingBlock2Run fulfill];
	}];
	
    [self waitForAllExpectations];
}

- (void)testRunsApplicationUpdateBlockOnce
{
    [MTMigration reset];
    
    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Should only call block once"];
    [MTMigration applicationUpdateBlock:^{
        [expectationBlockRun fulfill];
    }];
    
    [MTMigration applicationUpdateBlock:^{
        XCTFail(@"Expected applicationUpdateBlock to be called only once");
    }];
    
    [self waitForAllExpectations];
}

- (void)testRunsApplicationUpdateBlockeOnlyOnceWithMultipleMigrations
{
	[MTMigration reset];
	
    [MTMigration migrateToVersion:@"0.8" block:^{
		// Do something
	}];
	
	[MTMigration migrateToVersion:@"0.9" block:^{
		// Do something
	}];
	
	[MTMigration migrateToVersion:@"0.10" block:^{
		// Do something
	}];
    
    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Should call the applicationUpdateBlock only once no matter how many migrations have to be done"];
    [MTMigration applicationUpdateBlock:^{
        [expectationBlockRun fulfill];
    }];

    [self waitForAllExpectations];
}

- (void)waitForAllExpectations {
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectionsTimeout handler:^(NSError *error) {
        //do nothing
    }];
}

@end
