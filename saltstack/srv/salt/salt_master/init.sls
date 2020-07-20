install_salt_deps:
  pkg.installed:
    - pkgs:
      - python-software-properties
      - python-dev
      - python-m2crypto
      - python-virtualenv
      - zlib1g-dev
      - libffi-dev
      - python3-dev

bitbucket.org:
  ssh_known_hosts:
    - present
    - fingerprint: {{ grains['fingerprint'] }}
    - fingerprint_hash_type: md5
    - timeout: 90

clone_salt:
   git.latest:
     - branch: v3000.3
     - name: https://bitbucket.org/terminal_labs/saltstack.git
     - target: /home/saltmaster/salt_src
     - user: root

/home/saltmaster/salt_src:
  file.directory:
    - user: saltmaster
    - group: saltmaster
    - recurse:
      - user
      - group

create_salt_controlplane:
  file.directory:
    - name: /home/saltmaster/salt_controlplane
    - user: saltmaster
    - group: saltmaster

install_venv:
  cmd.run:
    - name: virtualenv -p /usr/bin/python3 /home/saltmaster/salt_venv
    - runas: saltmaster

update_pip:
  cmd.run:
    - name: ./bin/pip install -U setuptools; ./bin/pip install -U pip
    - cwd: /home/saltmaster/salt_venv
    - runas: saltmaster

place_pip_requirements_file:
  file.managed:
    - name: /home/saltmaster/salt_venv/requirements.txt
    - source: salt://salt_master/requirements.txt
    - user: saltmaster
    - group: saltmaster

place_pip_requirements:
  cmd.run:
    - name: ./bin/pip install -r requirements.txt
    - cwd: /home/saltmaster/salt_venv
    - runas: saltmaster

install_salt_src:
  cmd.run:
    - name: ./bin/pip install -e /home/saltmaster/salt_src
    - cwd: /home/saltmaster/salt_venv
    - runas: saltmaster

create_salt_root_dir:
  file.directory:
    - name: /home/saltmaster/salt_controlplane/etc/salt
    - user: saltmaster
    - group: saltmaster
    - makedirs: True

create_modules_dir:
  file.directory:
    - name: /home/saltmaster/salt_controlplane/etc/salt/_modules
    - user: saltmaster
    - group: saltmaster
    - makedirs: True

place_cluster_files:
  cmd.run:
    - name: cp -r /vagrant/inflation_resources/cluster_init /home/saltmaster/salt_controlplane/etc/salt
    - cwd: /home/saltmaster
    - runas: saltmaster

place_deploy_script_files:
  cmd.run:
    - name: cp -r /vagrant/inflation_resources/cloud.deploy.d /home/saltmaster/salt_controlplane/etc/salt
    - cwd: /home/saltmaster
    - runas: saltmaster

place_modules_files:
  cmd.run:
    - name: cp -r /vagrant/salt_resources/modules/. /home/saltmaster/salt_controlplane/etc/salt/_modules
    - cwd: /home/saltmaster
    - runas: saltmaster

place_pillar_files:
  cmd.run:
    - name: cp -r /vagrant/salt_resources/pillars/. /home/saltmaster/salt_controlplane/etc/pillar
    - cwd: /home/saltmaster
    - runas: saltmaster

place_cloud_file:
  file.managed:
    - name: /home/saltmaster/salt_controlplane/etc/salt/cloud
    - source: salt://salt_master/cloud
    - user: saltmaster
    - group: saltmaster

place_salt_master_file:
  file.managed:
    - name: /home/saltmaster/salt_controlplane/etc/salt/master
    - source: salt://salt_master/master
    - user: saltmaster
    - group: saltmaster

place_salt_minion_file:
  file.managed:
    - name: /home/saltmaster/salt_controlplane/etc/salt/minion
    - source: salt://salt_master/minion
    - user: saltmaster
    - group: saltmaster

place_salt_cloud_providers_file:
  cmd.run:
    - name: cp -r /vagrant/.tmp/cloud.providers /home/saltmaster/salt_controlplane/etc/salt/cloud.providers
    - cwd: /home/saltmaster
    - runas: saltmaster

place_salt_cloud_profiles_file:
  cmd.run:
    - name: cp -r /vagrant/.tmp/cloud.profiles /home/saltmaster/salt_controlplane/etc/salt/cloud.profiles
    - cwd: /home/saltmaster
    - runas: saltmaster

place_salt_cloud_map_file:
  cmd.run:
    - name: cp -r /vagrant/.tmp/cloud.map /home/saltmaster/salt_controlplane/etc/salt/cloud.map
    - cwd: /home/saltmaster
    - runas: saltmaster

place_imported_salt_states:
  cmd.run:
    - name: cp -r /vagrant/.tmp/imported_salt_states/. /home/saltmaster/salt_controlplane/etc/salt
    - cwd: /home/saltmaster
    - runas: saltmaster

place_cloud_driver_keys:
  cmd.run:
    - name: cp -r /vagrant/auth/keys/. /home/saltmaster/salt_controlplane/keys
    - cwd: /home/saltmaster

place_salt_cloud_patch_dir:
  cmd.run:
    - name: cp -r /vagrant/inflation_resources/vboxsaltdriver /home/saltmaster/vboxsaltdriver_src
    - cwd: /home/saltmaster
    - runas: saltmaster

install_salt_cloud_driver:
  cmd.run:
    - name: ./bin/pip install -e ../vboxsaltdriver_src
    - cwd: /home/saltmaster/salt_venv
    - runas: saltmaster

patch_saltcloud:
  cmd.run:
    - name: bash /home/saltmaster/vboxsaltdriver_src/patch.sh
    - cwd: /home/saltmaster
    - runas: saltmaster

create_keys_dir:
  file.directory:
    - name: /home/saltmaster/salt_controlplane/keys
    - user: saltmaster

generate_ssh_key_for_universal_login:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /var/tmp/universal_cluster_key
    - runas: saltmaster
    - unless: test -f /var/tmp/universal_cluster_key

place_pri_ssh_key_for_universal_login:
  cmd.run:
    - name: cp /var/tmp/universal_cluster_key /home/saltmaster/salt_controlplane/etc/salt/universal_cluster_key
    - cwd: /home/saltmaster

place_pub_ssh_key_for_universal_login:
  cmd.run:
    - name: cp /var/tmp/universal_cluster_key.pub /home/saltmaster/salt_controlplane/etc/salt/universal_cluster_key.pub
    - cwd: /home/saltmaster
    - runas: saltmaster

place_bash_aliases_for_saltmaster:
  cmd.run:
    - name: cp -r /vagrant/inflation_resources/bash_aliases/saltmaster.sh /home/saltmaster/.bash_aliases
    - cwd: /home/saltmaster
    - runas: saltmaster

place_bash_aliases_for_vagrant:
  cmd.run:
    - name: cp -r /vagrant/inflation_resources/bash_aliases/vagrant.sh /home/vagrant/.bash_aliases
    - cwd: /home/saltmaster

place_internal_cli_script:
  cmd.run:
    - name: cp -r /vagrant/inflation_resources/internal_cli.py /home/saltmaster/salt_controlplane/internal_cli.py
    - cwd: /home/saltmaster

install_internal_cli_deps:
  cmd.run:
    - name: ./bin/pip install click bash
    - cwd: /home/saltmaster/salt_venv
    - runas: saltmaster

/home/saltmaster:
  file.directory:
    - user: saltmaster
    - group: saltmaster
    - recurse:
      - user
      - group

/home/vagrant:
  file.directory:
    - user: vagrant
    - group: vagrant
    - recurse:
      - user
      - group
