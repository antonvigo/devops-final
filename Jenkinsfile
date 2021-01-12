pipeline {
  agent any
  environment {
    gitUrl = "git@gitlab.rebrainme.com:devops_users_repos/866/rebrain-devops-test.git"
    tmpDir = "/home/cicd/tmp"
    HC_TOKEN = credentials('hc-token')
    ANS_VAULT = credentials('ans-vault-psw')
    DB_CREDS = credentials('db-creds')
    CMS_CREDS = credentials('cms-creds')
  }
  stages {
    stage('Create environment') {
      steps {
        git credentialsId: "gl-sec-key", url: "${gitUrl}"
        script {
          sh 'echo $ANS_VAULT > ./.infra/ansible/etc-data/.vault_psw.txt'
          sh 'cd .infra/terraform && terraform init'
          sh 'cd .infra/terraform && terraform apply -auto-approve -var="hc_token=$HC_TOKEN"'
          sh 'rm ./.infra/ansible/etc-data/.vault_psw.txt'
          env.remoteHost = "cicd@" + sh (script: "cat .infra/terraform/terraform.tfstate | jq .resources[0].instances[0].attributes.vars.hostnames | sed 's/\"//g'", returnStdout: true).trim()
          env.sshToHost = "ssh -o StrictHostKeyChecking=no ${remoteHost}"
          echo "# ====> remoteHost variable value is: " + env.remoteHost + "\n"
          echo "# ====> sshToHost variable value is: " + env.sshToHost + "\n"
        }
      }
    }
    stage('Build application') {
      steps {
        sshagent(['cicd-sec-key']) {
          sh '\$sshToHost mkdir -p \$tmpDir/october_tmp'
          sh 'scp -r ./* \$remoteHost:\$tmpDir/october_tmp'
          sh '\$sshToHost "cd \$tmpDir/october_tmp && composer install"'
          sh '\$sshToHost "sed -i -E \'s/(.disableCoreUpdates. => )false/\\1true/\' \$tmpDir/october_tmp/config/cms.php"'
          sh '\$sshToHost "cd \$tmpDir/october_tmp && echo -e \'1\n\n\ndb_october_cms\n$DB_CREDS_USR\n$DB_CREDS_PSW\nAnton\nGoremykin\n\n$CMS_CREDS_USR\n$CMS_CREDS_PSW\n\n\n\n\' | php artisan october:install"'
        }
      }
    }
    stage('Symlink deploy new version of application') {
      steps {
        script {
          def now = new Date()
          env.deployDate = now.format("yyyyMMddHHmm")
          env.deployDir = '/opt/october_cms/' + env.deployDate
          env.commonAppDir = '/opt/october_cms/common'
        }
        sshagent(['cicd-sec-key']) {
          sh '\$sshToHost sudo mkdir -p \$commonAppDir'
          sh '\$sshToHost sudo mkdir -p \$deployDir'
          sh '\$sshToHost sudo cp -npr \$tmpDir/october_tmp/config \$commonAppDir/config'
          sh '\$sshToHost sudo ln -snf \$commonAppDir/config \$deployDir/config'
          sh '\$sshToHost sudo cp -npr \$tmpDir/october_tmp/storage \$commonAppDir/storage'
          sh '\$sshToHost sudo ln -snf \$commonAppDir/storage \$deployDir/storage'
          sh '\$sshToHost "cd \$tmpDir/october_tmp && sudo mv -t \$deployDir artisan  bootstrap  index.php  modules  plugins  server.php  themes  vendor"'
          sh '\$sshToHost "sudo chown -R www-data. \$deployDir \$commonAppDir"'
          sh '\$sshToHost sudo ln -snf \$deployDir /var/www/application'
        }        
      }
    }
    stage('Clean out the trash') {
      steps {
        sshagent(['cicd-sec-key']) {
          sh '\$sshToHost rm -rf \$tmpDir/october_tmp'
        }
        script {
          echo "# ====> remoteHost variable value is: " + env.remoteHost + "\n"
        }        
      }
    }
  }
}