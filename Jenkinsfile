pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
        CLOUD_SDK_HOME = "/opt/homebrew/bin"
        PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH"

        # Android Environment Variables
        ANDROID_HOME = "$HOME/Library/Android/sdk"
        ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
        ANDROID_KEY_ALIAS = "opdsure"
        ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
        ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')

        # iOS & Fastlane Credentials
        APPLE_ID = credentials('APPLE_ID')
        APP_SPECIFIC_PASSWORD = credentials('APP_SPECIFIC_PASSWORD')
        MATCH_PASSWORD = credentials('MATCH_PASSWORD')
        FASTLANE_USER = credentials('FASTLANE_USER')
        FASTLANE_PASSWORD = credentials('FASTLANE_PASSWORD')

        # Google Play Credentials
        PLAYSTORE_CREDENTIALS = credentials('PLAYSTORE_CREDENTIALS')
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
                echo "🚀 Verifying Flutter, Java, and Fastlane setup..."

                for tool in flutter java bundle xcodebuild fastlane; do
                    which $tool || { echo "❌ $tool not found!"; exit 1; }
                done

                flutter --version
                flutter doctor
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

        stage('Build Android AAB') {
            steps {
                echo "🚀 Building Android App Bundle (AAB)..."
                sh '''
                echo "Writing keystore properties..."
                cat <<EOF > android/key.properties
                storeFile=$ANDROID_KEYSTORE_PATH
                keyAlias=$ANDROID_KEY_ALIAS
                storePassword=$ANDROID_STORE_PASSWORD
                keyPassword=$ANDROID_KEY_PASSWORD
                EOF

                echo "Building release AAB..."
                flutter build appbundle --release
                '''
            }
        }

        stage('Upload AAB to Google Play') {
            steps {
                echo "🚀 Uploading AAB to Google Play..."
                withCredentials([file(credentialsId: 'PLAYSTORE_CREDENTIALS', variable: 'PLAYSTORE_CREDENTIALS_FILE')]) {
                    sh '''
                    export GOOGLE_APPLICATION_CREDENTIALS=$PLAYSTORE_CREDENTIALS_FILE
                    cd android && bundle install
                    fastlane deploy
                    '''
                }
            }
        }

        stage('Build iOS App') {
            steps {
                echo "🚀 Archiving & Building iOS App..."
                sh '''
                cd ios
                bundle install
                fastlane setup_signing
                fastlane build
                '''
            }
        }

        stage('Upload iOS to App Store') {
            steps {
                echo "🚀 Uploading iOS App to App Store..."
                withCredentials([string(credentialsId: 'APPLE_ID', variable: 'APPLE_ID'),
                                 string(credentialsId: 'APP_SPECIFIC_PASSWORD', variable: 'APP_SPECIFIC_PASSWORD')]) {
                    sh '''
                    cd ios
                    fastlane upload_to_app_store
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
