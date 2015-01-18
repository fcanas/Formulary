#
#  Be sure to run `pod spec lint Formulary.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Formulary"
  s.version      = "0.0.1"
  s.summary      = "iOS TableView Forms in Swift"

  s.description  = <<-DESC
                   There's no lack of declarative TableView form libraries for iOS. 
                   
                   Formulary is inspired by XLForm, written in Swift, and designed for 
                   developer flexibility. It is intended to stay somewhat small and 
                   possibly as a foundation for ther libraries.
                   
                   * Form components are Swift protocols
                   * Lots of points of control to override default behavior
                   * Easy to integrate with existing model classes
                   
                   Other cool features:
                   
                   * "Floating Labels" for form fields.
                   DESC

  s.homepage     = "https://github.com/fcanas/Formulary"

  s.license      = "MIT"

  s.author             = { "Fabian Canas" => "fcanas@gmail.com" }
  s.social_media_url   = "http://twitter.com/fcanas"

  s.platform     = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/fcanas/Formulary.git", :tag => "v0.0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "Formulary/**/*.swift"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
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
