# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TodoApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TodoApp
  #firebase pods
pod 'Firebase/Core'
pod 'Firebase/Analytics'
pod 'Firebase/Database'
#For Manage Keyboard with In Whole Application
pod 'IQKeyboardManager'

#For Show Progress While Any Task Is Running
pod 'SVProgressHUD'

  target 'TodoAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'IQKeyboardManager'
    pod 'SVProgressHUD'
    pod 'Firebase/Core'
    pod 'Firebase/Analytics'
    pod 'Firebase/Database'
    
  end

  target 'TodoAppUITests' do
    inherit! :search_paths
    pod 'IQKeyboardManager'
    pod 'SVProgressHUD'
    
    pod 'Firebase/Core'
    pod 'Firebase/Analytics'
    pod 'Firebase/Database'
    # Pods for testing
  end

end
