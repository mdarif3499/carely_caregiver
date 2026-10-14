allprojects {
    repositories {
        google()
        mavenCentral()
    }
}


subprojects {
    afterEvaluate {
        val project = this
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName<com.android.build.gradle.BaseExtension>("android")
            android.compileSdkVersion(36)
            android.defaultConfig {
                targetSdkVersion(36)
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
