import java.io.FileInputStream
 import java.util.Properties

         plugins {
             id("com.android.application")
             id("com.google.gms.google-services")
             id("kotlin-android")
             id("dev.flutter.flutter-gradle-plugin")
         }

 val keystoreProperties = Properties()
 val keystorePropertiesFile = rootProject.file("key.properties")
 if (keystorePropertiesFile.exists()) {
     keystoreProperties.load(FileInputStream(keystorePropertiesFile))
 }

 android {
     namespace = "mmeo.system.pne"
     compileSdk = flutter.compileSdkVersion
     compileOptions {
         sourceCompatibility = JavaVersion.VERSION_11
         targetCompatibility = JavaVersion.VERSION_11
     }

     kotlinOptions {
         jvmTarget = JavaVersion.VERSION_11.toString()
     }
     defaultConfig {
         applicationId = "mmeo.system.pne"
         minSdk = flutter.minSdkVersion
         targetSdk = flutter.targetSdkVersion
         versionCode = flutter.versionCode
         versionName = flutter.versionName
     }

     signingConfigs {
         create("release") {
             if (keystorePropertiesFile.exists()) {
                 keyAlias = keystoreProperties["keyAlias"] as String
                 keyPassword = keystoreProperties["keyPassword"] as String
                 storeFile = file(keystoreProperties["storeFile"] as String)
                 storePassword = keystoreProperties["storePassword"] as String
             }
         }
     }

     buildTypes {
         getByName("release") {
             signingConfig = signingConfigs.getByName("release")
             isMinifyEnabled = false
             isShrinkResources = false
         }
     }
 }

 flutter {
     source = "../.."
 }