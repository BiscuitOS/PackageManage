#!/bin/bash

set -e
set -x

VER=(
"linux_0_11" 
"linux_0_12" 
"linux_0_95_3" 
"linux_0_95a" 
"linux_0_96_1" 
"linux_0_97_1" 
"linux_0_98_1" 
"linux_0_99_1" 
"linux_1_0_1" 
"linux_1_0_1_1_ext2" 
"linux_1_0_1_1_minix" 
);

Install_Prepare()
{
	sudo apt-get update
	sudo apt-get install qemu gcc make gdb git figlet
	sudo apt-get install libncurses5-dev
	sudo apt-get install lib32z1 lib32z1-dev

	git clone https://github.com/BuddyZhang1/BiscuitOS.git
}

Test_OS()
{
	cd BiscuitOS
	ROOT=`pwd`
	KER=${ROOT}/kernel

	j=0
	for ver in ${VER[@]};
	do
	  make ${ver}_defconfig
	  make clean
	  make 

	  if [ $j -lt 9 ]; then
	    RES=${ver#*linux_}
	    cd ${KER}/linux_${RES//_/.}
          else
            cd ${KER}/linux_1.0.1.1
          fi

	  make start
	  cd -
          j=`expr $j + 1`
	done
}

Install_Prepare
Test_OS
