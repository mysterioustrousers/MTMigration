Pod::Spec.new do |s|
  s.name         = "MTMigrationSwift"
  s.version      = "0.0.5"
  s.summary      = "Manages blocks of code that only need to run once on version updates in iOS apps."
  s.homepage     = "https://github.com/mysterioustrousers/MTMigration"
  s.license      = 'MIT'
  s.author       = { "Parker Wightman" => "parkerwightman@gmail.com" }
  s.source       = { :git => "https://github.com/mysterioustrousers/MTMigration.git", :tag => "#{s.version}" }
  s.source_files = 'Swift/MTMigration/Migration.swift'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_WHOLE_MODULE_OPTIMIZATION' => 'YES',
                            'APPLICATION_EXTENSION_API_ONLY' => 'YES' }
end
