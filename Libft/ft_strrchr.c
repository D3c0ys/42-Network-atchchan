/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strrchar.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: atchchan <atchchan@student.42bangkok.com>  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/28 12:55:06 by atchchan          #+#    #+#             */
/*   Updated: 2026/08/28 13:36:47 by atchchan         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strrchr(const char *s, int c)
{
	const char	*p;
	const char	*p_it;

	p_it = s;
	p = p_it;
	while (*p_it)
	{
		if (*p_it == (char)c)
		{
			p = (char *)p_it;
		}
		p_it++;
	}
	if ((char)c == '\0')
	{
		p = (char *)p_it;
	}
	return ((char *)p);
}
