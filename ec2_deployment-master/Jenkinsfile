pipeline
{
	agent any
	environment
	{
	awscredential = credentials("TEJASA")
	}
	stages
	{
		stage('Creating EC2 Instance')
		{
			steps
			{
				sh '''
			 aws configure set default.region ap-south-1
			 aws ec2 run-instances --image-id ami-079b5e5b3971bd10d --count 1 --instance-type t2.micro --key-name tjkey --security-group-ids sg-0efc02319e1096486  --subnet-id subnet-b98413f5 --query 'Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress' --output text >> machin.inv
			cat machin.inv '''
			sleep time: 60000, unit: 'MILLISECONDS'
			}
		}
		stage('Checking Ansible Verision')
		{
			steps
			{
				sh '''
				ansible --version
				ansible-playbook --version
				'''
			}
		}
		stage('Running Playbook')
		{
			steps
			{
				ansiblePlaybook credentialsId: 'EC2-User', disableHostKeyChecking: true, installation: 'ansible1', inventory: 'machin.inv', playbook: 'httpd_deploy.yml'
			}
		}
	}
}
