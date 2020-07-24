pipeline {
    agent any
    tools {
        maven 'maven' 
    }
    environment {
                CI = 'true'
                 GROUP = readMavenPom().getGroupId()
                ARTIFACT = readMavenPom().getArtifactId()
                VERSION = readMavenPom().getVersion()
    }
    stages {
        
       stage('pipeline环境准备') {
            steps {
                script {
                    echo "开始构建"
                    if(!env.BRANCH_NAME.startsWith('production') && !env.BRANCH_NAME.startsWith('development')){
                        error("自动构建分支名称必须以production或development开头，当前分支名称为: ${env.BRANCH_NAME}")
                    }
                 }
            }
         }
        stage('build master') {
            when {
                branch 'master'
            }
            steps {
                sh 'mvn clean install'
            }
        }
        stage('build development') {
            when {
                branch 'development' 
            }
            steps {
                sh 'mvn clean install'
            }
        }
        stage('build production') {
            when {
                branch 'production'  
            }
            steps {
                sh 'mvn clean install'
            }
        }
        stage('push image') {
            steps {
               script {
                    docker.withRegistry("http://192.168.0.152:8082",'01385c55-7871-4868-a03a-889c4dc403ec') {
                    def customimage = docker.build("${GROUP}-${ARTIFACT}:${VERSION}")
                    customimage.push()
                    }
                }
            }
        } 
       stage('master deploy') {
           when {
                branch 'master'
            }
           steps {
                  sh './jenkins/scripts/master-deploy.sh'
           }
      }
       stage('development deploy') {
           when {
                branch 'development'
            }
           steps {
                  sh './jenkins/scripts/development-deploy.sh'
           }
      }
       stage('production deploy') {
           when {
                branch 'production'
            }
           steps {
                  sh './jenkins/scripts/production-deploy.sh'
           }
      }
    }
}
