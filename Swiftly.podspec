Pod::Spec.new do |s|
  s.name             = "Swiftly"
  s.version          = "0.0.1"
  s.summary          = "A simple Swift graphing library."
  s.description      = <<-DESC
                        A simple Swift graphing library.

                        Currently, only supports basic line graphs.
                       DESC
  s.homepage         = "https://github.com/imperiopolis/Swiftly"
  s.license          = 'MIT'
  s.author           = { "Imperiopolis" => "me@trappdesign.net" }
  s.source           = { :git => "https://github.com/imperiopolis/Swiftly.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/imperiopolis'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Swiftly/*.swift'
end
