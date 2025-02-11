#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_linkid_gami.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_linkid_gami'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.preserve_paths = 'linkid_mmp_internal.xcframework/**/*', 'LinkIdDigitalFootprintInternal.xcframework/**/*', 'UnityFramework.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework linkid_mmp_internal -framework LinkIdDigitalFootprintInternal -framework UnityFramework' }
  s.vendored_frameworks = 'linkid_mmp_internal.xcframework','LinkIdDigitalFootprintInternal.xcframework','UnityFramework.xcframework'
  
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
