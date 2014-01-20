name             'pipeline'
maintainer       "Stephen Lauck"
maintainer_email "lauck@opscode.com"
license          'All rights reserved'
description      'Installs/Configures pipeline'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.12'

depends 'yum', '= 2.4.4'
depends 'runit', '= 1.4.0'
depends 'nginx', '= 2.0.8'

depends 'apt'
depends 'build-essential'
depends "git", '= 2.8.4'
depends "jenkins", '= 1.2.2'
depends 'sudo'
