
Pod::Spec.new do |s|


  s.name         = "ayiSpec"
  s.version      = "1.0.0"
  s.summary      = "哈哈哈哈哈哈"

  s.description  = "测试用的"

  s.homepage     = "https://github.com/twiightzzy/ayiSpecs"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = 'MIT'
  s.author             = { "ayi" => "twilightzzy@126.com" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/twiightzzy/ayiSpecs.git", :tag => "v#{s.version}" }


  

  s.source_files  = "/ayiCamera/ayi/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

 

  s.framework  = "UIKit"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
