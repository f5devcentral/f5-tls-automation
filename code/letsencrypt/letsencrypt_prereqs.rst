==============================================
BIG-IP - Letsencrypt with F5 Cloudservices DNS
==============================================

.. note:: Tested with Ansible 2.09

*******
Summary
*******

This documents how to setup the ansible environment to use the role.

*************
Prerequesites
*************

Following Prerequesites are needed

1. F5 Cloudservices account with subscruption to primary DNS service
2. primary Zone for domain exists
3. Ansible 2.9
4. jmespath installed on ansible host

Here a script that can run on an ubuntu 18.04 host to install all required software:

.. literalinclude :: ubuntu_preparation.sh
   :language: bash`

After the software installation, clone the git repo or download the role from `Ansible Roles`_ and install into ansible

``git clone https://github.com/f5devcentral/f5-tls-automation``

next change into the example ansible directory:

``cd f5-tls-automation/code/letsencrypt/example_ansible_env/``

now run the playbook from here.
