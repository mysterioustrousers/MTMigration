import XCTest
@testable import MTMigration

class MigrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Migration.reset()
        
        let bundles: [NSBundle] = NSBundle.allBundles().filter {
            return ($0.bundleIdentifier != nil && $0.bundleIdentifier! == "mystrou.MTMigration.MTMigrationTests")
        }
        
        guard let bundle = bundles.first else { XCTFail("No bundle was found."); return }
        
        Migration.AppBundle = bundle
    }
    
    override func tearDown() {
        super.tearDown()
        
        Migration.reset()
    }
    
    func testMigrationReset() {
        let expectation1 = self.expectationWithDescription("Expecting block to be run for version 0.9")
        Migration.migrateToVersion("0.9") { () -> Void in
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectationWithDescription("Expecting block to be run for version 1.0")
        Migration.migrateToVersion("1.0") { () -> Void in
            expectation2.fulfill()
        }
        
        Migration.reset()
        
        let expectation3 = self.expectationWithDescription("Expecting block to be run again for version 0.9")
        Migration.migrateToVersion("0.9") { () -> Void in
            expectation3.fulfill()
        }
        
        let expectation4 = self.expectationWithDescription("Expecting block to be run again for version 1.0")
        Migration.migrateToVersion("1.0") { () -> Void in
            expectation4.fulfill()
        }
        
        self.waitForAllExpectations()
    }
    
    func testMigratesOnFirstRun() {
        let expectation = self.expectationWithDescription("Should execute migration after reset")
        Migration.migrateToVersion("1.0") { () -> Void in
            expectation.fulfill()
        }
        
        self.waitForAllExpectations()
    }
    
    func testMigratesOnce() {
        let expectation = self.expectationWithDescription("Expecting block to be run")
        Migration.migrateToVersion("1.0") { () -> Void in
            expectation.fulfill()
        }
        
        Migration.migrateToVersion("1.0") { () -> Void in
            XCTFail("Should not execute a block for the same version twice")
        }
        
        self.waitForAllExpectations()
    }
    
    func testMigratesPreviousBlocks() {
        let expectation1 = self.expectationWithDescription("Expecting block to be run for version 0.9")
        Migration.migrateToVersion("0.9") { () -> Void in
            expectation1.fulfill()
        }
        
        let expectation2 = self.expectationWithDescription("Expecting block to be run for version 1.0")
        Migration.migrateToVersion("1.0") { () -> Void in
            expectation2.fulfill()
        }
        
        self.waitForAllExpectations()
    }
    
    func testMigratesInNaturalSortOrder() {
        let expectation1 = self.expectationWithDescription("Expecting block to be run for version 0.9")
        Migration.migrateToVersion("0.9") { () -> Void in
            expectation1.fulfill()
        }
        
        Migration.migrateToVersion("0.1") { () -> Void in
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectation2 = self.expectationWithDescription("Expecting block to be run for version 0.10")
        Migration.migrateToVersion("0.10") { () -> Void in
            expectation2.fulfill()
        }
        
        self.waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockOnce() {
        let expectation = self.expectationWithDescription("Should only call block once")
        Migration.applicationUpdate { () -> Void in
            expectation.fulfill()
        }
        
        Migration.applicationUpdate { () -> Void in
            XCTFail("Expected applicationUpdate to be called only once")
        }
        
        self.waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockeOnlyOnceWithMultipleMigrations() {
        Migration.migrateToVersion("0.8") { () -> Void in
            // Do something
        }
        
        Migration.migrateToVersion("0.9") { () -> Void in
            // Do something
        }
        
        Migration.migrateToVersion("0.10") { () -> Void in
            // Do something
        }
        
        let expectation = self.expectationWithDescription("Should call the applicationUpdate only once no matter how many migrations have to be done")
        Migration.applicationUpdate { () -> Void in
            expectation.fulfill()
        }
        
        self.waitForAllExpectations()
    }
    
    func waitForAllExpectations() {
        self.waitForExpectationsWithTimeout(2.0) { (error: NSError?) -> Void in
            if let error = error {
                print(error)
            }
        }
    }
    
}
