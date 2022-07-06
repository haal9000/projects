#!/bin/bash

OS=`uname`
magento_cloud_project="git@github.com:magento-commerce/magento-cloud.git"
git_repo="${PROJECT_ID}@git.us-4.magento.cloud:${PROJECT_ID}.git"
branch="master"
echo "GIT_REPO: ${git_repo}"


if [ ! -d "$DIR" ]; then
  # clone the project if it is not present.
  mkdir -p ${DIR}
  # git clone --branch master ${PROJECT_ID}@git.us-4.magento.cloud:${PROJECT_ID}.git ${DIR}
fi
cd ${DIR}
echo "REMOTE ORIGIN URL: `git config --get remote.origin.url`"

if [[ `git config --get remote.origin.url` != ${git_repo} ]]; then

    echo "working directory:${DIR}"
    echo "##############################################"
    echo "cloning magento cloud base project"
    echo "##############################################"
    rm -rf && git clone ${magento_cloud_project} .
    rm -rf .git
    git config --global init.defaultBranch master
    git config user.email "platformsh@adobe.com"
    git config user.name "platformsh"
    git init
    git branch -m master

    git remote add origin ${git_repo}
elif [[ `git config --get remote.origin.url` == ${git_repo} ]]; then
    echo "working directory:${DIR}"
    echo "##############################################"
    echo "pulling changes from existing project"
    echo "##############################################"
    # git clone ${git_repo} .
    git pull
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
