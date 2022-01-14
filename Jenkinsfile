podTemplate(label:'demo-service',serviceAccount:'jenkins',containers:[
containerTemplate(name:'gradle',image:'gradle',command:'cat',ttyEnabled:true),
containerTemplate(name:'docker',image:'docker',command:'cat',ttyEnabled:true),
containerTemplate(name:'helm',image:'alpine/helm',command:'cat',ttyEnabled:true)],
volumes:[hostPathVolume(mountPath:'/home/gradle/.gradle',hostPath:'/tmp/jenkins/.gradle'),
hostPathVolume(mountPath:'/var/run/docker.sock',hostPath:'/var/run/docker.sock')]){
   node('demo-service'){
      stage('Build Source Code to Jar file'){
        git url: 'https://github.com/feierice/demo-service.git',credentialsId:'github',branch:'master'
        container('gradle'){
            sh "gradle bootJar"
            env.version=sh(returnStdout: true, script: 'gradle properties -q | grep "version:" | awk \'{print $2}\'').trim()
        }
      }
      stage('Build Docker Image and Push to Docker Registry'){
        container('docker'){
            docker.withRegistry("https://registry.cn-beijing.aliyuncs.com","aliyun"){
                docker.build("feierice/demo-service:${env.version}").push(env.version)
            }
        }
      }
      stage('Deploy to Kubernetes Cluster'){
        container('helm'){
            sh "helm upgrade --install --force --set image.tag=${env.version} demo-service demo-service/"
        }
      }
   }
}