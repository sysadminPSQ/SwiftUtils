Pod::Spec.new do |s|

  s.name         = 'SwiftUtils'
  s.version      = '0.0.1'
  s.summary      = 'A short description of SwiftUtils.'
  s.homepage     = 'http://github.com/sysadminPSQ/SwiftUtils'
  s.license      = 'MIT'
  s.author       = { 'Akash K' => 'akash@peppersquare.com' }
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/sysadminPSQ/SwiftUtils.git', :tag => '0.0.1' }
  s.source_files  = 'SwiftUtils', 'SwiftUtils/**/*.{swift}'
  s.frameworks = 'SystemConfiguration', 'UIKit'
  s.dependency 'Parse'
  s.dependency 'LogKit'
  s.preserve_paths = 'SwiftUtils.framework'
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/SwiftUtils' }
  s.requires_arc = true

end
