Role Name
=========
f5cs_dns_letsencrypt_bigip

This role helps to automate the process of creation of TLS certificates and keys with Letsencrypt, using F5 Cloudservices primary DNS for domain verification.
It installs the created certificates and keys into a BIG-IP and creates a Client SSL profile.

Requirements
------------

The ansible hosts requires following packages:
* jmespath

The role aslo requires to have a valid account for F5 Cloud services with a subscription for primary DNS.
The zone file for the domain record has to exist. (e.g. www.test.com as zone record has to exist). the dns prefix for acme-challenge will be created/modified by the role.

Role Variables
--------------

username for F5 Cloudservices acount
```
f5cs_username: ""
```
password for F5 Cloud Services account
```
f5cs_password: ""
```
acme challenge value. Will be dynamically populated.
```
acme_challenge: ""
```

Fixed variable structure. Is used during run time. do not change
```
acme:
      _acme-challenge: [{
        ttl: 15,
        type: "TXT",
        values: ["{{acme_challenge}}" ]
      }
      ]
```
Acme-challenge type. currently ony DNS is supported
```
acme_challenge_type: dns-01
```
API entrypoints for Letsencrypt. Per default the role uses staging.  to use the production entypoint use : **-e "acme_directory_target=prod"**
```
acme_directory_prod: https://acme-v02.api.letsencrypt.org/directory
acme_directory_staging: https://acme-staging-v02.api.letsencrypt.org/directory
acme_directory_target: "staging"
```

supported acme version
```
acme_version: 2
```
TLS certificate email
```
acme_email: "myemail@mydomain.com"
```

path for letsencrypt folder structure and subfolders
```
letsencrypt_dir: '{{ playbook_dir}}/F5letsencrypt'
letsencrypt_keys_dir: '{{ letsencrypt_dir}}/keys'
letsencrypt_csrs_dir: '{{ letsencrypt_dir}}/csrs'
letsencrypt_certs_dir: '{{ letsencrypt_dir}}/certs'
```
Letsencrypt account key location
```
letsencrypt_account_key: '{{ letsencrypt_dir}}/account/account.key'
```
sometimes letsencrypt throttles the account key to create new certificates. Use **-e "new_le_account_key=true" to force the rule to create a new key. This will address the account key limitation from Letsencrypt
```
new_le_account_key: false
```
Name of the certificate domain
```
domain_name: ""
```

provider variables for BIG-IP. Set these variables in the playbook or in host_vars for the BIG-IP
This example is from the playbook
```
  vars:
    provider:
      server: 'bigip-IP or bigip hostname'
      user: 'admin'
      password: 'bigip_admin_password'
      validate_certs: no
      server_port: 443
    partition: 'Common'
    state: 'present'
```
Switch to send to BIG-IP or not. In case this is not set to "on" then the role will create the certificate and
```
send_to_bigip: "on"
```

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
