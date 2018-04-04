# xxSysInfo

### Description ###
Bat file to collect software and hardware system information without admin permissions. Useful for information gathering and reconnaissance. Generates a file with size less than 1mb by using wmic and other core Windows utilities.

### Usage ###
Specify log file location with the -l parameter:
```cmd
xxSysInfo.bat -l D:\info.txt
``` 

or just use default one (%cd%\sysInfo.txt):

```cmd
xxSysInfo.bat
```