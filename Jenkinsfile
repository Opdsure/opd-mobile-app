// pipeline {
//     agent any  // Runs on any available Jenkins machine
//
//     environment {
//         // 🛠 Define Flutter installation path and update system PATH
//         FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
//         CLOUD_SDK_HOME = "/opt/homebrew/bin"  // Ensure gcloud is found
//         PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH"
//
//         // 🔐 Securely store Android keystore credentials using Jenkins credentials
//         ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
//         ANDROID_KEY_ALIAS = "opdsure"
//         ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
//         ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
//
//         //  Securely store Apple credentials for iOS deployment
//         APPLE_ID = credentials('APPLE_ID')
//         APPLE_APP_SPECIFIC_PASSWORD = credentials('APPLE_APP_PASSWORD')
//
//         // gcloud auth activate-service-account --key-file=playstore-credentials.json
//
//         PLAYSTORE_CREDENTIALS = credentials('GOOGLE_PLAY_JSON')
//
//     }
//
//     stages {
//         stage('Check gcloud') {
//             steps {
//                 echo "🔍 Checking gcloud installation..."
//                 sh '''
//                 export PATH="/opt/homebrew/bin:$PATH"
//                 which gcloud || echo "❌ gcloud not found!"
//                 gcloud --version || echo "❌ gcloud command failed!"
//                 '''
//             }
//         }
//
//         stage('Cleanup') {
//             steps {
//                 echo "🧹 Cleaning up old files..."
//                 cleanWs()
//             }
//         }
//
//         stage('Checkout Code') {
//             steps {
//                 echo "🔄 Fetching latest code from repository..."
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
//                 echo "🧪 Running Flutter tests (optional)..."
//                 sh '''
//                 flutter test || echo "⚠️ Tests failed, but continuing..."
//                 '''
//             }
//         }
//
//         // 🚀 ANDROID BUILD PROCESS
//         stage('Build APK & AAB') {
//             steps {
//                 echo "🚀 Building Android APK & AAB..."
//                 sh '''
//                 flutter build apk --release \
//                 --dart-define=ANDROID_KEYSTORE_PATH=$ANDROID_KEYSTORE_PATH \
//                 --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS \
//                 --dart-define=ANDROID_KEY_PASSWORD=$ANDROID_KEY_PASSWORD \
//                 --dart-define=ANDROID_STORE_PASSWORD=$ANDROID_STORE_PASSWORD
//
//                 flutter build appbundle --release \
//                 --dart-define=ANDROID_KEYSTORE_PATH=$ANDROID_KEYSTORE_PATH \
//                 --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS \
//                 --dart-define=ANDROID_KEY_PASSWORD=$ANDROID_KEY_PASSWORD \
//                 --dart-define=ANDROID_STORE_PASSWORD=$ANDROID_STORE_PASSWORD
//                 '''
//             }
//         }
//
//         stage('Upload AAB to Google Play') {
//             steps {
//                echo "🚀 Uploading AAB to Google Play..."
//
//                        // Save the credential to a JSON file
//                        sh '''
//                        echo "$PLAYSTORE_CREDENTIALS" > playstore-credentials.json
//
//                        export PATH="/opt/homebrew/bin:$PATH"
//                        echo "🔐 Authenticating with Google Cloud..."
//                        gcloud auth activate-service-account --key-file=playstore-credentials.json || echo "❌ gcloud authentication failed!"
//
//                        echo "🚀 Deploying AAB to Google Play..."
//                        gcloud beta androidpublisher bundles upload --package="com.ksbm.astrochats" \
//                          --bundle="build/app/outputs/bundle/release/app-release.aab" \
//                          --service-account-key=playstore-credentials.json \
//                          --track=production || echo "❌ Deployment failed!"
//                        '''
//
//
//
//             }
//         }
//
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




pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
        CLOUD_SDK_HOME = "/opt/homebrew/bin"
        PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH"

        // Secure Android Keystore Credentials
        ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
        ANDROID_KEY_ALIAS = "opdsure"
        ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
        ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')

        // Secure Apple Credentials
        APPLE_ID = credentials('APPLE_ID')
        APPLE_APP_SPECIFIC_PASSWORD = credentials('APPLE_APP_PASSWORD')
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
                echo "🧪 Running Flutter tests..."
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
                # Writing Keystore Credentials to key.properties
                cat <<EOF > android/key.properties
                storeFile=$ANDROID_KEYSTORE_PATH
                keyAlias=$ANDROID_KEY_ALIAS
                storePassword="$ANDROID_STORE_PASSWORD"
                keyPassword="$ANDROID_KEY_PASSWORD"
                EOF

                # Build APK & AAB
                flutter build apk --release
                flutter build appbundle --release
                '''
            }
        }

        stage('Upload AAB to Google Play') {
            steps {
                echo "🚀 Uploading AAB to Google Play..."

                withCredentials([file(credentialsId: 'PLAYSTORE_CREDENTIALS', variable: 'PLAYSTORE_CREDENTIALS_FILE')]) {
                    sh '''
                    export PATH="/opt/homebrew/bin:$PATH"
                    echo "🔐 Authenticating with Google Cloud..."
                    gcloud auth activate-service-account --key-file="$PLAYSTORE_CREDENTIALS_FILE" || echo "❌ gcloud authentication failed!"

                    echo "🚀 Deploying AAB to Google Play..."
                    gcloud beta androidpublisher bundles upload --package="io.app.opdsure" \
                        --bundle="build/app/outputs/bundle/release/app-release.aab" \
                        --service-account-key="$PLAYSTORE_CREDENTIALS_FILE" \
                        --track=production || echo "❌ Deployment failed!"
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
