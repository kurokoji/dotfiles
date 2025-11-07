# kurokoji's dotfiles

# Usage

## Unix/Linux

``` sh
git clone https://github.com/kurokoji/dotfiles
cd dotfiles
./deploy.bash
./init.bash
```

### Memo

- gitのsecrets毎回入力するの面倒なので`libsecret` 使う

``` sh
sudo apt install libsecret-1-0 libsecret-1-dev libglib2.0-dev gnome-keyring build-essential
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
```

## Windows

```sh
git clone https://github.com/kurokoji/dotfiles
cd dotfiles
.\deploy.ps1
.\init.ps1
```

# License

MIT
