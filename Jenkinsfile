// pipeline {
//     agent any  // Runs on any available Jenkins machine
//
//     environment {
//         FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
//         PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"
//
//         // Securely store keystore credentials using Jenkins credentials
//         ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
//         ANDROID_KEY_ALIAS = "opdsure"
//         ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
//         ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
// //         ANDROID_STORE_PASSWORD = credentials('ANDROID_STORE_PASSWORD')
//     }
//
//     stages {
//         stage('Cleanup') {
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
//                 echo "📦 Installing dependencies..."
//                 sh 'flutter pub get'
//             }
//         }
//
//         stage('Run Tests') {
//             steps {
//                 echo "🧪 Running tests (optional)..."
//                 sh '''
//                 flutter test || echo "⚠️ Tests failed, but continuing..."
//                 '''
//             }
//         }
//
//         stage('Build APK') {
//             steps {
//                 echo "🚀 Building signed APK..."
//                 sh '''
//                 flutter build apk --release \
//                 --dart-define=ANDROID_KEYSTORE_PATH=$ANDROID_KEYSTORE_PATH \
//                 --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS \
//                 --dart-define=ANDROID_KEY_PASSWORD=$ANDROID_KEY_PASSWORD \
//                 --dart-define=ANDROID_STORE_PASSWORD=$ANDROID_STORE_PASSWORD
//                 '''
//             }
//         }
//     }
//
//     post {
//         success {
//             echo "✅ Build completed successfully!"
//         }
//         failure {
//             echo "❌ Build failed. Check logs!"
//         }
//     }
// }




pipeline {
    agent any  // Runs on any available Jenkins machine

    environment {
        // 🛠 Define Flutter installation path and update system PATH
        FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
        PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"
        CLOUDPATH = "/opt/homebrew/bin:$PATH"

        // 🔐 Securely store Android keystore credentials using Jenkins credentials
        ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
        ANDROID_KEY_ALIAS = "opdsure"
        ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')  // Jenkins stored secret
        ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')  // Jenkins stored secret

        // 🍏 Securely store Apple credentials for iOS deployment
        APPLE_ID = credentials('APPLE_ID')  // Apple Developer account email
        APPLE_APP_SPECIFIC_PASSWORD = credentials('APPLE_APP_PASSWORD')  // App-specific password
    }

    stages {
       stage('Check gcloud') {
                   steps {
                       sh 'which gcloud'
                       sh 'gcloud --version'
                   }
               }


        stage('Cleanup') {
            steps {
                echo "🧹 Cleaning up old files..."
                cleanWs()  // Removes old workspace files
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
                sh 'flutter --version'  // Ensure Flutter is installed
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "📦 Installing Flutter dependencies..."
                sh 'flutter pub get'  // Fetch required Flutter packages
            }
        }

        stage('Run Tests') {
            steps {
                echo "🧪 Running Flutter tests (optional)..."
                sh '''
                flutter test || echo "⚠️ Tests failed, but continuing..."
                '''  // Runs tests but allows pipeline to continue on failure
            }
        }

        // 🚀 ANDROID BUILD PROCESS
        stage('Build APK & AAB') {
            steps {
                echo "🚀 Building Android APK & AAB..."
                sh '''
                # Generate a signed APK
                flutter build apk --release \
                --dart-define=ANDROID_KEYSTORE_PATH=$ANDROID_KEYSTORE_PATH \
                --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS \
                --dart-define=ANDROID_KEY_PASSWORD=$ANDROID_KEY_PASSWORD \
                --dart-define=ANDROID_STORE_PASSWORD=$ANDROID_STORE_PASSWORD

                # Generate a signed AAB (for Play Store)
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
                sh '''
                # Authenticate with Google Play Console using stored service account credentials
                gcloud auth activate-service-account --key-file=playstore-credentials.json

                # Deploy AAB to Google Play Console (production track)
                gcloud --quiet --no-user-output-enabled app deploy build/app/outputs/bundle/release/app-release.aab --release-track=production
                '''
            }
        }

        // 🍏 iOS BUILD PROCESS
        stage('Build iOS') {
            steps {
                echo "🚀 Building iOS App (no code signing yet)..."
                sh '''
                flutter build ios --no-codesign  # Generate iOS build without signing
                '''
            }
        }

        stage('Archive iOS App') {
            steps {
                echo "📦 Archiving iOS App using Xcode..."
                sh '''
                # Archive the iOS build using Xcode
                xcodebuild archive -workspace ios/Runner.xcworkspace \
                -scheme Runner \
                -archivePath $WORKSPACE/build/ios_archive.xcarchive \
                CODE_SIGN_IDENTITY="iPhone Distribution" \
                PROVISIONING_PROFILE_SPECIFIER="YourProvisioningProfile"
                '''
            }
        }

        stage('Export Signed IPA') {
            steps {
                echo "🔐 Exporting signed IPA..."
                sh '''
                # Export the signed IPA file from the archived build
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
                # Upload the IPA file using Apple Transporter CLI
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
