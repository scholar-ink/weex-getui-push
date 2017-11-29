# coding: utf-8

Pod::Spec.new do |s|
  s.name         = "GetuiPush"
  s.version      = "0.0.1"
  s.summary      = "Weex Plugin"

  s.description  = <<-DESC
                   Weexplugin Source Description
                   DESC

  s.homepage     = "https://github.com/scholar-ink/weex-plugin-getui-push"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
            copyright
    LICENSE
  }
  s.authors      = {
                     "scholar_ink" =>"scholar_ink@163.com"
                   }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"

  s.source       = { :git => 'https://github.com/scholar-ink/weex-plugin-getui-push.git', :tag => s.version }
  s.source_files  = "ios/Sources/*.{h,m,mm}"
  
  s.requires_arc = true
  s.dependency "WeexPluginLoader"
  s.dependency "WeexSDK"
  s.dependency "GTSDK"
end
