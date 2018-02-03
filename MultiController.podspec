

Pod::Spec.new do |s|

  s.name         = "MultiController"
  s.version      = "0.0.1"
  s.summary      = "Scrollview of Multiple controller."

  s.homepage     = "https://github.com/luhongxin/MultiController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "lhx" => "luhongxin1030@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/luhongxin/MultiController.git", :tag => "#{s.version}" }

  s.source_files  = "MultiController/MultiController/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"

  s.framework  = "UIKit"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
