MTMigration
===========

Manages blocks of code that only need to run once on version updates in iOS apps.

## Installation

MTMigration can be installed one of two ways:

* Add `pod "MTMigration` to your [Podfile](http://cocoapods.org), import as necessary with: `#import <MTMigration/MTMigration.h>`.
* Add `MTMigration.{h,m}` to your project, import as necessary with: `#import "MTMigration.h"`.

## Usage

By giving a version number and block of code to `migrateToVersion:block:`, MTMigration will ensure that the block of code is
only ever run once.

```objective-c
[MTMigration migrateToVersion:@"1.1" block:^{
  [obj doSomeDataStuff];
}];
```

## Notes

MTMigration assumes version numbers are incremented in a logical way, i.e. 1.0.1 -> 1.0.2, 1.1 -> 1.2, etc. MTMigration uses
`NSString#compare` to do the comparison. Version numbers that are past the version specified in your app will not be run. For
example, if your *-info.plist file specifies 1.2 as the app's version number, and you attempt to migrate to 1.3, the migration
will not run.
