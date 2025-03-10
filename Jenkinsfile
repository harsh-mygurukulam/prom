pipeline {
    agent any

    tools {
        terraform 'Terraform'  // Match this with the name set in Global Tool Configuration
        ansible 'Ansible'      // Match this with the name set in Global Tool Configuration
    }

    environment {
        TF_VAR_region = 'eu-north-1'                 // Terraform region variable
        TF_VAR_key_name = 'ansible'                  // Terraform key pair
        TF_IN_AUTOMATION = 'true'                    // Disable interactive prompts for Terraform
        ANSIBLE_HOST_KEY_CHECKING = 'False'          // Disable SSH prompt for Ansible
        ANSIBLE_REMOTE_USER = 'ubuntu'               // Remote SSH user for Ansible
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/harsh-mygurukulam/prom.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform init'
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

        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    dir('prometheus-terraform') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'SSH_KEY', keyFileVariable: 'SSH_KEY')]) {
                    dir('prometheus-roles') {
                        sh 'chmod +x dynamic_inventory.sh'
                        sh './dynamic_inventory.sh'
                        sh 'echo Generated Inventory File:'
                        sh 'cat inventory.ini'  // Verify the output of the inventory
                        sh 'ansible-playbook -i inventory.ini playbook.yml --private-key=$SSH_KEY'
                    }
                }
            }
        }
    }

    post {
        always {
            input message: 'Do you want to destroy the infrastructure?', ok: 'Destroy'
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                dir('prometheus-terraform') {
                    sh 'terraform destroy -auto-approve'
                }
            }
            echo ' Pipeline execution completed.'
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'pipeline failed. Check the logs for details.'
        }
        aborted {
            echo ' Pipeline was manually aborted.'
        }
    }
}
