---
layout: post
title:  "[iTerm2] Add Server Profiles in iTerm2 for SSH"
date:   2018-06-12
desc: "how to add server profiles in iTerm2 on Mac OS"
keywords: "mac, iTerm2, profile"
categories: [mac]
---

# I. Install iTerm2 on Mac OS

iTerm2 is a powerful terminal emulator on Mac OS.
Install it via ```homebrew```:

```
brew cask install iterm2
```

After install iTerm2, I would recommand to use [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) to replace bash

# II. Add Server Profile

Generally, we connect to a remote server via ```SSH```. If you have many servers to connect, it's better to configure some server profiles to manage them in iTerm2.

## 1. Write a profile file on local disk

-   Create a file on disk, for example, in the folder ```~/Workspace```

```
touch ~/Workspace/remote_server_1
```

-   Then edit this file, need password each time when connect to the server

```
#!/usr/bin/expect -f

set user userName
set host remote_host_or_ip
set timeout -1

spawn ssh $user@$host
interact
expect eof
```

- Or set the password as well


```
#!/usr/bin/expect -f

set user userName
set host remote_host_or_ip
set password passWord
set timeout -1

spawn ssh $user@$host
expect {  
        "(yes/no)?"  
        {send "yes\n";exp_continue}  
        "password:"  
        {send "$password\n"}  
}  
interact
expect eof
```
- Give execution privilege to profile

```
chmod +x ~/Workspace/remote_server_1
```

## 2. Add profile to iTerm2

Open iTerm2, choose ```Profiles``` in taskbar, then click ```Open Profiles```, it will show a Profiles window, then click ```Edit Profiles```

click ```+``` button is the left-bottom corner:

- Edit ```Name``` in Basics to set Profile name, for example ```server_1```
- Edit ```Tags``` in Basics to set tag of this profile, for example ```remote_cluster```
- Edit ```Command``` in Command: ```expect ~/Workspace/remote_server_1```

# III. Use profile to open a SSH session

After configured as above, open iTerm2, click ```Profiles``` in the task bar, you will see there is ```remote_cluster```, and there is ```server_1``` inside it. iTerm2 will open a SSH session when you click it.

