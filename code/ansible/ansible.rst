BIG-IP - Ansible Modules
========================

.. note:: Tested with Ansible 2.10

This task is designed to pull Certificates/Keys from a URL endpoint and publish them into a BIG-IP. URL endpoint examples are remarkable for their reusability. Most TLS management or secrets solutions will also provide an API endpoint, which this module can consume.

.. note:: If you do not want to pull the Certificates/Keys from a URL, you can remove that part of the task and have them local to the playbook.

Steps of the task:

- Pull Certificates/Key from URL to local path
- Upload Certificates/Key to BIG-IP
- Create SSL Profile on BIG-IP
- Delete Certificates/Key from the local path

.. warning:: This task will delete files, its designed this way, so Certificates/Keys are not left residually

Clone the repository to have the examples local, or copy the example code below. Task modification should not be necessary. However, you need to update the variables to your environment.

+------------------------+----------------------------------------------------------------+
| vars                   | Variables Needed for Task                                      |
+========================+================================================================+
| bigips:                | Array of BIG-IP Targets (IP or FQDN)                           |
+------------------------+----------------------------------------------------------------+
| provider:              | BIG-IP information                                             |
+------------------------+----------------------------------------------------------------+
| server:                | References ``bigips`` leave as default value ``'{{ item }}'``  |
+------------------------+----------------------------------------------------------------+
| user:                  | BIG-IP Username                                                |
+------------------------+----------------------------------------------------------------+
| password:              | BIG-IP Password                                                |
+------------------------+----------------------------------------------------------------+
| validate_certs:        | Validate BIG-IP Management Certificate                         |
+------------------------+----------------------------------------------------------------+
| server_port:           | BIG-IP Connectivity Port                                       |
+------------------------+----------------------------------------------------------------+
| partition:             | BIG-IP Partition for Objects                                   |
+------------------------+----------------------------------------------------------------+
| domain_name:           | FQDN of Certificate Object                                     |
+------------------------+----------------------------------------------------------------+
| state:                 | Object state ``present`` is create ``absent`` is delete        |
+------------------------+----------------------------------------------------------------+
| certurl:               | URL for Certificate                                            |
+------------------------+----------------------------------------------------------------+
| cachainurl:            | URL for Key                                                    |
+------------------------+----------------------------------------------------------------+
| keyurl:                | URL for CA Chain                                               |
+------------------------+----------------------------------------------------------------+
| keypassphrase:         | Key Passphrase ``this variable is optional``                   |
+------------------------+----------------------------------------------------------------+

Run: **ansible-playbook main.yml**

Task:

.. literalinclude :: main.yml
   :language: yaml
