
- Email notifier should support non-smtp delivery

- Refactor notifiers API

- Fix logger to use NFS compliant file locking strategy (not flock)

- Improve logger -- notifier API (avoid copying log to memory)

- Implement cron job wrapper binary:  
  e.g. cronwrap "/root/ssbackup" --name="Nightly MySQL Backup" --log-file=/var/log/cronjob.log --mailto=$MAILTO
  
- Add tests
