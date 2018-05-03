Pod::Spec.new do |s|
      #1.
      s.name = "DSShopFramework"
      #2.
      s.version = "1.0.0"
      #3.  
      s.summary  = "쇼핑몰 앱(hybrid & Native)개발에 필요한 기능을 모아놓은 프레임워크"
      #4.
      s.homepage = "https://github.com/Directiosoft/DSShopFramework"
      #5.
      s.license = "MIT"
      #6.
      s.author = "Directiosoft"
      #7.
      s.platform = :ios, "9.0"
      #8.
      s.source = { :git => "https://github.com/Directiosoft/DSShopFramework", :tag => "1.0.0" }
      #9.
      s.source_files = "ShopCommon", "ShopCommon/**/*.{h,m,swift}"
end