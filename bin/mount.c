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

#include <sys/unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

int main(int argc, char **argv)
{
	if (argc != 4) {
		fprintf(stderr, "Usage:mount special target type");
		_exit(0);
	}
	if (mount(argv[1], argv[2], argv[3], 0) < 0) {
		fprintf(stderr, "%d:%s", errno, strerror(errno));
		_exit(0);
	}
	return 0;
}
