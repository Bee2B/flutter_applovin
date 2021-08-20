#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_applovin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
    s.name             = 'flutter_applovin'
    s.version          = '0.0.1'
    s.summary          = 'A new Flutter project.'
    s.description      = <<-DESC
A new Flutter project.
                   DESC
    s.homepage         = 'http://example.com'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Your Company' => 'email@example.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.dependency 'Flutter'
    s.platform = :ios, '11.0'
    s.dependency 'AppLovinSDK'
    s.dependency 'AppLovinMediationFacebookAdapter'
    s.dependency 'AppLovinMediationUnityAdsAdapter'
    s.dependency 'AppLovinMediationAdColonyAdapter'
    s.dependency 'AppLovinMediationInMobiAdapter'
    s.dependency 'AppLovinMediationMintegralAdapter'
    s.dependency 'AppLovinMediationTapjoyAdapter'
    s.dependency 'AppLovinMediationByteDanceAdapter'
    s.dependency 'AppLovinMediationIronSourceAdapter'
    s.dependency 'AppLovinMediationGoogleAdapter'
    s.static_framework = true

    # Flutter.framework does not contain a i386 slice.
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.swift_version = '5.0'
end
