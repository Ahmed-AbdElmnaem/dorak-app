plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.testapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
    jvmTarget = "17"
    freeCompilerArgs = freeCompilerArgs + listOf(
        "-Xjvm-default=all",
        "-Xskip-metadata-version-check"
    )
}

    defaultConfig {
        applicationId = "com.example.testapp"
        minSdkVersion(23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))  // إصدار Firebase BOM
    implementation("com.google.firebase:firebase-analytics-ktx")  // مثال على حزمة Firebase
    implementation("com.google.firebase:firebase-auth-ktx")  // إضافة المزيد حسب الحاجة
}

flutter {
    source = "../.."
}
