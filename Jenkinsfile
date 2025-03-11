pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
        CLOUD_SDK_HOME = "/opt/homebrew/bin"
        PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH"

        ANDROID_HOME = "$HOME/Library/Android/sdk"
        ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
        ANDROID_KEY_ALIAS = "opdsure"
        ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
        ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')

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

        stage('Setup Flutter') {
            steps {
                sh 'export PATH=$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH && flutter --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                export PATH=$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH
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
                                    export PATH=$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$CLOUD_SDK_HOME:$PATH
                                    export GOOGLE_APPLICATION_CREDENTIALS=$PLAYSTORE_CREDENTIALS_FILE

                                    cd android
                                    bundle install
                                    fastlane deploy
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
