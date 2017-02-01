### ss-libev中manage API的流量统计原理解读

版本：2.6.3

发送"ping"到ss-manager API即可得到所有server的traffic

manager.c : line 736

```c
if (strcmp(action, "ping") == 0) {
	struct cork_hash_table_entry *entry;
	struct cork_hash_table_iterator server_iter;
  
	char buf[BUF_SIZE];
	memset(buf, 0, BUF_SIZE);
	sprintf(buf, "stat: {");
	
    cork_hash_table_iterator_init(server_table, &server_iter);

	while ((entry = cork_hash_table_iterator_next(&server_iter)) != NULL) {
		struct server *server = (struct server *)entry->value;
		size_t pos            = strlen(buf);
		if (pos > BUF_SIZE / 2) {
        	buf[pos - 1] = '}';
			if (sendto(manager->fd, buf, pos, 0, (struct sockaddr *)&claddr, len)
				!= pos) {
				ERROR("ping_sendto");
			}
			memset(buf, 0, BUF_SIZE);
		} else {
			sprintf(buf + pos, "\"%s\":%" PRIu64 ",", server->port, server->traffic);
		}
	}

	size_t pos = strlen(buf);
	if (pos > 7) {
		buf[pos - 1] = '}';
	} else {
		buf[pos] = '}';
		pos++;
	}

	if (sendto(manager->fd, buf, pos, 0, (struct sockaddr *)&claddr, len)
		!= pos) {
		ERROR("ping_sendto");
	}
}
```