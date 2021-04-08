This directory is intended to be a single folder that has all the configuration, service, and yaml files required to run prometheus_install.sh

To run the file, clone the install folder then run sudo chmod +x prometheus_install.sh to grant execution privledges. Then simply run the
script as super user: sudo ./prometheus_install.sh

The default installation of grafana is insecure, and is only intended for testing purposes.

After step 6 in this guide was not implemented and thus it is insecure by default: https://devconnected.com/how-to-install-grafana-on-ubuntu-18-04/
