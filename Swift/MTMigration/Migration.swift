import Foundation

public typealias ExecutionClosure = () -> Void

private let MigrationLastVersionKey = "Migration.lastMigrationVersion"
private let MigrationLastAppVersionKey = "Migration.lastAppVersion"

private let MigrationLastBuildKey = "Migration.lastMigrationBuild"
private let MigrationLastAppBuildKey = "Migration.lastAppBuild"

public struct Migration {
    
    static var AppBundle: NSBundle = NSBundle.mainBundle()
    
    public static func migrateToVersion(version: String, closure: ExecutionClosure) {
        if version.compare(self.lastMigrationVersion, options: [.NumericSearch]) == .OrderedDescending &&
            version.compare(self.appVersion, options: [.NumericSearch]) != .OrderedDescending {
                closure()
                self.setLastMigrationVersion(version)
        }
    }
    
    public static func migrateToBuild(build: String, closure: ExecutionClosure) {
        if build.compare(self.lastMigrationBuild, options: [.NumericSearch]) == .OrderedDescending &&
            build.compare(self.appBuild, options: [.NumericSearch]) != .OrderedDescending {
                closure()
                self.setLastMigrationBuild(build)
        }
    }
    
    public static func applicationUpdate(closure: ExecutionClosure) {
        if self.lastAppVersion != self.appVersion {
            closure()
            self.setLastAppVersion(self.appVersion)
        }
    }
    
    public static func buildNumberUpdate(closure: ExecutionClosure) {
        if self.lastAppBuild != self.appBuild {
            closure()
            self.setLastAppBuild(self.appBuild)
        }
    }
    
    public static func reset() {
        self.setLastAppVersion(nil)
        self.setLastMigrationVersion(nil)
        self.setLastAppBuild(nil)
        self.setLastMigrationBuild(nil)
    }
    
    // MARK: - Private methods and properties
    
    private static var appVersion: String {
        return Migration.AppBundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String ?? ""
    }
    
    private static var appBuild: String {
        return Migration.AppBundle.objectForInfoDictionaryKey("CFBundleVersion") as? String ?? ""
    }
    
    private static func setLastMigrationVersion(version: String?) {
        NSUserDefaults.standardUserDefaults().setValue(version, forKey: MigrationLastVersionKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private static func setLastMigrationBuild(build: String?) {
        NSUserDefaults.standardUserDefaults().setValue(build, forKey: MigrationLastBuildKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private static var lastMigrationVersion: String {
        return NSUserDefaults.standardUserDefaults().valueForKey(MigrationLastVersionKey) as? String ?? ""
    }
    
    private static var lastMigrationBuild: String {
        return NSUserDefaults.standardUserDefaults().valueForKey(MigrationLastBuildKey) as? String ?? ""
    }
    
    private static func setLastAppVersion(version: String?) {
        NSUserDefaults.standardUserDefaults().setValue(version, forKey: MigrationLastAppVersionKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private static func setLastAppBuild(build: String?) {
        NSUserDefaults.standardUserDefaults().setValue(build, forKey: MigrationLastAppBuildKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private static var lastAppVersion: String {
        return NSUserDefaults.standardUserDefaults().valueForKey(MigrationLastAppVersionKey) as? String ?? ""
    }
    
    private static var lastAppBuild: String {
        return NSUserDefaults.standardUserDefaults().valueForKey(MigrationLastAppBuildKey) as? String ?? ""
    }
}
