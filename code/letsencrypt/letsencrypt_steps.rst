==============================================
BIG-IP - Letsencrypt with F5 Cloudservices DNS
==============================================

.. note:: Tested with Ansible 2.09

*******
Summary
*******

For those that are interested how the role works internally, here are the steps it does to accomplish the result.

******************
Steps of the Role:
******************

These are the steps executed to create the certificates. There is no user intervention required.

1. Checks if certificate already exists in certificate folder. If exists, skip subsequent certificate creation steps.

2. Creates a subdirectory on the ansible host to run and store certificates and keys

   - default directory is the ``{{playbook_dir}}/F5letsencrypt``
   - This directory can be changed via variable ``letsencrypt_dir``
   - creates following subdirectorys: **account**, **certs**, **csrs**, **keys**

3. Creates Letsencrypt Account-ID

   - variable ``new_le_account_key`` forces the role to create a new Account ID if desired. Usefull if Letsencrypt ratelimits the Account-ID.

4. Create TLS Certificate signing request

   - the csr is stored in the csrs subfolder

5. Send API call to Letsencrypt to initiate domain name ownership verification

   - this role uses DNS as verification method.
   - per default Letsencrypt staging envionment is used. This results in test certificates
   - variable ``acme_directory_target`` sends it to Letsencrypt production environment for public cert creation

6. Creates/modifys acme-challenge value into F5 Cloudservices primary DNS primary zone entry for existing zone record

   - uses an exisiting F5 Cloudservices account with subscription to primary DNS
   - the primary zone record for the domain name has to exist and be activated before the role is run
   - creates or modifies the **_acme-challenge** dns prefix entry for Letsencrypt validation

7. Sends API call to Letsencrypt to finish domain name ownership validation and download certificate and fullchain certificate

   - finishes letsencrypt verification and download certificate, CA certificate and fullchain certificate into the certs subfolder

8. Upload certificate and key into BIG-IP

   - skips this step if ``send_to_bigip`` does not have the value ``on``
   - BIG-IP login credentials with admin rights must be provided via provider vars in playbook or inventory

9. Create Client SSL profile in BIG-IP and use uploaded key, certificate and CA

   - installs key, cert and CA cert into BIG-IP and creates a new SSL profile with the cert/key/CAchain
