#!/bin/bash
#test all packages

test_example(){
	SOURCEDIR=$(readlink -f $1) #get absolute path
	LIBTYPE=$2 # STATIC or SHARED
	
	tmpdir=$(mktemp -d)
	pushd $tmpdir
	
	if [[ "$LIBTYPE" = "SHARED" ]]; then
		SHARED=ON
	else #default to static build
		SHARED=OFF
	fi
	
	cmake $SOURCEDIR -DPACMAKE_DEFAULT_SHARED=$SHARED
	RESULT=$?
	
	if [ $RESULT -eq 0 ]; then
		cmake --build .
		RESULT=$?
	fi
	
	popd
	rm -r $tmpdir
	
	return $RESULT
}


for exampledir in */example/*/ ; do
	test_example $exampledir STATIC
	if [ $? -ne 0 ]; then
		echo "STATIC build failed"
		exit 1
	fi
	
	test_example $exampledir SHARED
	if [ $? -ne 0 ]; then
		echo "SHARED build failed"
		exit 1
	fi
done

echo "All good."
exit 0
