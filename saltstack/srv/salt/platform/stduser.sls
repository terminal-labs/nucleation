install_vagrant_extras:
  cmd.run:
    - cwd: /home/vagrant
    - name: vagrant plugin install --plugin-version 4.3.0 ovirt-engine-sdk
    - runas: vagrant

create_virtualenv:
  cmd.run:
    - cwd: /home/vagrant
    - name: virtualenv -p python3.6 env
    - runas: vagrant

install_rambo:
  cmd.run:
    - cwd: /home/vagrant
    - name: . env/bin/activate; pip install rambo-vagrant
    - runas: vagrant

install_rambo_plugins:
  cmd.run:
    - cwd: /home/vagrant
    - name: . env/bin/activate; pip install rambo-vagrant
    - runas: vagrant

cleanup:
  cmd.run:
    - cwd: /home/vagrant
    - name: rm bootstrap-salt.sh; rm VBoxGuestAdditions_5.1.30.iso.1
    - runas: vagrant
