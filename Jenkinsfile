pipeline {
    agent any  // Runs on any available Jenkins machine

    environment {
        FLUTTER_HOME = "/Users/intileotechnologies/Documents/Aman/flutter"
        PATH = "$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

        // Securely store keystore credentials using Jenkins credentials
        ANDROID_KEYSTORE_PATH = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/android/opdsure.jks"
        ANDROID_KEY_ALIAS = "opdsure"
        ANDROID_KEY_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
        ANDROID_STORE_PASSWORD = credentials('ANDROID_KEY_PASSWORD')
//         ANDROID_STORE_PASSWORD = credentials('ANDROID_STORE_PASSWORD')
    }

    stages {
        stage('Cleanup') {
            steps {
                echo "🧹 Cleaning up old files..."
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                echo "🔄 Fetching latest code..."
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
                echo "📦 Installing dependencies..."
                sh 'flutter pub get'
            }
        }

        stage('Run Tests') {
            steps {
                echo "🧪 Running tests (optional)..."
                sh '''
                flutter test || echo "⚠️ Tests failed, but continuing..."
                '''
            }
        }

        stage('Build APK') {
            steps {
                echo "🚀 Building signed APK..."
                sh '''
                flutter build apk --release \
                --dart-define=ANDROID_KEYSTORE_PATH=$ANDROID_KEYSTORE_PATH \
                --dart-define=ANDROID_KEY_ALIAS=$ANDROID_KEY_ALIAS \
                --dart-define=ANDROID_KEY_PASSWORD=$ANDROID_KEY_PASSWORD \
                --dart-define=ANDROID_STORE_PASSWORD=$ANDROID_STORE_PASSWORD
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build completed successfully!"
        }
        failure {
            echo "❌ Build failed. Check logs!"
        }
    }
}
