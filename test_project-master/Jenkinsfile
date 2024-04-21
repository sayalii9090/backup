pipeline {
   agent any 
   //tools {
        // Note: this should match with the tool name configured in your jenkins instance (JENKINS_URL/configureTools/)
        maven "Apache Maven 3.8.5" 
   //}
   stages{
      stage('checkout'){
            steps{
                git branch: 'new-1', url: 'https://github.com/Ramepiq/practice-1.git'
            }
        }
      stage('mvn Build') {
        steps {
         //  withMaven(maven : 'Apache Maven 3.8.5'){
            sh 'mvn clean install'
          
          }
        }
      stage('Deploy to Tomcat'){
          steps {
           deploy adapters: [tomcat9(credentialsId: 'dep', path: '', url: 'http://65.0.29.129:8080/')], contextPath: 'test2', war: '**/*war' 
         }
      } 
    }
    }
