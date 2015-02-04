MTMigration
===========

Manages blocks of code that need to run once on version updates in iOS apps. This could be anything from data
normalization routines, "What's New In This Version" screens, or bug fixes.

## Installation

MTMigration can be installed one of two ways:

* Add `pod "MTMigration"` to your [Podfile](http://cocoapods.org), import as necessary with: `#import <MTMigration/MTMigration.h>`.
* Add `MTMigration.{h,m}` to your project, import as necessary with: `#import "MTMigration.h"`.

## Usage

If you need a block that runs every time your application version changes, pass that block to
the `applicationUpdateBlock:` method.

```objc
[MTMigration applicationUpdateBlock:^{
    [metrics resetStats];
}];
```

If a block is specific to a version, use `migrateToVersion:block:` and MTMigration will
ensure that the block of code is only ever run once for that version.

```objc
[MTMigration migrateToVersion:@"1.1" block:^{
    [newness presentNewness];
}];
```

You would want to run this code in your app delegate or similar.

Parallel methods for `migrateToBuild:block:` are also available.

Because MTMigration inspects your *-info.plist file for your actual version number and keeps track of the last migration,
it will migrate all un-migrated blocks inbetween. For example, let's say you had the following migrations:

```objc
[MTMigration migrateToVersion:@"0.9" block:^{
    // Some 0.9 stuff
}];

[MTMigration migrateToVersion:@"1.0" block:^{
    // Some 1.0 stuff
}];
```

If a user was at version `0.8`, skipped `0.9`, and upgraded to `1.0`, then both the `0.9` *and* `1.0` blocks would run.

For debugging/testing purposes, you can call `reset` to clear out the last migration MTMigration remembered, causing all
migrations to run from the beginning:

```objc
[MTMigration reset];
```

## Notes

MTMigration assumes version numbers are incremented in a logical way, i.e. `1.0.1` -> `1.0.2`, `1.1` -> `1.2`, etc.

Version numbers that are past the version specified in your app will not be run. For example, if your *-info.plist file
specifies `1.2` as the app's version number, and you attempt to migrate to `1.3`, the migration will not run.

Blocks are executed on the thread the migration is run on. Background/foreground situations should be considered accordingly.

## Contributing

This library does not handle some more intricate migration situations, if you come across intricate use cases from your own
app, please add it and submit a pull request. Be sure to add test cases.

## Contributors

- [Parker Wightman](https://github.com/pwightman) ([@parkerwightman](http://twitter.com/parkerwightman))
- [Good Samaritans](https://github.com/mysterioustrousers/MTMigration/contributors)
- [Hector Zarate](https://github.com/Hecktorzr)
- [Sandro Meier](https://github.com/fechu)
