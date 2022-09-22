#!/bin/bash

OS=`uname`
# repository url which contains the base template for commerce cloud project
magento_cloud_project="git@github.com:magento-commerce/magento-cloud.git"

# repository url for the project that will be created on commerce cloud
git_repo="${PROJECT_ID}@git.us-4.magento.cloud:${PROJECT_ID}.git"
branch="master"
echo "GIT_REPO: ${git_repo}"



git ls-remote $git_repo
retvalue=$?

# If a local project directory does not exist and magento git project exists, it clones the repo 
if [[ ! -d "$DIR" ]] && [[ $retvalue == 0 ]]; then
    echo "##############################################"
    echo "magento git project already exists. cloning the project"
    echo "##############################################"
    mkdir -p ${DIR}
    cd ${DIR}
    git clone ${git_repo} .
    echo "REMOTE ORIGIN URL: `git config --get remote.origin.url`"
# If a local project directory and magento git project both exist, it pulls the latest code    
elif [[ -d "$DIR" ]] && [[ $retvalue == 0 ]]; then
    cd ${DIR}
    echo "working directory:${DIR}"
    echo "##############################################"
    echo "pulling changes from existing project"
    echo "##############################################"
    echo "REMOTE ORIGIN URL: `git config --get remote.origin.url`"
    git pull
# creates a local project directory and clones the base template from commerce cloud project
else
    mkdir -p ${DIR}
    cd ${DIR}
    echo "working directory:${DIR}"
    echo "##############################################"
    echo "cloning base project template from magento cloud repository"
    echo "##############################################"
    rm -rf && git clone ${magento_cloud_project} .
    rm -rf .git
    git config --global --unset init.defaultbranch
    git config init.defaultBranch master
    git init
    git config user.email "platformsh@adobe.com"
    git config user.name "platformsh"
    git branch -m master

    git remote add origin ${git_repo}
    echo "REMOTE ORIGIN URL: `git config --get remote.origin.url`"
fi


cp ../cloudbackend/composer.json .
mv ../cloudbackend/configs/services.yaml .magento
# rm -rf auth.json
mv ../cloudbackend/configs/auth.json .
composer update


if [ -z "$(git status --porcelain)" ]; then 
  echo "Working directory clean. No changes to commit."
else 
  echo "Uncommitted changes present. Adding the changes to the repo."
  git add .
  git commit -m "$(date)"
  # MAGENTO_BACKEND_URL=`git push 2>&1 | tee >(cat 1>&2) | grep -n "Warmed up page:" | awk -F "page: " '{print $2}'`
  MAGENTO_BACKEND_URL=`git push --set-upstream origin master 2>&1 | tee >(cat 1>&2) | grep -n "Warmed up page:" | awk -F "page: " '{print $2}'`
  echo "MAGENTO_BACKEND_URL: ${MAGENTO_BACKEND_URL}"
  if [ -z "${MAGENTO_BACKEND_URL}" ]; then
    echo "Cloud instance doesn't have a URL. Please check if environment is built without errors"
    exit 1
  else
    cp ../cloudbackend/configs/.magento.app.yaml . 
    echo "OS: ${OS}"
    if [[ $OS == 'Darwin' ]]; then
      sed -i "" "s|{MAGENTO_BACKEND_URL}|\'${MAGENTO_BACKEND_URL}\'|g" .magento.app.yaml
    else
      sed -i "s|{MAGENTO_BACKEND_URL}|\'${MAGENTO_BACKEND_URL}\'|g" .magento.app.yaml
    fi
    echo "Adding untracked files to the repo."
    git add .
    git commit -m "$(date)"
    git push  
  fi
fi   
