Pod::Spec.new do |s|
  s.name             = "Swiftly"
  s.version          = "2.0.0"
  s.summary          = "Swiftly generate Auto Layout constraints."
  s.description      = <<-DESC
Swiftly generate Auto Layout constraints and interact with them with all of Apple's built in functions.
                    DESC
  s.homepage         = "https://github.com/imperiopolis/Swiftly"
  s.license          = 'MIT'
  s.author           = { "Imperiopolis" => "me@trappdesign.net" }
  s.source           = { :git => "https://github.com/imperiopolis/Swiftly.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/imperiopolis'

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Swiftly/*.swift'
end
