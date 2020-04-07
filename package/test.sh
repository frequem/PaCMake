#!/bin/bash
#test all packages

test_example(){
	SOURCEDIR=$(readlink -f $1) #get absolute path
	LIBTYPE=$2 # STATIC or SHARED
	
	tmpdir=$(mktemp -d)
	pushd $tmpdir > /dev/null
	
	if [[ "$LIBTYPE" = "STATIC" ]]; then
		cmake $SOURCEDIR -DPACMAKE_DEFAULT_SHARED=OFF
		RESULT=$?
	elif [[ "$LIBTYPE" == "SHARED" ]]; then
		cmake $SOURCEDIR -DPACMAKE_DEFAULT_SHARED=ON
		RESULT=$?
	fi
	
	if [ $RESULT -eq 0 ]; then
		cmake --build .
		RESULT=$?
	fi
	
	popd > /dev/null
	rm -r $tmpdir
	
	return $RESULT
}


for packagedir in */ ; do
	if [ -d "${packagedir}example/" ] 
	then
		for versiondir in ${packagedir}example/*/ ; do
			
			test_example $versiondir STATIC
			if [ ! $? -eq 0 ]; then
				echo "STATIC build failed"
				exit 1
			fi
			
			test_example $versiondir SHARED
			if [ ! $? -eq 0 ]; then
				echo "SHARED build failed"
				exit 1
			fi
		done
	fi
done

echo "All good."
exit 0
