def templatePath = 'tomcat.yaml'
        // name of the template that will be created
def templateName = 'tomcat.yaml'

pipeline {

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/MubeenaNaragund/tomcatcicdtest.git', branch:'main'
      }
    }
    stages {
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
                stage('build') {
                    steps {
                        script {
                            openshift.withCluster() {
                                openshift.withProject() {
                                    def builds = openshift.selector("deployment", templateName).related('builds')
                                    builds.untilEach(1) {
                                        return (it.object().status.phase == "Complete")
                                    }
                                }
                            }
                        } // script
                    } // steps
                } // stage
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
      type: JenkinsPipeline
