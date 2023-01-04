# FFmpegInstaller
Easily download and install the lastest version of FFmpeg on Windows with this PowerShell script.

Stop with manually changing Path just to use FFmpeg from your terminal!

# Having issues with running the script?

When trying to run the script, you may get an error like this:

```powershell
.\installFFmpeg.ps1 : File C:\..........\FFmpegInstaller\installFFmpeg.ps1 cannot be loaded because running scripts is disabled on this system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/LinkID=135170.
At line:1 char:1
+ .\installFFmpeg.ps1
+ ~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```

This is because of [Microsoft's security policy](https://go.microsoft.com/fwlink/?LinkID=135170). To fix this, open PowerShell as an administrator and run the following command:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then try running the script again.

> **Warning**:
> You are heavily advised to disable this policy after you are done! Run the same command but change `RemoteSigned` to `Restricted`.

Any questions? Feel free to open an Issue here on GitHub or even better, open a Pull Request if you have anything to add!
