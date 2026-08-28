NAME = libft.a
CC = cc
CFLAGS = -Wall -Wextra -Werror 
AR = ar rcs 
RM = rm -f

SRCS = ft_isalpha.c ft_isdigit.c

OBJS = $(SRCS:.c=.o)

all: $(NAME)

$(NAME): $(SRCS) $(OBJS)

%.o: %.c libft.h
	$(CC) $(CFLAGS) -c $< -o $@

clean: 
	$(RM) $(OBJS)

fclean: clean 
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re
