/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memmove.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: atchchan <atchchan@student.42bangkok.com>  +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/26 18:04:27 by atchchan          #+#    #+#             */
/*   Updated: 2026/08/26 18:46:56 by atchchan         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memmove(void *dest, const void *src, size_t n)
{
	const unsigned char	*p1;
	unsigned char		*p2;
	size_t				i;

	p1 = (unsigned char *)src;
	p2 = (unsigned char *)dest;
	if (p1 > p2)
	{
		i = 0;
		while (i < n)
		{
			p2[i] = p1[i];
			i++;
		}
	}
	if (p1 < p2)
	{
		i = n - 1;
		while (i < n)
		{
			p2[i] = p1[i];
			i--;
		}
	}
	return (dest);
}
