Pod::Spec.new do |s|
  s.name               = "Records"
  s.version            = "1.0.1"
  s.summary            = "A lightweight convenience API for basic CoreData database tasks."
  s.description        = "In just a few minutes, setup a fully functioning CoreData implementation that embraces the static, type-safe nature of Swift."
  s.homepage           = "https://github.com/rob-nash/Records"
  s.license            = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Robert Nash" => "robscode@icloud.com" }
  s.social_media_url   = "https://twitter.com/nashytitz"
  s.platform           = :ios, "10.0"
  s.source             = { :git => "https://github.com/rob-nash/Records.git", :tag => "#{s.version}" }
  s.source_files       = "Records/*.{swift}"
  s.requires_arc       = true
end
