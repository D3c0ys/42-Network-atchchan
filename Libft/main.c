#include "libft.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define NL if(write(1,"\n",1)==-1){return -1;};
#define print(x,y) if(write(1,x,y)==-1){return -1;};

int	main(void)
{
	printf("%d\n", ft_isalnum('a')); // 1
	printf("%d\n", ft_isalnum('1')); // 1
	printf("%d\n", ft_isalnum('/')); // 0
	printf("%d\n", ft_isalnum('-')); // 0
	printf("%d\n", ft_isascii('-')); // 1
	printf("%d\n", ft_isascii(0xA)); // 1
	printf("%d\n", ft_isascii(128)); // 1
	// about string
	printf("%ld\n", ft_strlen("Hello World!")); // 12
	printf("%c\n", ft_toupper('f'));            // F
	printf("%c\n", ft_toupper('t'));            // T
	printf("%c\n", ft_tolower('F'));            // f
	printf("%c\n", ft_tolower('T'));            // t
	// ft_memset
	char	*p;
	int		p_size;
	p_size = 16;
	p = malloc(p_size);
	ft_memset(p, 'A', p_size);
	if (write(1, p, p_size) == -1)
	{
		return (1);
	};
	NL
	// ft_memcpy
	char 	*p2;
	p2 = malloc(p_size);
	ft_memcpy(p2, p, p_size);
	if (write(1, p2, p_size) == -1)
	{
		return (1);
	};
	NL
	free(p); free(p2);
	// ft_memmove
	char *p3;
	char *p4;
	p3 = malloc(16);
	p4 = &p3[3];
	ft_memset(p3, 'A', 16);
	ft_memset(p4, 'B', 8);
	print(p3,16) NL
	ft_memmove(p4,p3,4);
	print(p3,16) NL

	ft_memset(p3, 'A', 16);
	ft_memset(p4, 'B', 8);
	print(p3,16) NL
	ft_memcpy(p4,p3,4);
	print(p3,16) NL
	// bzero
	ft_bzero(p3,16);
	print(p3,16) NL
	
	char s[] = "1s2p3d4e5s6d7phehe";
	printf("%s\n", ft_strchr(s,'p'));
	printf("%s\n", ft_strrchr(s,'p'));

	char ss[] = "WHA\0AB";
	char sss[] = "WHA\0BA";
	printf("ft_strncmp: %d\n", ft_strncmp(ss,sss,7));
	printf("ft_memcmp: %d\n", ft_memcmp(ss,sss,7));
	
	unsigned char *b = ft_memchr(s,'p',ft_strlen(s));
	if(b != NULL){
		printf("%s\n", b);
	}else{
		printf("NULL");
	}

}
