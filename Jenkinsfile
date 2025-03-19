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
        PATH = "/home/ubuntu/.local/bin:$PATH"
        ANSIBLE_PYTHON_INTERPRETER = "/usr/bin/python3"
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    if (fileExists('prom')) {
                        dir('prom') {
                            sh 'git pull origin main'
                        }
                    } else {
                        git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/harsh-mygurukulam/prom.git'
                    }
                }
            }
        }

        stage('Terraform Initialization') {
            steps {
                withCredentials([aws(credentialsId: 'aws-creds')]) {
                    dir('prometheus-terraform') {
                        sh 'terraform fmt'
                        sh 'terraform init -reconfigure'
                    }
                }
            }
        }

        stage('Terraform Validate & Plan') {
            steps {
                withCredentials([aws(credentialsId: 'aws-creds')]) {
                    dir('prometheus-terraform') {
                        sh 'terraform validate'
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('User Approval for Apply') {
            steps {
                script {
                    try {
                        def userInput = input(
                            message: 'Proceed with Terraform Apply?', 
                            parameters: [booleanParam(defaultValue: true, description: 'Apply changes?', name: 'apply')]
                        )
                        env.PROCEED_WITH_APPLY = userInput.toString()
                    } catch (err) {
                        env.PROCEED_WITH_APPLY = 'false'
                        error('User did not approve Terraform Apply. Aborting pipeline.')
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { env.PROCEED_WITH_APPLY == 'true' }
            }
            steps {
                withCredentials([aws(credentialsId: 'aws-creds')]) {
                    dir('prometheus-terraform') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

     

        stage('Choose Next Action') {
            steps {
                script {
                    def userChoice = input(
                        message: 'What do you want to do next?',
                        parameters: [
                            choice(choices: ['Run Ansible Role', 'Destroy Infrastructure'], description: 'Select an option', name: 'next_step')
                        ]
                    )
                    env.NEXT_STEP = userChoice
                }
            }
        }

        stage('Run Ansible Role - Node Exporter') {
            when {
                expression { env.NEXT_STEP == 'Run Ansible Role' }
            }
            steps {
                withAWS(credentials: 'aws-creds', region: 'eu-north-1') {
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'SSH_KEY', keyFileVariable: 'SSH_KEY'),
                        string(credentialsId: 'SMTP_PASSWORD', variable: 'SMTP_PASS')
                    ]) {
                        dir('node_exp') {
                            sh '''
                                echo "Running Ansible Role: Node Exporter"
                                ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_aws_ec2.yml install.yml \
                                --private-key=$SSH_KEY -u ubuntu --extra-vars 'smtp_auth_password="${SMTP_PASS}"'
                            '''
                        }
                    }
                }
            }
        }

        stage('Run Ansible Playbook - Prometheus Setup') {
            when {
                expression { env.NEXT_STEP == 'Run Ansible Role' }
            }
            steps {
                withAWS(credentials: 'aws-creds', region: 'eu-north-1') {
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'SSH_KEY', keyFileVariable: 'SSH_KEY'),
                        string(credentialsId: 'SMTP_PASSWORD', variable: 'SMTP_PASS')
                    ]) {
                        dir('prometheus-roles') {
                            sh '''
                                echo "Using AWS EC2 Dynamic Inventory for Ansible"
                                ANSIBLE_HOST_KEY_CHECKING=False ansible-inventory -i aws_ec2.yml --graph

                                echo "Running Ansible Playbook..."
                                ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i aws_ec2.yml playbook.yml \
                                --private-key=$SSH_KEY -u ubuntu --extra-vars 'smtp_auth_password="${SMTP_PASS}"'
                            '''
                        }
                    }
                }
            }
        }

        stage('Destroy Terraform Resources') {
            when {
                expression { env.NEXT_STEP == 'Destroy Infrastructure' }
            }
            steps {
                withCredentials([aws(credentialsId: 'aws-creds')]) {
                    dir('prometheus-terraform') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {
    success {
        emailext(
            subject: " SUCCESS: Jenkins Build #${env.BUILD_NUMBER}",
            body: """
                <h2>Jenkins Pipeline Executed Successfully!</h2>
                <p><b>✔ Job:</b> ${env.JOB_NAME}</p>
                <p><b>Build Number:</b> ${env.BUILD_NUMBER}</p>
                <p><b>Build URL:</b> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
            """,
            to: 'harshwardhandatascientist@gmail.com',
            mimeType: 'text/html'
        )
    }
}

}
