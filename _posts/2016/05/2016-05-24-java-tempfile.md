---
layout: post
title:  "[JAVA] How to get the temporary file and file path in Java"
date:   2016-05-24
desc: "how to create the temporary file in Java and get the path of tmp file"
keywords: "java, temporary file, file path"
categories: [java]
---

# How to get the temporary file and file path in Java

## I. Create the temporary file in Java

Sometimes, we need to generate the temporary files in Java Program. For example, if you process a XML file, maybe you need to genrate some files in order to use these these files in the later process. You can fix the file path when you write the code, but when you want to release the product to the users, the file path may not exist. Even if the path exists, this mechanism is not clean and elegant. Also one more problem is that the path representation in Linux/Mac OS/Windows is not the same. So a better way is to use the temporary file.

To create the temporary file, we need to use the ```java.io.File```

```java
public void createTmpFiles(){

	// create a tmp file
	// you could modify the arguments here to adapt your requirements
	File tmp = File.createTempFile("tmpFileName", ".tmp");

	// get the path
	String tmpFilePath = tmp.getAbsolutePath();
}
```

Here, you may also set the tmp file path as the return value.

## II. Temporary file directory

### Linux

In Linux OS, if you are not set the tmp environment in your ```.bashrc``` file, the default temporary folder is ```/tmp```, the tmp file will be generated in ```/tmp```.  Generally linux has a mechanism to control the tmp file. Now, most of Linux distros use systemd service, so the ```/tmp``` file is handled by ```systemd timer service```, you don't need to care about this.

### Windows

In Windows, the tmp folder is located at ```C:\Users\user\APPData\Local\Temp\```; It's better to delete the files at the end of program. What you can do is, once you created a tmp file, you add them into a list, in the end of process, delete them as follow:

```java
private void deleteAllTempFiles() {
		for (File file : tempFileList) {
			file.delete();
		}
}
```
