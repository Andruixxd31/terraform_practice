#!/bin/bash
read -p "Enter your username, password and groupname: " username password groupname

echo 

echo "user ${username} signing-up"
signupresult=$(aws cognito-idp sign-up --client-id "294rrrv1g7i4t2sjkcavjetig4" --username "${username}" --password "${password}")
echo "cognitoId: $(jq '.UserSub' <<< "${signupresult}")"

echo

echo "user ${username} getting confirmed in the cognito"
confirmsignup=$(aws cognito-idp admin-confirm-sign-up --user-pool-id "us-east-1_rF04cntq9" --username "${username}")

echo 

echo "adding user to group: ${groupname}"
addusertogroupresult=$(aws cognito-idp admin-add-user-to-group --user-pool-id "us-east-1_rF04cntq9" --username "${username}" --group-name "${groupname}")

echo 

echo "user ${username} signing-in"
signinresult=$(aws cognito-idp admin-initiate-auth --user-pool-id "us-east-1_rF04cntq9" --client-id "294rrrv1g7i4t2sjkcavjetig4" --auth-flow "ADMIN_NO_SRP_AUTH" --auth-parameters USERNAME="${username}",PASSWORD="${password}")
IdToken=$(jq '.AuthenticationResult.IdToken' <<< "${signinresult}")
echo "IdToken: ${IdToken}"

echo

echo "user ${username} getting identity-id"
getidresult=$(aws cognito-identity get-id --account-id "549218392771" --identity-pool-id "us-east-1:240313f0-3498-4b05-90ab-89ce1119a0f1" --logins "cognito-idp.us-east-1.amazonaws.com/us-east-1_rF04cntq9"="${IdToken}")
IdentityId=$(jq -r '.IdentityId' <<< "${getidresult}")
echo "IdentityId : ${IdentityId}"

echo

echo "user ${username} getting credentials"
getcredentialsforidentity=$(aws cognito-identity get-credentials-for-identity --identity-id "${IdentityId}" --logins "cognito-idp.us-east-1.amazonaws.com/us-east-1_rF04cntq9"="${IdToken}")
echo "${getcredentialsforidentity}"	
