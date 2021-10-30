# initial-setting-for-raspi
このリポジトリはubuntu PCの初期セットアップ時に楽にセットアップができるようにansibleを利用したものです。  
私の趣味がかなり入っていますが、startup.ymlのコメントの有無や、`roles`の中を変えていただくことで汎用的に使えるかと思います。

This repository uses ansible so that it can be set up easily during the initial setup of ubuntu PC.  
I have a lot of hobbies, but I think that it can be used for general purposes by changing the presence or absence of comments in startup.yml and the contents of `roles`.

## Usage

```sh
sudo apt install ansible
ansible-playbook startup.yml --ask-become-pass
```
