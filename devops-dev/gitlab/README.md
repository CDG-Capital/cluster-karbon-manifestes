# https://gitlab.com/gitlab-org/charts/gitlab/-/tree/master/
# https://gitlab.com/gitlab-org/charts/gitlab/-/blob/master/doc/charts/minio/index.md
# https://docs.gitlab.com/ee/administration/gitaly/praefect.html
# https://docs.gitlab.com/ee/administration/repository_storage_paths.html


# Getting value-gitlab.yaml

$ helm inspect values gitlab/gitlab > values-gitlab.yaml

# Create Namespace git-system:

$ kubectl --kubeconfig /home/centos/.kube/config-devops-dev create ns git-system

# Installing Gitlab by helm chart

$ helm repo add gitlab https://charts.gitlab.io

$ helm repo update

$ helm --kubeconfig /home/centos/.kube/config-devops-dev -n git-system install gitlab -f values-gitlab.yaml gitlab/gitlab

# Editing ingress and deletting nginx-class

$ kubectl --kubeconfig /home/centos/.kube/config-devops-dev -n git-system edit ing gitlab-webservice-default

# Editing PVC and increase the size of storage from 50Gi to 100Gi

$ kubectl --kubeconfig /home/centos/.kube/config-devops-dev -n git-system edit pvc repo-data-gitlab-gitaly-0



# Configure keycloak as OIDC for Gitlab Authentication :

# https://edenmal.moe/post/2018/GitLab-Keycloak-SAML-2-0-OmniAuth-Provider/

Steps :

Step 1 - Create SAML Client in Keycloak
Step 2 - Configure SAML Client in Keycloak
Settings Tab
Roles Tab
Mappers Tab
Scope Tab
Step 3 - Get Certificate Fingerprint
Step 4 - Configure GitLab
Adding the SAML OmniAuth Provider configuration
Step 5 - Try to login to your GitLab


# SAML OmniAuth Provider Configuration :

Create a file named : provider-keycloak-finger.yaml 

name: saml
label: 'KEYCLOAK LOGIN'
groups_attribute: 'roles'
external_groups:
- 'gitlab.devops.cdg.com:external'
args:
  assertion_consumer_service_url: 'https://gitlab.devops.cdg.com/users/auth/saml/callback'
  idp_cert_fingerprint: '9B:4E:69:AC:CA:B7:23:22:B4:67:87:70:5C:37:75:9C:B7:D6:8A:B3'
  idp_sso_target_url: 'http://auth.portail-dev.cdg.com/auth/realms/gitlab-realm/protocol/saml/clients/gitlab.devops.cdg.com'
  issuer: 'gitlab.devops.cdg.com'
  attribute_statements:
    first_name:
    - 'first_name'
    last_name:
    - 'last_name'
    name:
    - 'name'
    username:
    - 'name'
    email:
    - 'email'
  name_identifier_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'


# Create a secret provider-keycloak with provider data :

$ kdevops -n git-system create secret generic provider-keycloak --from-file=provider-keycloak=provider-keycloak.yaml

Now we have created the secret provider-keycloak with its key named provider-keycloak


# Preparing the fingerprint of certificate downloaded from realm keys as explained here : https://edenmal.moe/post/2018/GitLab-Keycloak-SAML-2-0-OmniAuth-Provider/

the script convert-fingerprint.sh is :


IDP_DESCRIPTOR_FILE="./exportSaml"
(
    echo "-----BEGIN CERTIFICATE-----"
    grep -oP '<ds:X509Certificate>(.*)</ds:X509Certificate>' "$IDP_DESCRIPTOR_FILE" | sed -r -e 's~<[/]?ds:X509Certificate>~~g' | fold -w 64
    echo "-----END CERTIFICATE-----"
) | openssl x509 -noout -fingerprint -sha1



the file exportSaml contains the Saml downloaded from keycloak


the fingerprint obained is setted in : idp_cert_fingerprint of the provider-keycloak-finger.yaml file

this step is before creating the secret


# Configuration of values.yaml

in the section Omniauth modify the setting as bellow :

    ## doc/charts/globals.md#omniauth
    omniauth:
      enabled: true
      autoSignInWithProvider:
      syncProfileFromProvider: []
      syncProfileAttributes: ['email']
      allowSingleSignOn: ['saml']
      blockAutoCreatedUsers: false
      autoLinkLdapUser: true
      autoLinkSamlUser: true
      autoLinkUser: []
      externalProviders: []
      allowBypassTwoFactor: []
      providers:
      - secret: provider-keycloak
        key: provider-keycloak


enable=true to activate omniauth in the chart helm
blockAutoCreatedUsers: false to desabling the behavior of Gitlab, meaking the keycloak users as blocked in the first time until unlocked them by an admin

 providers:  to use the provider config mounted as volume from the secret
      - secret: provider-keycloak
        key: provider-keycloak


# apply the changes on the instance deployed by helm chart :

$ helm --kubeconfig /home/centos/.kube/kubeconfigdevops -n git-system upgrade gitlab -f values-gitlab.yaml gitlab/gitlab

# if you encounter a problem with ingress fiw the problem as mentioned in the ingress section explained before


