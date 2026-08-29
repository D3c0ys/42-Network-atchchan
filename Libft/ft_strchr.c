/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strchr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: atchchan <atchchan@student.42bangkok.com>  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/27 20:19:52 by atchchan          #+#    #+#             */
/*   Updated: 2026/08/28 13:43:49 by atchchan         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strchr(const char *s, int c)
{
	const char	*p;

	p = s;
	while (*p)
	{
		if (*p == (char)c)
		{
			return ((char *)p);
		}
		p++;
	}
	if ((char)c == '\0')
	{
		return ((char *)p);
	}
	return (NULL);
}
