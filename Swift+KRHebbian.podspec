Pod::Spec.new do |s|
  s.name         = "Swift+KRHebbian"
  s.version      = "1.1"
  s.summary      = "Self learning the adjust weight method on Machine Learning."
  s.description  = <<-DESC
                   KRHebbian is a self-learning algorithm (adjust the weights) in neural network of Machine Learning (自分学習アルゴリズム).
                   DESC
  s.homepage     = "https://github.com/Kalvar/swift-KRHebbian-Algorithm"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Kalvar Lin" => "ilovekalvar@gmail.com" }
  s.social_media_url = "https://twitter.com/ilovekalvar"
  s.source       = { :git => "https://github.com/Kalvar/swift-KRHebbian-Algorithm.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'ML/*'
end 