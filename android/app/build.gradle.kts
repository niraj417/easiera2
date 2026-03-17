import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore from key.properties file (local) or Codemagic env vars
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.bizheath360.bizheath360"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            // Codemagic injects CM_KEYSTORE_PATH, CM_KEY_ALIAS, CM_KEY_PASSWORD, CM_STORE_PASSWORD
            // Locally, these can be stored in android/key.properties (do NOT commit that file)
            val keystorePath = System.getenv("CM_KEYSTORE_PATH")
                ?: keystoreProperties.getProperty("storeFile", "")
                
            if (keystorePath.isNotEmpty()) {
                storeFile = file(keystorePath)
                keyAlias = System.getenv("CM_KEY_ALIAS")
                    ?: keystoreProperties.getProperty("keyAlias", "")
                keyPassword = System.getenv("CM_KEY_PASSWORD")
                    ?: keystoreProperties.getProperty("keyPassword", "")
                storePassword = System.getenv("CM_STORE_PASSWORD")
                    ?: keystoreProperties.getProperty("storePassword", "")
            }
        }
    }

    defaultConfig {
        applicationId = "com.bizheath360.bizheath360"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
