def templatePath = 'tomcat'
// name of the template that will be created
def templateName = 'tomcat'
def dockerfile= 'Dockerfile'
pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git url: 'https://github.com/MubeenaNaragund/tomcatcicdtest.git', branch: 'main'
      }
    }
    stage('preamble') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject() {
              echo "Using project: ${openshift.project()}"
            }
          }
        }
      }
    }
    stage('cleanup') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject() {
              // delete everything with this template label
              openshift.selector("all", [app: templateName]).delete()
              // delete any secrets with this template label
              if (openshift.selector("secrets", templateName).exists()) {
                openshift.selector("secrets", templateName).delete()
              }
            }
          }
        } // script
      } // steps
    } // stage
    stage('build image') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject() {
              //openshift.build(dockerfile)
               //openshift.withRegistry('default-route-openshift-image-registry.apps.itmveocp.cp.fyre.ibm.com')
                 myapp = openshift.build("default-route-openshift-image-registry.apps.itmveocp.cp.fyre.ibm.com/default/tomcat:latest")
                 myapp.push("latest")
            }
          }
        }
      }
    }
    stage('create') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject() {
              // create a new application from the templatePath
              openshift.newApp(templatePath)
            }
          }
        } // script
      } // steps
    } // stage
    //      stage('build') {
    //        steps {
    //          script {
    //            openshift.withCluster() {
    //              openshift.withProject() {
    //                def builds = openshift.selector("deployment", templateName).related('builds')
    //                builds.untilEach(1) {
    //                  return (it.object().status.phase == "Complete")
    //                }
    //              }
    //            }
    //          } // script
    //        } // steps
    //      } // stage
    stage('tag') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject() {
              // if everything else succeeded, tag the ${templateName}:latest image as ${templateName}-staging:latest
              // a pipeline build config for the staging environment can watch for the ${templateName}-staging:latest
              // image to change and then deploy it to the staging environment
              openshift.tag("${templateName}:latest", "${templateName}-staging:latest")
            }
          }
        } // script
      } // steps
    } // stage
  } // stages
} // pipeline
