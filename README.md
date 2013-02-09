MTMigration
===========

Manages blocks of code that only need to run once on version updates in iOS apps.

## Installation

MTMigration can be installed one of two ways:

* Add `pod "MTMigration"` to your [Podfile](http://cocoapods.org), import as necessary with: `#import <MTMigration/MTMigration.h>`.
* Add `MTMigration.{h,m}` to your project, import as necessary with: `#import "MTMigration.h"`.

## Usage

By giving a version number and block of code to `migrateToVersion:block:`, MTMigration will ensure that the block of code is
only ever run once.

```objective-c
[MTMigration migrateToVersion:@"1.1" block:^{
    [obj doSomeDataStuff];
}];
```

Because MTMigration inspects your *-info.plist file for your actual version number and keeps track of the last migration, 
it will migrate all un-migrated blocks. For example if you had:

```objective-c
[MTMigration migrateToVersion:@"0.9" block:^{
    // Some 0.9 stuff
}];

[MTMigration migrateToVersion:@"1.0" block:^{
    // Some 1.0 stuff
}];
```

If a user was at version 0.8, skipped 0.9, and upgraded to 1.0, then both the `0.9` *and* `1.0` blocks would run.

You would want to run this in your App Delegate or similar.

## Notes

MTMigration assumes version numbers are incremented in a logical way, i.e. 1.0.1 -> 1.0.2, 1.1 -> 1.2, etc. MTMigration uses
`NSString#compare` to do the comparison. 

Version numbers that are past the version specified in your app will not be run. For example, if your *-info.plist file 
specifies 1.2 as the app's version number, and you attempt to migrate to 1.3, the migration will not run.

Blocks are executed on the main thread. If you have long-running jobs, you'll need to background it yourself.

## Contributing

This library does not handle some more intricate migration situations, if you come across intricate use cases from your own
app, please add it and sumit a pull request. Be sure to add test cases.

## Contributors

[Parker Wightman](https://github.com/pwightman) ([@parkerwightman](http://twitter.com/parkerwightman))
