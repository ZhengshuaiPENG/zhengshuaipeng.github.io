---
layout: post
title:  "[Linux] Linux 中常用的压缩命令"
date:   2018-04-16
desc: "Common compress commands in Linux"
keywords: "Linux, shell, command, compress, decompress"
categories: [linux]
---

# I. tar

-   Compress: ```tar cvf FileName.tar DirName```
-   Decompress: ```tar xvf FileName.tar```

# II. gz

-   Compress:```gzip FileName```
-   Decompress:
    -   ```gunzip FileName.gz```
    -   ```gzip -d FileName.gz```

# III. tar.gz & .tgz

-   Compress: ```tar zcvf FileName.tar.gz DirName```
-   Decompress: ```tar zxvf FileName.tar.gz```

# IV. bz2

-   Compress: ```bzip2 -z FileName```
-   Decompress:
    -   ```bzip2 -d FileName.bz2```
    -   ```bunzip2 FileName.bz2```

# V. zip

-   Compress: ```zip FileName.zip DirName```
-   Decompress: ```unzip FileName.zip```

# VI. rar

-   Compress: ```rar a FileName.rar DirName```
-   Decompress: ```rar x FileName.rar```

# VII. rpm

-   Decompress: ```rpm2cpio FileName.rpm | cpio -div```

# VIII. deb

-   Decompress: ```ar p FileName.deb data.tar.gz | tar zxf -```
