#!/bin/bash
#
# Windows shell provisioner for Ansible playbooks, based on KSid's
# windows-vagrant-ansible: https://github.com/KSid/windows-vagrant-ansible
#
# @see README.md
# @author Jeff Geerling, 2014

# Uncomment if behind a proxy server.
# export {http,https,ftp}_proxy='http://username:password@proxy-host:80'

args=()
extra_vars=("is_windows=true")

# Process and remove all flags.
while (($#)); do
  case $1 in
    --extra-vars=*) extra_vars+=("${1#*=}") ;;
    --extra-vars|-e) shift; extra_vars+=("$1") ;;
    -*) echo "invalid option: $1" >&2; exit 1 ;;
    *) args+=("$1") ;;
  esac
  shift
done

# Restore the arguments without flags.
set -- "${args[@]}"

ANSIBLE_PLAYBOOK=$1
PLAYBOOK_DIR=${ANSIBLE_PLAYBOOK%/*}

# Detect package management system.
YUM=$(which yum 2>/dev/null)
APT_GET=$(which apt-get 2>/dev/null)

# Make sure Ansible playbook exists.
if [ ! -f "$ANSIBLE_PLAYBOOK" ]; then
  echo "Cannot find Ansible playbook."
  exit 1
fi

# Install Ansible and its dependencies if it's not installed already.
if ! command -v ansible >/dev/null; then
  echo "Installing Ansible dependencies and Git."
  if [[ ! -z ${YUM} ]]; then
    yum install -y git python python-devel
  elif [[ ! -z ${APT_GET} ]]; then
    apt-get update
    apt-get install -y git python python-dev
  else
    echo "Neither yum nor apt-get are available."
    exit 1;
  fi

  echo "Installing pip."
  wget https://bootstrap.pypa.io/get-pip.py
  python get-pip.py && rm -f get-pip.py

  echo "Installing required build tools."
  if [[ ! -z $YUM ]]; then
    yum install -y gcc libffi-devel openssl-devel
  elif [[ ! -z $APT_GET ]]; then
    apt-get install -y build-essential libssl-dev libffi-dev
  fi

  echo "Installing required python modules."
  pip install paramiko pyyaml jinja2 markupsafe

  echo "Installing Ansible."
  pip install ansible
fi

# Install requirements.
echo "Installing Ansible roles from requirements file, if available."
find "$PLAYBOOK_DIR" \( -name "requirements.yml" -o -name "requirements.txt" \) -exec sudo ansible-galaxy install --force --ignore-errors -r {} \;

# Run the playbook.
echo "Running Ansible provisioner defined in Vagrantfile."
ansible-playbook -i 'localhost,' "${ANSIBLE_PLAYBOOK}" --extra-vars "${extra_vars[*]}" --connection=local
