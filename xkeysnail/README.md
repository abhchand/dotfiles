# Overview

Implements GNOME key bindings with [`xkeysnail`](https://github.com/mooz/xkeysnail).

Also uses config files and service files generated by [kinto.sh](https://github.com/rbreaves/kinto), although the project isn't used directly.

# Usage

Ensure `xkeysnail` is installed.

```bash
sudo ln -s /home/abhishek/git/abhishek/dotfiles/xkeysnail/xkeysnail.service /lib/systemd/system/xkeysnail.service

systemctl start xkeysnail
```

Any changes to `config.py` require `xkeysnail` to be restarted

```bash
systemctl restart xkeysnail
```
