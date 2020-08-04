#include "/home/compx203/ex2/lib_ex2.h"

void count(int start,int end)
{
	int i;
	if(0 <= start < 10000 && 0 <= end < 10000)
	{
		if(start < end)
		{
			for(i = start;i <= end;i++)
			{
				writessd(i);
				delay();
			}
		}
		else
		{
			for(i = start;i >= end;i--)
			{
				writessd(i);
				delay();
			}
		}
	}
}
