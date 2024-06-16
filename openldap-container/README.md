## Setting up an openldap container to be used with vsphere home lab

- Using the instructions from the following git repo
    https://github.com/osixia/docker-openldap
- Container image: **docker.io/osixia/openldap:1.5.0**
- Default user/password: admin/admin
- The osixia git repo has ldapadd commands to add additional users
- Enviroment variables:
	--env LDAP_ORGANISATION="My Company" \
	--env LDAP_DOMAIN="my-company.com" \
	--env LDAP_ADMIN_PASSWORD="JonSn0w" 

```
podman  run -p 1389:389 -p 1636:636 --name my-openldap-container --detach osixia/openldap:1.5.0

# Query to test the ldap server
podman exec my-openldap-container ldapsearch -x \
-H ldap://localhost -b dc=example,dc=org \
-D "cn=admin,dc=example,dc=org" -w admin


firewall-cmd --add-port 1636/tcp --permanent
firewall-cmd --add-port 1389/tcp --permanent
firewall-cmd --reload

# Add billy (sample ldif is inside the container image)
podman exec my-openldap-container ldapadd -x -D "cn=admin,dc=example,dc=org" \
-w admin -f /container/service/slapd/assets/test/new-user.ldif \
-H ldap://localhost -ZZ

# Set billy's password, admin's password is 'admin'
podman exec my-openldap-container ldappasswd -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -W -S "uid=billy,dc=example,dc=org"
```


