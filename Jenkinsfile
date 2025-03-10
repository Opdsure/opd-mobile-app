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
                sh 'flutter --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }

        stage('Build AAB') {
            steps {

                echo "🚀 Building Android APK & AAB..."

                script {
                    sh '''
                    echo "storeFile=$ANDROID_KEYSTORE_PATH" > android/key.properties
                    echo "keyAlias=$ANDROID_KEY_ALIAS" >> android/key.properties
                    echo "storePassword=$ANDROID_STORE_PASSWORD" >> android/key.properties
                    echo "keyPassword=$ANDROID_KEY_PASSWORD" >> android/key.properties

                    flutter build appbundle --release
                    '''
                }
            }
        }


        stage('Upload AAB to Google Play') {
            steps {
                echo "🚀 Uploading AAB to Google Play..."
                withCredentials([file(credentialsId: 'PLAYSTORE_CREDENTIALS', variable: 'PLAYSTORE_CREDENTIALS_FILE')]) {
                    sh '''
                    export GOOGLE_APPLICATION_CREDENTIALS=$PLAYSTORE_CREDENTIALS_FILE

                    gcloud services enable androidpublisher.googleapis.com

                    gcloud beta androidpublishing bundles upload \
                        --package="io.app.opdsure" \
                        --bundle="build/app/outputs/bundle/release/app-release.aab" \
                        --track=production \
                        --service-account-key=$GOOGLE_APPLICATION_CREDENTIALS
                    '''
                }
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
