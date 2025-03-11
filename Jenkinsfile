pipeline {
    agent any

    environment {
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
        APPLE_ID = credentials('APPLE_ID')
        APP_SPECIFIC_PASSWORD = credentials('APPLE_APP_PASSWORD')

        // Google Play Credentials
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

        stage('Build iOS App') {
            steps {
                   echo "🚀 Archiving & Building iOS App..."
                        sh '''
                        cd ios

                        # Use rbenv (VERY IMPORTANT)
                        export PATH="$HOME/.rbenv/bin:$PATH"
                        eval "$(rbenv init -)"

                        # Install Bundler Locally (No sudo needed)
                        gem install bundler -v 2.6.3 --user-install
                        export PATH="$HOME/.gem/ruby/3.2.0/bin:$PATH"

                        # Install dependencies and build
                        bundle install
                        fastlane setup_signing
                        fastlane build
                        '''
            }
        }

        stage('Upload iOS App to App Store') {
            steps {
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
