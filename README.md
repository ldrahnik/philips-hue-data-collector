# Philips Hue Data Collector

`~/.bashrc`
```
export PHILIPS_HUE_API_HOST="192.168.x.y"
export PHILIPS_HUE_API_USERNAME="olaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" # how to generate is described here https://github.com/ldrahnik/philips-hue-random-notes
```

```
$ cat philips_hue_data_collector.service | API_HOST=$PHILIPS_HUE_API_HOST API_USERNAME=$PHILIPS_HUE_API_USERNAME envsubst '$API_HOST $API_USERNAME' | sudo tee /usr/lib/systemd/user/philips_hue_data_collector@.service
$ sudo cp philips_hue_data_collector.timer /usr/lib/systemd/user/philips_hue_data_collector@.timer
$ systemctl --user daemon-reload
$ systemctl enable --user philips_hue_data_collector@$USER.service
$ systemctl enable --now --user philips_hue_data_collector@$USER.timer

$ sudo mkdir /var/log/philips-hue-data-collector
$ sudo chown -R $USER:$USER /var/log/philips-hue-data-collector
$ sudo chmod 755 /var/log/philips-hue-data-collector

$ sudo mkdir /usr/share/philips-hue-data-collector
$ sudo cp script.sh /usr/share/philips-hue-data-collector/script.sh
$ sudo chown -R $USER:$USER /usr/share/philips-hue-data-collector
$ sudo chmod +x /usr/share/philips-hue-data-collector/script.sh
```