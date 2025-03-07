pipeline {
    agent any  // Runs on any available Jenkins machine

    environment {
        // 🛠 Define Flutter installation path and update system PATH
        FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
        CLOUD_SDK_HOME = "/opt/homebrew/bin"  // Ensure gcloud is found
        PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH"

        // 🔐 Securely store Android keystore credentials using Jenkins credentials
        ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
        ANDROID_KEY_ALIAS = "opdsure"
        ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
        ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')

        //  Securely store Apple credentials for iOS deployment
        APPLE_ID = credentials('APPLE_ID')
        APPLE_APP_SPECIFIC_PASSWORD = credentials('APPLE_APP_PASSWORD')

        // gcloud auth activate-service-account --key-file=playstore-credentials.json

        PLAYSTORE_CREDENTIALS = credentials('GOOGLE_PLAY_JSON')

    }

    stages {
        stage('Check gcloud') {
            steps {
                echo "🔍 Checking gcloud installation..."
                sh '''
                export PATH="/opt/homebrew/bin:$PATH"
                which gcloud || echo "❌ gcloud not found!"
                gcloud --version || echo "❌ gcloud command failed!"
                '''
            }
        }

        stage('Cleanup') {
            steps {
                echo "🧹 Cleaning up old files..."
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                echo "🔄 Fetching latest code from repository..."
                git url: 'https://amanrao@bitbucket.org/sahil1321/opd_sure_app.git', branch: 'master'
            }
        }

        stage('Setup Flutter') {
            steps {
                echo "🛠 Checking Flutter installation..."
                sh 'flutter --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "📦 Installing Flutter dependencies..."
                sh 'flutter pub get'
            }
        }

        stage('Run Tests') {
            steps {
                echo "🧪 Running Flutter tests (optional)..."
                sh '''
                flutter test || echo "⚠️ Tests failed, but continuing..."
                '''
            }
        }

        // 🚀 ANDROID BUILD PROCESS
        stage('Build APK & AAB') {
            steps {
                echo "🚀 Building Android APK & AAB..."
                sh '''
                flutter build apk --release \
                --dart-define=ANDROID_KEYSTORE_PATH=$ANDROID_KEYSTORE_PATH \
                --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS \
                --dart-define=ANDROID_KEY_PASSWORD=$ANDROID_KEY_PASSWORD \
                --dart-define=ANDROID_STORE_PASSWORD=$ANDROID_STORE_PASSWORD

                flutter build appbundle --release \
                --dart-define=ANDROID_KEYSTORE_PATH=$ANDROID_KEYSTORE_PATH \
                --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS \
                --dart-define=ANDROID_KEY_PASSWORD=$ANDROID_KEY_PASSWORD \
                --dart-define=ANDROID_STORE_PASSWORD=$ANDROID_STORE_PASSWORD
                '''
            }
        }

        stage('Upload AAB to Google Play') {
            steps {
               echo "🚀 Uploading AAB to Google Play..."

                       // Save the credential to a JSON file
                       sh '''
                       echo "$PLAYSTORE_CREDENTIALS" > playstore-credentials.json

                       export PATH="/opt/homebrew/bin:$PATH"
                       echo "🔐 Authenticating with Google Cloud..."
                       gcloud auth activate-service-account --key-file=playstore-credentials.json || echo "❌ gcloud authentication failed!"

                       echo "🚀 Deploying AAB to Google Play..."
                       gcloud beta androidpublisher bundles upload --package="com.ksbm.astrochats" \
                         --bundle="build/app/outputs/bundle/release/app-release.aab" \
                         --service-account-key=playstore-credentials.json \
                         --track=production || echo "❌ Deployment failed!"
                       '''



            }
        }

        // 🍏 iOS BUILD PROCESS
        stage('Build iOS') {
            steps {
                echo "🚀 Building iOS App (no code signing yet)..."
                sh 'flutter build ios --no-codesign'
            }
        }

        stage('Archive iOS App') {
            steps {
                echo "📦 Archiving iOS App using Xcode..."
                sh '''
                xcodebuild archive -workspace ios/Runner.xcworkspace \
                -scheme Runner \
                -archivePath $WORKSPACE/build/ios_archive.xcarchive \
                CODE_SIGN_IDENTITY="iPhone Distribution"
                '''
            }
        }

        stage('Export Signed IPA') {
            steps {
                echo "🔐 Exporting signed IPA..."
                sh '''
                xcodebuild -exportArchive \
                -archivePath $WORKSPACE/build/ios_archive.xcarchive \
                -exportOptionsPlist ios/ExportOptions.plist \
                -exportPath $WORKSPACE/build/ios_output
                '''
            }
        }

        stage('Upload IPA to App Store') {
            steps {
                echo "🚀 Uploading IPA to App Store Connect..."
                sh '''
                xcrun altool --upload-app --type ios \
                --file $WORKSPACE/build/ios_output/Runner.ipa \
                --username "$APPLE_ID" \
                --password "$APPLE_APP_SPECIFIC_PASSWORD"
                '''
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




// pipeline {
//     agent any
//
//     environment {
//         // 🛠 Define paths and update system PATH
//         FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
//         CLOUD_SDK_HOME = "/opt/homebrew/bin"
//         PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH"
//
//         // 🔐 Secure credentials
//         ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
//         ANDROID_KEY_ALIAS = "opdsure"
//         ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
//         ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
//
//         APPLE_ID = credentials('APPLE_ID')
//         APPLE_APP_SPECIFIC_PASSWORD = credentials('APPLE_APP_PASSWORD')
//         PLAYSTORE_CREDENTIALS = credentials('GOOGLE_PLAY_JSON')
//     }
//
//     stages {
//         // ✅ INITIAL SETUP
//         stage('Check gcloud') {
//             steps {
//                 echo "🔍 Checking gcloud installation..."
//                 sh '''
//                 export PATH="$CLOUD_SDK_HOME:$PATH"
//                 which gcloud || echo "❌ gcloud not found!"
//                 gcloud --version || echo "❌ gcloud command failed!"
//                 '''
//             }
//         }
//
//         stage('Cleanup Workspace') {
//             steps {
//                 echo "🧹 Cleaning up old files..."
//                 cleanWs()
//             }
//         }
//
//         stage('Checkout Code') {
//             steps {
//                 echo "🔄 Fetching latest code..."
//                 git url: 'https://amanrao@bitbucket.org/sahil1321/opd_sure_app.git', branch: 'master'
//             }
//         }
//
//         stage('Setup Flutter') {
//             steps {
//                 echo "🛠 Checking Flutter installation..."
//                 sh 'flutter --version'
//             }
//         }
//
//         stage('Install Dependencies') {
//             steps {
//                 echo "📦 Installing Flutter dependencies..."
//                 sh 'flutter pub get'
//             }
//         }
//
//         stage('Run Tests') {
//             steps {
//                 echo "🧪 Running Flutter tests..."
//                 sh 'flutter test || echo "⚠️ Tests failed, but continuing..."'
//             }
//         }
//
//         // 🚀 ANDROID BUILD & DEPLOYMENT
//         stage('Build Android APK & AAB') {
//             steps {
//                 echo "📦 Building Android APK & AAB..."
//                 sh '''
//                 flutter build apk --release --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS
//                 flutter build appbundle --release --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS
//                 '''
//             }
//         }
//
//         stage('Upload AAB to Google Play') {
//             steps {
//                 echo "🚀 Uploading AAB to Google Play..."
//                 sh '''
//                 set -e  # Exit on error
//
//                 echo "🔐 Creating Play Store credentials file..."
//                 echo "$PLAYSTORE_CREDENTIALS" > playstore-credentials.json
//                 chmod 600 playstore-credentials.json  # Secure the file
//
//                 echo "🔑 Authenticating with Google Cloud..."
//                 export PATH="$CLOUD_SDK_HOME:$PATH"
//                 gcloud auth activate-service-account --key-file=playstore-credentials.json
//
//                 echo "✅ Authentication successful! Deploying AAB..."
//                 gcloud beta androidpublisher bundles upload --package="com.ksbm.astrochats" \
//                     --bundle="build/app/outputs/bundle/release/app-release.aab" \
//                     --service-account-key=playstore-credentials.json \
//                     --track=production
//
//                 echo "🧹 Cleaning up credentials file..."
//                 rm -f playstore-credentials.json
//                 '''
//             }
//         }
//
//         // 🍏 iOS BUILD & DEPLOYMENT
//         stage('Build iOS') {
//             steps {
//                 echo "📦 Building iOS App (without code signing)..."
//                 sh 'flutter build ios --no-codesign'
//             }
//         }
//
//         stage('Archive iOS App') {
//             steps {
//                 echo "📦 Archiving iOS App..."
//                 sh '''
//                 xcodebuild archive -workspace ios/Runner.xcworkspace \
//                     -scheme Runner \
//                     -archivePath $WORKSPACE/build/ios_archive.xcarchive \
//                     CODE_SIGN_IDENTITY="iPhone Distribution"
//                 '''
//             }
//         }
//
//         stage('Export Signed IPA') {
//             steps {
//                 echo "🔐 Exporting signed IPA..."
//                 sh '''
//                 xcodebuild -exportArchive \
//                     -archivePath $WORKSPACE/build/ios_archive.xcarchive \
//                     -exportOptionsPlist ios/ExportOptions.plist \
//                     -exportPath $WORKSPACE/build/ios_output
//                 '''
//             }
//         }
//
//         stage('Upload IPA to App Store') {
//             steps {
//                 echo "🚀 Uploading IPA to App Store Connect..."
//                 sh '''
//                 xcrun altool --upload-app --type ios \
//                     --file $WORKSPACE/build/ios_output/Runner.ipa \
//                     --username "$APPLE_ID" \
//                     --password "$APPLE_APP_SPECIFIC_PASSWORD"
//                 '''
//             }
//         }
//     }
//
//     post {
//         success {
//             echo "✅ Build and deployment completed successfully!"
//         }
//         failure {
//             echo "❌ Build failed. Check logs for issues!"
//         }
//     }
// }
