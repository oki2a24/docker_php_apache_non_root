## 開発用の自己署名サーバSSL証明書
このディレクトリのサーバ証明書と秘密鍵は、次のコマンドで生成しました。

```bash
openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
-keyout private_key.pem \
-out certificate.pem \
-config - <<EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = usr_cert
prompt = no

[req_distinguished_name]
C = JP
O = oki2a24.com
OU = MyDivision
CN = localhost

[usr_cert]
basicConstraints = critical, CA:FALSE
subjectAltName = DNS:localhost
EOF
```
