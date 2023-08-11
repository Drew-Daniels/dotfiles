#!/bin/bash

app=""
case "$1" in
    admin)    app="keet-admin";;
    pt)       app="keet-umi";;
    embedded) app="keet-embedded";;
    patient)  app="patient";;
    ptnow)    app="ptnow-patient";;
    mobile)   app="keet-mobile";;
    *) echo "app name must be one of: 'admin', 'pt', 'embedded', 'patient', 'ptnow-patient', 'mobile'" && exit 1
esac

env_path=~/projects/${app}/.env

echo "Adding E2E creds to ${env_path}"

sed -i -E 's/E2E_LOGIN_USERNAME=.*/E2E_LOGIN_USERNAME='"$E2E_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_LOGIN_PASSWORD=.*/E2E_LOGIN_PASSWORD='"$E2E_LOGIN_PASSWORD"'/g' ${env_path}
sed -i -E 's/E2E_SUPER_ADMIN_LOGIN_USERNAME=.*/E2E_SUPER_ADMIN_LOGIN_USERNAME='"$E2E_SUPER_ADMIN_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_SUPER_ADMIN_LOGIN_PASSWORD=.*/E2E_SUPER_ADMIN_LOGIN_PASSWORD='"$E2E_SUPER_ADMIN_LOGIN_PASSWORD"'/g' ${env_path}
sed -i -E 's/E2E_ACCOUNT_ADMIN_LOGIN_USERNAME=.*/E2E_ACCOUNT_ADMIN_LOGIN_USERNAME='"$E2E_ACCOUNT_ADMIN_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_ACCOUNT_ADMIN_LOGIN_PASSWORD=.*/E2E_ACCOUNT_ADMIN_LOGIN_PASSWORD='"$E2E_ACCOUNT_ADMIN_LOGIN_PASSWORD"'/g' ${env_path}
sed -i -E 's/E2E_ADMIN_LOGIN_USERNAME=.*/E2E_ADMIN_LOGIN_USERNAME='"$E2E_ADMIN_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_ADMIN_LOGIN_PASSWORD=.*/E2E_ADMIN_LOGIN_PASSWORD='"$E2E_ADMIN_LOGIN_PASSWORD"'/g' ${env_path}
sed -i -E 's/E2E_PT_LOGIN_USERNAME=.*/E2E_PT_LOGIN_USERNAME='"$E2E_PT_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_PT_LOGIN_PASSWORD=.*/E2E_PT_LOGIN_PASSWORD='"$E2E_PT_LOGIN_PASSWORD"'/g' ${env_path}
sed -i -E 's/E2E_MIPS_PROVIDER_LOGIN_USERNAME=.*/E2E_MIPS_PROVIDER_LOGIN_USERNAME='"$E2E_MIPS_PROVIDER_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_MIPS_PROVIDER_LOGIN_PASSWORD=.*/E2E_MIPS_PROVIDER_LOGIN_PASSWORD='"$E2E_MIPS_PROVIDER_LOGIN_PASSWORD"'/g' ${env_path}
sed -i -E 's/E2E_SUPER_ADMIN_PT_LOGIN_USERNAME=.*/E2E_SUPER_ADMIN_PT_LOGIN_USERNAME='"$E2E_SUPER_ADMIN_PT_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_SUPER_ADMIN_PT_LOGIN_PASSWORD=.*/E2E_SUPER_ADMIN_PT_LOGIN_PASSWORD='"$E2E_SUPER_ADMIN_PT_LOGIN_PASSWORD"'/g' ${env_path}
sed -i -E 's/E2E_PT_SUPPORT_LOGIN_USERNAME=.*/E2E_PT_SUPPORT_LOGIN_USERNAME='"$E2E_PT_SUPPORT_LOGIN_USERNAME"'/g' ${env_path}
sed -i -E 's/E2E_PT_SUPPORT_LOGIN_PASSWORD=.*/E2E_PT_SUPPORT_LOGIN_PASSWORD='"$E2E_PT_SUPPORT_LOGIN_PASSWORD"'/g' ${env_path}


echo "Added E2e creds to ${env_path}"
