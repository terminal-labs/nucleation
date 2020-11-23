prep_for_python36:
  cmd.run:
    - cwd: /home/vagrant
    - name: add-apt-repository -y ppa:deadsnakes/ppa

update_for_python36:
  cmd.run:
    - cwd: /home/vagrant
    - name: apt update

install_python36:
  cmd.run:
    - cwd: /home/vagrant
    - name: apt install -y python3.6

install_virtualenv:
  cmd.run:
    - cwd: /home/vagrant
    - name: apt install -y virtualenv

download_vagrant:
  cmd.run:
    - cwd: /home/vagrant
    - name: curl -O https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb

install_vagrant:
  cmd.run:
    - cwd: /home/vagrant
    - name: dpkg -i vagrant_2.2.6_x86_64.deb

remove_vagrant_deb:
  cmd.run:
    - cwd: /home/vagrant
    - name: rm vagrant_2.2.6_x86_64.deb
