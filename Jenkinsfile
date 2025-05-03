pipeline {
    agent any

    environment {

       LANG = "en_US.UTF-8"
       LC_ALL = "en_US.UTF-8"


        FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
        CLOUD_SDK_HOME = "/opt/homebrew/bin"
        PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH"
        // Android Environment Variables
        ANDROID_HOME = "$HOME/Library/Android/sdk"
        ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
        ANDROID_KEY_ALIAS = "opdsure"
        ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
        ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')

        // iOS Environment Variables
        APPLE_ID = 'opdsure3@gmail.com'
        APP_SPECIFIC_PASSWORD = credentials('App_Specific_OPDSure')

        // Google Play Credentials
        PLAYSTORE_CREDENTIALS = credentials('PLAYSTORE_CREDENTIALS')

        //////
        APP_STORE_USERNAME = credentials('OPD_Username_Apple')
        FASTLANE_API_KEY_PATH = credentials('OPDSURE_API_KEY_PATH')

    }

    stages {
        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git url: 'https://amanrao@bitbucket.org/sahil1321/opd_sure_app.git', branch: 'master'
            }
        }

        stage('Setup Environment') {
            steps {
                sh '''
                echo "🚀 Verifying Flutter & Android SDK setup..."
                which flutter
                which java
                which bundle

                flutter --version
                flutter doctor

                echo "🚀 Verifying Xcode & Fastlane setup..."
                which xcodebuild
                which fastlane

                echo "✅ Environment setup complete!"
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                echo "🚀 Installing Flutter dependencies..."
                flutter clean
                flutter pub get
                '''
            }
        }

        stage('Build AAB') {
                    steps {
                        echo "🚀 Building Android APK & AAB..."
                        script {
                            sh '''
                            mkdir -p android/app/

                            echo "storeFile=$ANDROID_KEYSTORE_PATH" > android/app/key.properties
                            echo "keyAlias=$ANDROID_KEY_ALIAS" >> android/app/key.properties
                            echo "storePassword=$ANDROID_STORE_PASSWORD" >> android/app/key.properties
                            echo "keyPassword=$ANDROID_KEY_PASSWORD" >> android/app/key.properties

                            export PATH=$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH
                            flutter build appbundle --release
                            '''
                        }
                    }
                }

        stage('Upload AAB to Google Play') {
            steps {
                echo "🚀 Uploading AAB to Google Play using Fastlane..."
                withCredentials([file(credentialsId: 'PLAYSTORE_CREDENTIALS', variable: 'PLAYSTORE_CREDENTIALS_FILE')]) {
                            sh '''
                            export GOOGLE_APPLICATION_CREDENTIALS=$PLAYSTORE_CREDENTIALS_FILE
                            cd android

                            # Initialize rbenv (VERY IMPORTANT)
                            export PATH="$HOME/.rbenv/bin:$PATH"
                            eval "$(rbenv init -)"

                            # Install Bundler locally (No sudo needed)
                            gem install bundler -v 2.6.3 --user-install
                            export PATH="$HOME/.gem/ruby/3.2.0/bin:$PATH"

                            # Install dependencies and deploy
                            bundle install
                            fastlane deploy
                            '''
                        }

            }
        }


//        stage('Fix CocoaPods & Fastlane') {
//            steps {
//                sh '''
//                echo "🚀 Running CocoaPods & Fastlane Fix Script..."
//                bash -x ios/fix_cocoapods.sh
//                '''
//            }
//        }



        stage('Build iOS App') {
            steps {
                    echo "🚀 Archiving & Building iOS App..."
                          sh '''
                         flutter build ios --release --no-codesign
                          '''
            }
        }



        stage('Upload iOS App to App Store') {
            steps {
                dir('ios') {
                 echo "🚀 Upload build to App Store"
                 sh '''
                 set -e  # Exit on any command failure
                 pod install --repo-update  # Ensure latest pod dependencies
                 fastlane beta  # Run Fastlane beta lane

                  '''
                 }
            }
        }
    }

    post {
        success {
            echo "✅ Build and deployment completed successfully!"
        }
        failure {
            echo "❌ Build failed. Check logs for issues!"
        }
    }
}
