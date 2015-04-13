name 'python-webapp-test'
maintainer 'Oregon State University'
maintainer_email 'chef@osuosl.org'
license 'Apache 2.0'
description 'Used to test the python-webapp cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

depends 'python-webapp'
depends 'yum'
depends 'yum-epel'
depends 'yum-ius'
depends 'yum-osuosl'
