/*  This file is part of The Firekylin Operating System.
 *
 *  Copyright 2016 Liuxiaofeng
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include <time.h>

struct tm *localtime(time_t * t)
{
	//time_t offset = *t; /* seconds between local time and GMT */

	//if (timezone == -1) tzset();
	// offset = *t - timezone;

	//if (stm == (struct tm *)NULL) return stm; /* check for illegal time */
	//stm->tm_isdst = (dst == -1) ? -1 : 0;
	return gmtime(t);;
}
