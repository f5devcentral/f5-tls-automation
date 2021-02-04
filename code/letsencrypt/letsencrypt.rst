================================================
BIG-IP - Let's Encrypt with F5 Cloudservices DNS
================================================

.. note:: Tested with Ansible 2.09

*******
Summary
*******

This ansible role provides following functionality:

1. create TLS certificate and key using Let's Encrypt as CA
2. uses F5 Cloudservices primary DNS offering as validation for domain ownership
3. uploads generated certificate and key to a BIG-IP and creates a SSL Client profile with it.

The rolename is: **f5cs_dns_letsencrypt_bigip**

The role can be downloaded from the roles folder here: `Ansible Roles`_.

********************************
Variables required for the role:
********************************

+------------------------+--------------------+-------------------------------------------+
| vars                   | default values     | description                               |
+========================+====================+===========================================+
| f5cs_username:         |                    | Username for F5 Cloudservices account     |
+------------------------+--------------------+-------------------------------------------+
| f5cs_password:         |                    | Password for F5 Cloudservices account     |
+------------------------+--------------------+-------------------------------------------+
| domain_name:           |                    | Domain name for TLS certificate           |
+------------------------+--------------------+-------------------------------------------+
| acme_directory_target: | ``staging``        | ``prod`` creates public certificates      |
|                        |                    |                                           |
|                        |                    | ``staging`` creates test certificates     |
+------------------------+--------------------+-------------------------------------------+

Optional variables
==================

+------------------------+-----------------------------------+----------------------------------------------+
| vars                   | default values                    | description                                  |
+========================+===================================+==============================================+
| acme_email:            | ``myemail@mydomain.com``          | e-mail address for TSL certificate           |
+------------------------+-----------------------------------+----------------------------------------------+
| letsencrypt_dir:       | ``{{playbook_dir}}/F5letsencrypt``| directory for Let's Encrypt files            |
+------------------------+-----------------------------------+----------------------------------------------+
| new_le_account_key:    | ``false``                         | ``true`` or ``false``                        |
|                        |                                   | forces role to generate a new                |
|                        |                                   | Let's Encrypt account ID                     |
+------------------------+-----------------------------------+----------------------------------------------+
| send_to_bigip:         |  ``on``                           | ``on`` send cert/key to BIG-IP               |
|                        |                                   |                                              |
|                        |                                   | ``off`` to not send certs to BIG-IP          |
+------------------------+-----------------------------------+----------------------------------------------+




*****************
Example playbooks
*****************

Following are some examples how to build the playbook.

Use case 1: Upload into single BIG-IP
=====================================

This example playbook uploads the certificate and key into a single BIG-IP.
This playbook assumes the roles folder location is in the playbook folder.
Please adjust to ansible host environment.

.. literalinclude :: example_playbook.yml
   :language: yaml

BIG-IP admins can perform a config sync between BIG-IP devices to sync the new cert/key and Client SSL profile.

Use case 2: Upload into multiple BIG-IP
=======================================

It is possible to upload the cert/key pair to multiple BIG-IP instances as well.

The login credentials for multiple BIG-IPs are stored in the ``host_vars/`` folder.
Each BIG-IP has an individual file with its own provider variables.

Therefore there are no provider variables in the playbook.

To upload the key to multiple BIG-IP instances perform followong steps:

1. Change the playbook ``hosts: localhost`` value to a var group e.g.  ``hosts: bigip_group``

.. literalinclude :: example_playbook_multiple_bigip.yml
   :language: yaml

2. Create a var group with the same name in the hosts file

.. literalinclude :: hosts_multiple
   :language: yaml`

3. Create a host_vars folder and add var files for each BIG-IP in the bigip_group.
Use following content for each file and adjust the var values accordingly

.. literalinclude :: example_bigip
   :language: yaml`

********************
Example Run command:
********************

Here some examples, how to run the role.
The login parameters for F5 Cloudservices can be:

a. handed over as variables during the call and/or
b. can be part of the playbook as shown in the playbook examples.

Use case 3: Let's Encrypt staging
=================================

Example run command for Let's Encrypt staging API environment.
Let's Encrypt staging environment **does not** create valid TLS certificates. It can be used for testing and verification.

This is the default setting of the role. This is done to prevent the user to use all

``ansible-playbook example_playbook.yml  -e "domain_name=<www.mydomain.com>"``

Use case 4: Let's Encrypt production
====================================

Example run command for Let's Encrypt production API environment. This command creates public TLS certificates:

``ansible-playbook example_playbook.yml  -e "domain_name=<www.mydomain.com>" -e "acme_email=certadmin@mydomain.com" -e "acme_directory_target=prod"``

Use case 5: use role without uploading to BIG-IP
================================================

If it is not desired to upload the cert/key into BIG-IP, use the ``send_to_bigip=off`` flag

``ansible-playbook example_playbook.yml  -e "domain_name=<www.mydomain.com>" -e "acme_email=certadmin@mydomain.com" -e "acme_directory_target=prod" -e "send_to_bigip=off"``

This will create the folder structure. Per default a ``F5letsencrypt`` folder is created under the playbook directory. Subfolders for **keys** , **certs** and **csrs** are created.

Use case 6: change folder for Let's Encrypt certificate/keys
============================================================

To change the location of the Let's Encrypt folder structure, use the ``letsencrypt_dir`` variable.

``ansible-playbook example_playbook.yml  -e "domain_name=<www.mydomain.com>" -e "acme_email=certadmin@mydomain.com"  -e "letsencrypt_dir=/var/temp/letsencrypt"``

Use case 7: working around Let's Encrypt rate limiting
======================================================

Let's Encrypt limits the number of requests a single account key can send in a given time interval. I found it usefull to have a limited workaround to extend the rate limit during tests and development.
One limiting factor is the account key. With following variable, the role will generate a new Account key and allow more testing, before IP rate limiting of Let's Encrpt kick in:

``ansible-playbook example_playbook.yml  -e "domain_name=<www.mydomain.com>" -e "acme_email=certadmin@mydomain.com" -e "acme_directory_target=prod" -e "new_le_account_key=true"``

.. warning:: This role will create a folder structure to store Let's Encrypt account key, certificate, key, CA certificate and csr.

****************************
Example Ansible environment:
****************************

An example ansible environment can be found here: `Ansible Environment`_

*************
Prerequisites
*************

Following Prerequisites are needed

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

***********************
How it internally works
***********************

These are the steps executed to create the certificates. There is no user intervention required.

1. Checks if certificate already exists in certificate folder. If exists, skip subsequent certificate creation steps.

2. Creates a subdirectory on the ansible host to run and store certificates and keys

   - default directory is the ``{{playbook_dir}}/F5letsencrypt``
   - This directory can be changed via variable ``letsencrypt_dir``
   - creates following subdirectorys: **account**, **certs**, **csrs**, **keys**

3. Creates Let's Encrypt Account-ID

   - variable ``new_le_account_key`` forces the role to create a new Account ID if desired. Usefull if Let's Encrypt ratelimits the Account-ID.

4. Create TLS Certificate signing request

   - the csr is stored in the csrs subfolder

5. Send API call to Let's Encrypt to initiate domain name ownership verification

   - this role uses DNS as verification method.
   - per default Let's Encrypt staging envionment is used. This results in test certificates
   - variable ``acme_directory_target`` sends it to Let's Encrypt production environment for public cert creation

6. Creates/modifys acme-challenge value into F5 Cloudservices primary DNS primary zone entry for existing zone record

   - uses an exisiting F5 Cloudservices account with subscription to primary DNS
   - the primary zone record for the domain name has to exist and be activated before the role is run
   - creates or modifies the **_acme-challenge** dns prefix entry for Let's Encrypt validation

7. Sends API call to Let's Encrypt to finish domain name ownership validation and download certificate and fullchain certificate

   - finishes Let's Encrypt verification and download certificate, CA certificate and fullchain certificate into the certs subfolder

8. Upload certificate and key into BIG-IP

   - skips this step if ``send_to_bigip`` does not have the value ``on``
   - BIG-IP login credentials with admin rights must be provided via provider vars in playbook or inventory

9. Create Client SSL profile in BIG-IP and use uploaded key, certificate and CA

   - installs key, cert and CA cert into BIG-IP and creates a new SSL profile with the cert/key/CAchain


.. _`Ansible Roles`: https://github.com/f5devcentral/f5-tls-automation/tree/master/code/letsencrypt/roles

.. _`Ansible Environment`: https://github.com/f5devcentral/f5-tls-automation/tree/master/code/letsencrypt/example_ansible_env
