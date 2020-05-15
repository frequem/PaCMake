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

FAILED=()
PASSED=()
for package in * ; do
	if ! [ -d "$package/example/" ] ; then #skip files
		continue
	fi
	pushd $package/example/
	for version in * ; do
		if ! [ -d "$version" ] ; then
			continue
		fi
		for type in "STATIC" "SHARED" ; do
			test_example $version/ $type
			if [ $? -ne 0 ]; then
				FAILED+=("$package($version, $type)")
			else
				PASSED+=("$package($version, $type)")
			fi
		done
	done
	popd
done

for i in "${PASSED[@]}" ; do
	echo -n "$i$(printf '\056%.0s' {1..48})" | head -c 48 ; echo -e "\e[32mPASSED\e[0m"
done
for i in "${FAILED[@]}" ; do
	echo -n "$i$(printf '\056%.0s' {1..48})" | head -c 48 ; echo -e "\e[31mFAILED\e[0m"
done

exit ${#FAILED[@]}
