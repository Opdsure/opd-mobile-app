
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

         // Google Play Service Account JSON
        PLAYSTORE_CREDENTIALS = credentials('PLAYSTORE_CREDENTIALS')
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
                flutter build appbundle --release
                \
                \\\







                '''
            }
        }

        stage('Upload AAB to Google Play') {
            steps {
                echo "🚀 Uploading AAB to Google Play..."

                withCredentials([file(credentialsId: 'PLAYSTORE_CREDENTIALS', variable: 'PLAYSTORE_CREDENTIALS_FILE')]) {
                    sh '''
                     export PATH="/opt/homebrew/bin:$PATH"

                     echo "🔄 Updating gcloud (if needed)..."
                     gcloud components update --quiet || echo "✅ gcloud update skipped!"

                     echo "🔐 Authenticating with Google Cloud..."
                     gcloud auth activate-service-account --key-file="$PLAYSTORE_CREDENTIALS_FILE" --quiet

                     echo "📂 Checking AAB build output..."
                     ls -lah build/app/outputs/bundle/release/"

                     echo "🚀 Deploying AAB to Google Play..."
                     gcloud beta androidpublisher bundles upload --package="io.app.opdsure" \
                     --bundle="build/app/outputs/bundle/release/app-release.aab" \
                     --track=production --quiet "
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
