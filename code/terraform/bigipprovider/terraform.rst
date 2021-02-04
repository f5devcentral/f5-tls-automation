BIG-IP - Terraform Provider
===========================

Overview
----------------------------------
This example uses Terraform to create a private key and a throwaway, self-signed SSL certificate. These resources are in the ``tls.tf`` file. This certificate is then loaded onto the BIG-IP and a clientSSL profile is created on the BIG-IP using this certificate. The resources using the BIG-IP provider are in the ``bigip_config.tf`` file.

How to use this example
----------------------------------

Prerequisites
^^^^^^^^^^^^^^
You will need a running BIG-IP, and you will need to know the admin username and password.

Instructions
^^^^^^^^^^^^^^
1. Change directory to this directory, ie, ``cd [directory_with_.tf_files]``
2. Run ``terraform init`` to download the required providers
3. Run ``terraform apply`` and you will be prompted for the username, password, and the mgmt IP address of the running BIG-IP that you are targeting. After entering these and typing ``yes`` at the prompt, Terraform will create a certificate, load that certificate into BIG-IP, and create an SSL profile.

Advanced
^^^^^^^^^^^^^^
After trying this example with a self-signed certificate, you should use your own SSL certificate, which you should store securely in a vault. The key can be provided to the BIG-IP provider `bigip_ssl_key <https://registry.terraform.io/providers/F5Networks/bigip/latest/docs/resources/bigip_ssl_key>`_ resource in PEM format.

Overview of files
^^^^^^^^^^^^^^^^^
Unless you want advanced configurations, these file does not need to be edited. The below serves for an explanation of the files only.

**variables.tf**
| This file defines the variables that you will be prompted for when you run the ``terraform apply`` command.

.. literalinclude :: variables.tf
   :language: hcl

**providers.tf**
| This file configures the BIG-IP provider based on the inputs to the prompts in your ``terraform apply`` command.

.. literalinclude :: providers.tf
   :language: hcl

**tls.tf**
| This file simply creates a temporary, throwaway SSL certificate for use in this demo.

.. literalinclude :: tls.tf
   :language: hcl

**bigip_config.tf**
| This file contains the resources that configure the BIG-IP, including the installation of the SSL certificate created, and the creation of the SSL profile.

.. literalinclude :: bigip_config.tf
   :language: hcl
