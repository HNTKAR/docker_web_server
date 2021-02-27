# mail server Container

## **設定ファイル**

```
###web###
ssl_domain:example.com
web_domain:example.com,example.org
db_password:email1:password1
```

## **コンテナの起動**
```shell
sudo firewall-cmd --add-forward-port=port=80:proto=tcp:toport=10080 --permanent
sudo firewall-cmd --add-forward-port=port=443:proto=tcp:toport=10443 --permanent
sudo firewall-cmd --reload
sudo mkdir -p -m 777 /home/podman/web_pod/www_conf /home/podman/web_pod/www_log /home/podman/web_pod/app_log /home/podman/web_pod/db_data /home/podman/web_pod/db_conf /home/podman/web_pod/db_log 
./script.sh
podman pod create --replace=true -p 10080:80 -p 10443:443 -n web_pod --net slirp4netns:port_handler=slirp4netns
podman run --replace=true -td --pod web_pod -v /home/podman/web_pod/www_conf:/conf -v /home/podman/web_pod/www_log:/log --name nginx nginx
podman run --replace=true -td --pod web_pod -v /home/podman/web_pod/www_conf:/nginx_conf -v /home/podman/web_pod/app_log:/log --name php-fpm php-fpm
podman run --replace=true -td --pod web_pod -v /home/podman/web_pod/db_data:/data -v /home/podman/web_pod/db_conf:/conf -v /home/podman/web_pod/db_log:/log --name mariadb mariadb
```
## **ファイルおよびフォルダ**
<!-->
postfix  
<details><summary>/home/podman/mail_pod/mta_spool/</summary><div>  

>  メールキュー ( default : /var/spool/postfix/ )  
>  未配送のメールがここに溜まる  

</div></details> 

<details><summary>/home/podman/mail_pod/mta_conf/main.cf</summary><div>  

>  postfix用基本設定ファイル ( default : /etc/postfix/main.cf )

</div></details> 
<details><summary>/home/podman/mail_pod/mta_conf/master.cf</summary><div>  

>  postfix用プロセス設定ファイル ( default : /etc/postfix/master.cf )

</div></details> 

<details><summary>/home/podman/mail_pod/mta_conf/aliases(.db)</summary><div>  

>  メールの転送設定ファイル ( default : /etc/aliases(.db) )
>  A@example.com に届いたメールを B@example.com と C@example.org に転送する場合は以下のように記載し再起動
> ```
> A@example.com: B@example.com, C@example.org
> ```
>  aliases.db は run-postfix.sh内の `postalias` コマンドによって生成される

</div></details> 

<details><summary>/home/podman/mail_pod/mta_conf/transport(.db)</summary><div>  

>  メールのリレー設定ファイル ( default : /etc/postfix/transport(.db) )
>  example.com 宛のメールを example.org にリレーする場合は以下のように記載し再起動
>  ```
>  example.com smtp:example.org
>  ```
>  transport.db は run-postfix.sh内の `postmap` コマンドによって生成される

</div></details> 

<details><summary>/home/podman/mail_pod/mta_conf/vmailbox(.db)</summary><div>  

>  メールの配送設定ファイル ( default : /etc/postfix/vmailbox(.db) )
>  A@example.com 宛のメールを cyrus-imapの A@example.com にリレーする場合は以下のように記載し再起動
>  ```
>  A@example.com A@example.com
>  ```
>  vmailbox.db は run-postfix.sh内の `postmap` コマンドによって生成される

</div></details> 

<details><summary>/home/podman/mail_pod/mta_conf/sasldb2</summary><div>  

>  ユーザー管理データベース ( default : /etc/sasldb2 )  

</div></details> 

<details><summary>/home/podman/file_pod/mta_log/</summary><div>

> 各種ログ ( default : /var/log/ )

</div></details>

cyrus-imapd  
<details><summary>/home/podman/mail_pod/imap_spool/</summary><div>  

>  メールデータ ( default : /var/spool/imap/ )  
>  メール本体のデータがここに溜まる  

</div></details> 
<details><summary>/home/podman/mail_pod/imap_data/</summary><div>  

>  メールデータベース ( default : /var/lib/imap/ )  
>  メール格納場所のデータベース  

</div></details> 

<details><summary>/home/podman/mail_pod/imap_conf/imapd.conf</summary><div>  

>  cyrus-imapd用基本設定ファイル ( default : /etc/imapd.conf )

</div></details> 
<details><summary>/home/podman/mail_pod/mail_conf/cyrus.conf</summary><div>  

>  cyrus-imapd用プロセス設定ファイル ( default : /etc/postfix/cyrus.cf )

</div></details> 

<details><summary>/home/podman/mail_pod/imap_conf/sasldb2</summary><div>  

>  ユーザー管理データベース ( default : /etc/sasldb2 )  

</div></details> 

<details><summary>/home/podman/mail_pod/imap_log/</summary><div>

> 各種ログ ( default : /var/log/ )

</div></details>  

<br>

### 手動で新規ユーザーを追加する場合はコンテナ内で以下のコマンドを使用する  

> cyrus-master  
> ```
> saslpasswd2 -c -f /conf/sasldb2 -u USER_DOMAIN USER_NAME'
> ```
> postfix-master  
> ```
> saslpasswd2 -c -f /conf/sasldb2 -u USER_DOMAIN USER_NAME'
> echo "USERNAME@USER_DOMAIN USERNAME@USER_DOMAIN">> /conf/vmailbox
> postmap /conf/vmailbox
> ```  
> postfix-replica
> ```
> echo "USER_DOMAIN smtp:USER_DOMAIN">> /conf/transport
> postmap /conf/transport
> ```
<!-->

### 自動起動の設定
> ```
> mkdir -p $HOME/.config/systemd/user/
> podman generate systemd -f -n --new --restart-policy=always web_pod >tmp.service
> systemctl --user start pod-web_pod
> cat tmp.service | \
> xargs -I {} \cp {} -frp $HOME/.config/systemd/user
> cat tmp.service | \
> xargs -I {} systemctl --user enable {}
> ```

### 自動起動解除
> ```
> cat tmp.service | \
> xargs -I {} systemctl --user disable {}
> ```