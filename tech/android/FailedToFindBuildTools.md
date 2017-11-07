ERROR: Failed to find Build Tools revision 23.0.1

Go to /home/**[USER]**/Android/Sdk/tools and execute:

```Sh
$ android list sdk -a
```

Will see

1. Android SDK Tools, revision 24.0.2
2. Android SDK Platform-tools, revision 23.0.2
3. **Android SDK Platform-tools, revision 23.0.1**

```Sh
$ android update sdk -a -u -t 3
```



### Refference

[1] https://stackoverflow.com/questions/36683726/failed-to-find-build-tools-revision-23-0-1

