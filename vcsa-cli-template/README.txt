- Got the template from : https://polarclouds.co.uk/vcenter-without-dns-ntp/
- However modfied it while referring to sample template from the vcsa iso
  --> vcsa-cli-installer/templates/install/embedded_vCSA_on_ESXi.json
- libnsl problem also occurs for cli method --> had to run on a rocky 9.2 machine
  instead of the fedora server 39 server
---
from the vcsa-iso/
...
3. To perform a basic template verification without installing:
     lin64/vcsa-deploy install --accept-eula --verify-template-only <JSON file path>

4. To perform a installation pre-check without installing:
  lin64/vcsa-deploy install --accept-eula --precheck-only <JSON file path>

5. To perform the installation.
  lin64/vcsa-deploy install --accept-eula <JSON file path>

