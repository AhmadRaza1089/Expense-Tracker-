allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // Skip Flutter plugins to avoid path conflicts
    if (!project.name.contains("google_sign_in") && 
        !project.name.contains("flutter")) {
        val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubprojectBuildDir)
    }
}

subprojects {
    project.evaluationDependsOn(":app")  
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
