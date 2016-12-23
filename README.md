# IaC-mongodb
Run a highly scaleable production ready mongodb cluster on AWS with Sharding. Optimized for ap-northeast-1 region since they have 2 availability_zones ap-northeast-1a and ap-northeast-1c. Only has 2 categories for VPC primary and secondary

# OpenVPN
All mongodb servers are in private subnet and is not accesible by Public IP for security reasons
Therefore there is an openvpn server to add access to this private subnet

# Config Servers
Needs at least 3 config servers
xxx.xxx.xxx cfg01.kenichishibata.net
xxx.xxx.xxx cfg02.kenichishibata.net
xxx.xxx.xxx cfg03.kenichishibata.net
