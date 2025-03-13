pipeline {
    agent any

    tools {
        terraform 'Terraform'  
        ansible 'Ansible'      
    }

    environment {
        TF_VAR_region = 'eu-north-1'                
        TF_VAR_key_name = 'ansible'                  
        TF_IN_AUTOMATION = 'true'                    
        ANSIBLE_HOST_KEY_CHECKING = 'False'          
        ANSIBLE_REMOTE_USER = 'ubuntu'               
    }

    stages {
        stage('Clone Repository') {
             steps {
        git(
            branch: 'main',
            credentialsId: 'github-creds',   // GitHub credentials ID (Jenkins me configure hona chahiye)
            url: 'https://github.com/harsh-mygurukulam/prom.git'
        )
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'rm -rf .terraform terraform.tfstate terraform.tfstate.backup'
                        sh 'terraform init -reconfigure'
                    }
                }
            }
        }
        

        stage('Terraform Validate') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform validate'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('User Approval for Apply') {
            steps {
                script {
                    def userInput = input(
                        message: 'Proceed with Terraform Apply?', 
                        parameters: [booleanParam(defaultValue: true, description: 'Apply changes?', name: 'apply')]
                    )
                    env.PROCEED_WITH_APPLY = userInput.toString()
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { env.PROCEED_WITH_APPLY == 'true' }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('User Choice: Destroy or Ansible?') {
            steps {
                script {
                    def userChoice = input(
                        message: 'What do you want to do next?',
                        parameters: [
                            choice(choices: ['Run Ansible Role', 'Destroy Infrastructure'], 
                            description: 'Select an option', name: 'next_step')
                        ]
                    )
                    env.NEXT_STEP = userChoice
                }
            }
        }

        stage('Run Ansible Role') {
            when {
                expression { env.NEXT_STEP == 'Run Ansible Role' }
            }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'SSH_KEY', keyFileVariable: 'SSH_KEY')]) {
                    dir('prometheus-roles') {
                        sh 'echo "Using AWS EC2 Dynamic Inventory for Ansible"'
                        sh 'ansible-inventory -i aws_ec2.yml --graph'  
                        sh 'ansible-playbook -i aws_ec2.yml playbook.yml --private-key=$SSH_KEY'
  
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { env.NEXT_STEP == 'Destroy Infrastructure' }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Sending email notification..."
                emailext(
                    subject: "Jenkins Pipeline Execution Status",
                    body: """
                        <h2>Jenkins Pipeline Execution Completed</h2>
                        <p><b>Build Status:</b> ${currentBuild.currentResult}</p>
                        <p><b>Job:</b> ${env.JOB_NAME}</p>
                        <p><b>Build Number:</b> ${env.BUILD_NUMBER}</p>
                        <p><b>Build URL:</b> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                    """,
                    to: 'harshwardhandatascientist@gmail.com',
                    mimeType: 'text/html'
                )
            }
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
        aborted {
            echo 'Pipeline was manually aborted.'
        }
    }
}
