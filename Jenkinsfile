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

        APPLE_ID = credentials('APPLE_ID')
        APPLE_APP_SPECIFIC_PASSWORD = credentials('APPLE_APP_PASSWORD')

        PLAYSTORE_CREDENTIALS = credentials('PLAYSTORE_CREDENTIALS')
    }

    stages {
        stage('Check gcloud') {
            steps {
                echo "🔍 Checking gcloud installation..."
                sh '''
                export PATH="/opt/homebrew/bin:$PATH"
                which gcloud || { echo "❌ gcloud not found!"; exit 1; }
                gcloud --version || { echo "❌ gcloud command failed!"; exit 1; }
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
                sh '''
                flutter --version || { echo "❌ Flutter is not installed correctly!"; exit 1; }
                java -version || { echo "❌ Java is not installed correctly!"; exit 1; }
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "📦 Installing Flutter dependencies..."
                sh '''
                flutter clean
                flutter pub get
                '''
            }
        }

        stage('Build APK & AAB') {
            steps {
                echo "🚀 Building Android APK & AAB..."
                script {
                    try {
                        sh '''
                        set -e  # Stop script on any error

                        echo "🔐 Writing Keystore Credentials to key.properties"
                        cat <<EOF > android/key.properties
                        storeFile=$ANDROID_KEYSTORE_PATH
                        keyAlias=$ANDROID_KEY_ALIAS
                        storePassword=$ANDROID_STORE_PASSWORD
                        keyPassword=$ANDROID_KEY_PASSWORD
                        EOF

                        echo "🛠 Cleaning & Fetching Packages..."
                        flutter clean
                        rm -rf build/ android/app/build/
                        flutter pub get

                        echo "🛠 Running Flutter build..."
                        flutter build appbundle --release --verbose > flutter_build.log 2>&1 || {
                            echo "❌ Flutter build failed! Showing logs:"
                            cat flutter_build.log  # Print the log file in case of failure
                            exit 1
                        }

                        echo "📂 Checking if AAB is created..."
                        find build/ -name "*.aab"

                        # Verify output location
                        echo "📂 Checking generated AAB file..."
                        ls -lah build/app/outputs/bundle/release/

                        if [ ! -f build/app/outputs/bundle/release/app-release.aab ]; then
                            echo "❌ AAB file not found! Here is the build directory structure:"
                            ls -lah build/app/outputs/bundle/
                            exit 1
                        fi
                        '''

                        // 🔹 Stash the AAB file after verifying it exists
                        stash includes: 'build/app/outputs/bundle/release/*.aab', name: 'aab-file'

                    } catch (Exception e) {
                        echo "⚠️ Flutter build failed! Check the logs above for details."
                        currentBuild.result = 'FAILURE'
                        error "Stopping pipeline due to Flutter build failure."
                    }
                }
            }
        }


       stage('Upload AAB to Google Play') {
           steps {
               echo "🚀 Uploading AAB to Google Play..."

               // 🔹 Unstash the AAB file to restore it in case the workspace was cleaned
               unstash 'aab-file'

               withCredentials([file(credentialsId: 'PLAYSTORE_CREDENTIALS', variable: 'PLAYSTORE_CREDENTIALS_FILE')]) {
                   sh '''
                       set -e

                       echo "📂 Current Workspace:"
                       pwd
                       ls -lah

                       echo "🔍 Searching for AAB file..."
                       find build/ -name "*.aab" || echo "⚠️ No AAB files found!"

                       # Ensure the AAB file exists
                       AAB_FILE="build/app/outputs/bundle/release/app-release.aab"
                       if [ ! -f "$AAB_FILE" ]; then
                           echo "❌ ERROR: AAB file not found!"
                           echo "📂 Available build files:"
                           ls -lah build/app/outputs/bundle/release/ || echo "⚠️ No release build directory!"
                           exit 1
                       fi

                       echo "🚀 Deploying AAB to Google Play..."
                       gcloud beta androidpublisher bundles upload \
                       --package="io.app.opdsure" \
                       --bundle="$AAB_FILE" \
                       --track=production --quiet || { echo "❌ Failed to upload AAB!"; exit 1; }
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
