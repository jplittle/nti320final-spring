#!/bin/bash

yum -y install rpm-build make gcc git                                         # install rpm tools, compiling tools and source tools

mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}                      # create the rpmbuild dirrectory structure
 
                                                                              
cd ~/
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros                         # Set the rpmbuild path in an .rpmmacros file

cd ~/rpmbuild/SOURCES

git clone https://github.com/nic-instruction/NTI-320.git

cd NTI-320/
cp NTI-320/rpm-info/hello_world_from_source/helloworld-0.1.tar.gz .
cp NTI-320/rpm-info/hello_world_from_source/helloworld.sh .
cp NTI-320/rpm-info/hello_world_from_source/hello.spec .
mv hello.spec ../SPECS

cd ..

rpmbuild -v -bb --clean SPECS/hello.spec

##did it work?
#ls -l RPMS/x86_64/helloworld-0.1-1.el7.x86_64.rpm

yum -y install RPMS/x86_64/helloworld-0.1-1.el7.x86_64.rpm

##did it work?
#ls -l /