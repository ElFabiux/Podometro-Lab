plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.step_counter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "26.3.11579264"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.step_counter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Add this to help with dependency resolution
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core-ktx:1.12.0") // Example of forcing a specific version
            cacheDynamicVersionsFor(10, "minutes")
            cacheChangingModulesFor(4, "hours")
        }
    }
}

flutter {
    source = "../.."
}

repositories {
    google()
    mavenCentral()
    maven {
        url = uri("https://storage.googleapis.com/download.flutter.io")
    }
}