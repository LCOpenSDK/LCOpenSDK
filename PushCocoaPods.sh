#添加库至本地
pod repo add CocoaPods https://github.com/CocoaPods/Specs.git 

PODSPEC_FILE=""
#从目录中查找podspec文件
#参数1：文件路径
function findSPodSpecFileInFolder() {
	for file in `find "$(pwd)"`
	do
		extension="${file##*.}"
		if [ "$extension" == "podspec" ] 
		then
        	PODSPEC_FILE=${file}
			echo "*** 找到 ${PODSPEC_FILE} *** "
		fi
	done
}

#检查podsepc文件
findSPodSpecFileInFolder

if [[ ! -f ${PODSPEC_FILE} ]]; then
	echo "***Error: podspec 文件不存在，请检查 ***"
	exit
fi

#提交podspec文件至远端仓库
echo "***开始Push到远端仓库 ***"
pod trunk push ${PODSPEC_FILE} --allow-warnings --skip-import-validation --verbose --use-libraries --sources=https://github.com/CocoaPods/Specs.git
echo "*** 结束 ***"