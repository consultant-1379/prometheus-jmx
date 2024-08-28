def bob = 'python3 bob/bob2.0/bob.py'

pipeline {
    agent {
        node {
            label params.SLAVE
        }
    }
    stages {
        stage('Prepare environment'){
            steps {
                echo "Prepare Bob environment"
                sh "${bob} clean"
                echo "Init environment"
                withCredentials([string(credentialsId: 'hub-arm-seli-api-token', variable: 'API_TOKEN')]){
                sh "${bob} init"
                 }
            }
        }
        stage('[MUNIN] Check parameters'){
            when { expression { (params.MUNIN_RELEASE == "true") } }
            steps {
                script {
                    if (params.MUNIN_RELEASE_CANDIDATE == null) {
                        error("MUNIN-RELEASE-CANDIDATE is mandatory")
                    }
                }
                sh "${bob} munin-version"
            }
        }
        stage('[PCR] Lint files') {
            when { expression { (params.RELEASE=="false") && (params.MUNIN_RELEASE=="false") } }
            steps {
                sh "${bob} lint"
            }
        }
        stage('Build docker image') {
            when { expression { (params.MUNIN_RELEASE=="false") } }
            steps {
                sh "${bob} image-build"
            }
        }
        stage('[PCR] Test docker image') {
            when { expression { (params.RELEASE=="false") && (params.MUNIN_RELEASE=="false") } }
            steps {
                sh "${bob} image-test"
            }
        }
        stage('[MUNIN] Munin Update') {
            when { expression { (params.MUNIN_UPDATE=="true") } }
            steps {
                withCredentials([string(credentialsId: 'munin_token', variable: 'MUNIN_TOKEN')]){
                    sh "${bob} munin-update-version"
                }
            }
        }
        stage('[MUNIN] Fetch Artifact Checksum') {
            when { expression { (params.MUNIN_RELEASE=="true") } }
            steps {
                withCredentials([string(credentialsId: 'hub-arm-seli-api-token', variable: 'RELEASED_ARTIFACTS_REPO_API_TOKEN')]) {
                    sh "${bob} -r ruleset2.0.yaml fetch-artifact-checksums"
                }
            }
        }
        stage('[MUNIN] Set GITCA Artifacts in Munin') {
            when { expression { (params.MUNIN_RELEASE=="true") } }
            steps {
                withCredentials([string(credentialsId: 'munin_token', variable: 'MUNIN_TOKEN'),
                usernamePassword(credentialsId: 'eadphub-psw', usernameVariable: 'GERRIT_USERNAME', passwordVariable: 'GERRIT_PASSWORD')]){
                    sh "${bob} munin-connect-ca-artifact"
                }
            }
        }
        stage('[MUNIN] Upload to ACA and set info in Munin') {
            when { expression { (params.MUNIN_RELEASE=="true") } }
            steps {
                withCredentials([string(credentialsId: 'munin_token', variable: 'MUNIN_TOKEN'),
                    usernamePassword(credentialsId: 'eadphub-psw', usernameVariable: 'ACA_USERNAME', passwordVariable: 'ACA_PASSWORD')]){
                        sh "${bob} -r ruleset2.0.yaml upload-and-register-artifacts-in-aca"
                }
            }
        }
        stage('[MUNIN] Release version in Munin') {
            when { expression { (params.MUNIN_RELEASE=="true") } }
            steps {
                withCredentials([string(credentialsId: 'munin_token', variable: 'MUNIN_TOKEN')]){
                    sh "${bob} -r ruleset2.0.yaml munin-release-version"
                }
            }
        }
        stage('Push docker image to internal repo') {
            when { expression { (params.MUNIN_RELEASE=="false") } }
            steps {
                sh "${bob} image-push-internal"
            }
        }
        stage('[Release] Push docker image to public repo') {
            when { expression { (params.RELEASE=="true") } }
            steps {
                sh "${bob} create-git-tag"
                sh "${bob} image-publish"
            }
        }

// //The below stages should be uncommented and used for FOSSA Activities
//         stage('FOSSA Report Generation') {
//                     when { expression { (params.RELEASE=="false") } }
//                     steps {
//                         withCredentials([string(credentialsId: 'functional-user-fossa-api-token', variable: 'FOSSA_API_KEY'),string(credentialsId: 'SCAS_token', variable: 'SCAS_TOKEN'),
//                                          usernamePassword(credentialsId: 'eadphub-psw', usernameVariable: 'GERRIT_USERNAME', passwordVariable: 'GERRIT_PASSWORD')]){
//
// //                                //generate the fossa report
// //                             sh "${bob} fossa-report-attribution"
// //                               archiveArtifacts "doc/fossa-jmx-exporter-report-tmp.json"
// //
// //                              sh "${bob} fossa-scan-dependency-update"
// //                              archiveArtifacts "doc/jmx-dependencies-tmp.yaml"
// //
// //                             sh "${bob} scan-scas"
// //                             archiveArtifacts "doc/jmx-dependencies-tmp.yaml"
//
//                              sh "${bob} fossa-scan-validate"
//                              archiveArtifacts "doc/jmx-dependencies-tmp.yaml"
// //
//
// //
//                             sh "${bob} generate-license-agreement"
//                             archiveArtifacts "doc/license.agreement.json"
// //
//                             sh "${bob} license-agreement-validate"
//                             archiveArtifacts "doc/license.agreement.json"
//
//                        }
//
//                  }
//                }
        }
}