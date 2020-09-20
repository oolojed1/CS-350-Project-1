
_shutdown2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    Failure to follow this instruction will lead to zero point 
	for this part */

int 
main(int argc, char * argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
	char msg[128] = {0};
   7:	31 c0                	xor    %eax,%eax
{
   9:	ff 71 fc             	pushl  -0x4(%ecx)
   c:	55                   	push   %ebp
   d:	89 e5                	mov    %esp,%ebp
   f:	57                   	push   %edi
  10:	56                   	push   %esi
	char msg[128] = {0};
  11:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
{
  17:	53                   	push   %ebx
  18:	51                   	push   %ecx
  19:	81 ec 98 00 00 00    	sub    $0x98,%esp
  1f:	8b 11                	mov    (%ecx),%edx
  21:	8b 59 04             	mov    0x4(%ecx),%ebx
	char msg[128] = {0};
  24:	b9 20 00 00 00       	mov    $0x20,%ecx
  29:	f3 ab                	rep stos %eax,%es:(%edi)
{
  2b:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
	char * p = msg;
	int i = 0;
	 
    for (i = 1; i < argc; i++) 
  31:	83 fa 01             	cmp    $0x1,%edx
  34:	7e 5f                	jle    95 <main+0x95>
  36:	be 01 00 00 00       	mov    $0x1,%esi
	char * p = msg;
  3b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  41:	eb 14                	jmp    57 <main+0x57>
  43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  47:	90                   	nop
			p = msg + sizeof(msg);
			break;
		}
		else
		{
			*(p - 1) = ' ';
  48:	c6 47 ff 20          	movb   $0x20,-0x1(%edi)
    for (i = 1; i < argc; i++) 
  4c:	83 c6 01             	add    $0x1,%esi
  4f:	39 b5 64 ff ff ff    	cmp    %esi,-0x9c(%ebp)
  55:	74 26                	je     7d <main+0x7d>
	    strcpy(p, argv[i]);
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  5d:	57                   	push   %edi
  5e:	e8 3d 00 00 00       	call   a0 <strcpy>
		p += strlen(argv[i]) + 1;
  63:	58                   	pop    %eax
  64:	ff 34 b3             	pushl  (%ebx,%esi,4)
  67:	e8 b4 00 00 00       	call   120 <strlen>
		if (p >= msg + sizeof(msg))
  6c:	83 c4 10             	add    $0x10,%esp
		p += strlen(argv[i]) + 1;
  6f:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
		if (p >= msg + sizeof(msg))
  73:	8d 45 e8             	lea    -0x18(%ebp),%eax
  76:	39 c7                	cmp    %eax,%edi
  78:	72 ce                	jb     48 <main+0x48>
			p = msg + sizeof(msg);
  7a:	8d 7d e8             	lea    -0x18(%ebp),%edi
	}
	
	*(p - 1) = 0;
	
	// "msg" now holds the shutdown message provided by the user
    shutdown2(msg);
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
	*(p - 1) = 0;
  86:	c6 47 ff 00          	movb   $0x0,-0x1(%edi)
    shutdown2(msg);
  8a:	50                   	push   %eax
  8b:	e8 09 03 00 00       	call   399 <shutdown2>
	
    exit(); //return 0;
  90:	e8 5c 02 00 00       	call   2f1 <exit>
	char * p = msg;
  95:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  9b:	eb e0                	jmp    7d <main+0x7d>
  9d:	66 90                	xchg   %ax,%ax
  9f:	90                   	nop

000000a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a1:	31 d2                	xor    %edx,%edx
{
  a3:	89 e5                	mov    %esp,%ebp
  a5:	53                   	push   %ebx
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  b7:	83 c2 01             	add    $0x1,%edx
  ba:	84 c9                	test   %cl,%cl
  bc:	75 f2                	jne    b0 <strcpy+0x10>
    ;
  return os;
}
  be:	5b                   	pop    %ebx
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    
  c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cf:	90                   	nop

000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	56                   	push   %esi
  d4:	53                   	push   %ebx
  d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
  db:	0f b6 13             	movzbl (%ebx),%edx
  de:	0f b6 0e             	movzbl (%esi),%ecx
  e1:	84 d2                	test   %dl,%dl
  e3:	74 1e                	je     103 <strcmp+0x33>
  e5:	b8 01 00 00 00       	mov    $0x1,%eax
  ea:	38 ca                	cmp    %cl,%dl
  ec:	74 09                	je     f7 <strcmp+0x27>
  ee:	eb 20                	jmp    110 <strcmp+0x40>
  f0:	83 c0 01             	add    $0x1,%eax
  f3:	38 ca                	cmp    %cl,%dl
  f5:	75 19                	jne    110 <strcmp+0x40>
  f7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  fb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  ff:	84 d2                	test   %dl,%dl
 101:	75 ed                	jne    f0 <strcmp+0x20>
 103:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 105:	5b                   	pop    %ebx
 106:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 107:	29 c8                	sub    %ecx,%eax
}
 109:	5d                   	pop    %ebp
 10a:	c3                   	ret    
 10b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 10f:	90                   	nop
 110:	0f b6 c2             	movzbl %dl,%eax
 113:	5b                   	pop    %ebx
 114:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 115:	29 c8                	sub    %ecx,%eax
}
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000120 <strlen>:

uint
strlen(char *s)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 126:	80 39 00             	cmpb   $0x0,(%ecx)
 129:	74 15                	je     140 <strlen+0x20>
 12b:	31 d2                	xor    %edx,%edx
 12d:	8d 76 00             	lea    0x0(%esi),%esi
 130:	83 c2 01             	add    $0x1,%edx
 133:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 137:	89 d0                	mov    %edx,%eax
 139:	75 f5                	jne    130 <strlen+0x10>
    ;
  return n;
}
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    
 13d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 140:	31 c0                	xor    %eax,%eax
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    
 144:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop

00000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 157:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	89 d7                	mov    %edx,%edi
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 162:	89 d0                	mov    %edx,%eax
 164:	5f                   	pop    %edi
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
 167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16e:	66 90                	xchg   %ax,%ax

00000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 17a:	0f b6 18             	movzbl (%eax),%ebx
 17d:	84 db                	test   %bl,%bl
 17f:	74 1d                	je     19e <strchr+0x2e>
 181:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 183:	38 d3                	cmp    %dl,%bl
 185:	75 0d                	jne    194 <strchr+0x24>
 187:	eb 17                	jmp    1a0 <strchr+0x30>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 190:	38 ca                	cmp    %cl,%dl
 192:	74 0c                	je     1a0 <strchr+0x30>
  for(; *s; s++)
 194:	83 c0 01             	add    $0x1,%eax
 197:	0f b6 10             	movzbl (%eax),%edx
 19a:	84 d2                	test   %dl,%dl
 19c:	75 f2                	jne    190 <strchr+0x20>
      return (char*)s;
  return 0;
 19e:	31 c0                	xor    %eax,%eax
}
 1a0:	5b                   	pop    %ebx
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    
 1a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	31 f6                	xor    %esi,%esi
{
 1b7:	53                   	push   %ebx
 1b8:	89 f3                	mov    %esi,%ebx
 1ba:	83 ec 1c             	sub    $0x1c,%esp
 1bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c0:	eb 2f                	jmp    1f1 <gets+0x41>
 1c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1c8:	83 ec 04             	sub    $0x4,%esp
 1cb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1ce:	6a 01                	push   $0x1
 1d0:	50                   	push   %eax
 1d1:	6a 00                	push   $0x0
 1d3:	e8 31 01 00 00       	call   309 <read>
    if(cc < 1)
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	85 c0                	test   %eax,%eax
 1dd:	7e 1c                	jle    1fb <gets+0x4b>
      break;
    buf[i++] = c;
 1df:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e3:	83 c7 01             	add    $0x1,%edi
 1e6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1e9:	3c 0a                	cmp    $0xa,%al
 1eb:	74 23                	je     210 <gets+0x60>
 1ed:	3c 0d                	cmp    $0xd,%al
 1ef:	74 1f                	je     210 <gets+0x60>
  for(i=0; i+1 < max; ){
 1f1:	83 c3 01             	add    $0x1,%ebx
 1f4:	89 fe                	mov    %edi,%esi
 1f6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1f9:	7c cd                	jl     1c8 <gets+0x18>
 1fb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 200:	c6 03 00             	movb   $0x0,(%ebx)
}
 203:	8d 65 f4             	lea    -0xc(%ebp),%esp
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5f                   	pop    %edi
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    
 20b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop
 210:	8b 75 08             	mov    0x8(%ebp),%esi
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	01 de                	add    %ebx,%esi
 218:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 21a:	c6 03 00             	movb   $0x0,(%ebx)
}
 21d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 220:	5b                   	pop    %ebx
 221:	5e                   	pop    %esi
 222:	5f                   	pop    %edi
 223:	5d                   	pop    %ebp
 224:	c3                   	ret    
 225:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000230 <stat>:

int
stat(char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	pushl  0x8(%ebp)
 23d:	e8 ef 00 00 00       	call   331 <open>
  if(fd < 0)
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 27                	js     270 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	ff 75 0c             	pushl  0xc(%ebp)
 24f:	89 c3                	mov    %eax,%ebx
 251:	50                   	push   %eax
 252:	e8 f2 00 00 00       	call   349 <fstat>
  close(fd);
 257:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 25a:	89 c6                	mov    %eax,%esi
  close(fd);
 25c:	e8 b8 00 00 00       	call   319 <close>
  return r;
 261:	83 c4 10             	add    $0x10,%esp
}
 264:	8d 65 f8             	lea    -0x8(%ebp),%esp
 267:	89 f0                	mov    %esi,%eax
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb ed                	jmp    264 <stat+0x34>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 11             	movsbl (%ecx),%edx
 28a:	8d 42 d0             	lea    -0x30(%edx),%eax
 28d:	3c 09                	cmp    $0x9,%al
  n = 0;
 28f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 294:	77 1f                	ja     2b5 <atoi+0x35>
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 2a0:	83 c1 01             	add    $0x1,%ecx
 2a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2aa:	0f be 11             	movsbl (%ecx),%edx
 2ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	5b                   	pop    %ebx
 2b6:	5d                   	pop    %ebp
 2b7:	c3                   	ret    
 2b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop

000002c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 55 10             	mov    0x10(%ebp),%edx
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	56                   	push   %esi
 2cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	85 d2                	test   %edx,%edx
 2d0:	7e 13                	jle    2e5 <memmove+0x25>
 2d2:	01 c2                	add    %eax,%edx
  dst = vdst;
 2d4:	89 c7                	mov    %eax,%edi
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e1:	39 fa                	cmp    %edi,%edx
 2e3:	75 fb                	jne    2e0 <memmove+0x20>
  return vdst;
}
 2e5:	5e                   	pop    %esi
 2e6:	5f                   	pop    %edi
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    

000002e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <exit>:
SYSCALL(exit)
 2f1:	b8 02 00 00 00       	mov    $0x2,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <wait>:
SYSCALL(wait)
 2f9:	b8 03 00 00 00       	mov    $0x3,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <pipe>:
SYSCALL(pipe)
 301:	b8 04 00 00 00       	mov    $0x4,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <read>:
SYSCALL(read)
 309:	b8 05 00 00 00       	mov    $0x5,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <write>:
SYSCALL(write)
 311:	b8 10 00 00 00       	mov    $0x10,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <close>:
SYSCALL(close)
 319:	b8 15 00 00 00       	mov    $0x15,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <kill>:
SYSCALL(kill)
 321:	b8 06 00 00 00       	mov    $0x6,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <exec>:
SYSCALL(exec)
 329:	b8 07 00 00 00       	mov    $0x7,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <open>:
SYSCALL(open)
 331:	b8 0f 00 00 00       	mov    $0xf,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mknod>:
SYSCALL(mknod)
 339:	b8 11 00 00 00       	mov    $0x11,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <unlink>:
SYSCALL(unlink)
 341:	b8 12 00 00 00       	mov    $0x12,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <fstat>:
SYSCALL(fstat)
 349:	b8 08 00 00 00       	mov    $0x8,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <link>:
SYSCALL(link)
 351:	b8 13 00 00 00       	mov    $0x13,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <mkdir>:
SYSCALL(mkdir)
 359:	b8 14 00 00 00       	mov    $0x14,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <chdir>:
SYSCALL(chdir)
 361:	b8 09 00 00 00       	mov    $0x9,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <dup>:
SYSCALL(dup)
 369:	b8 0a 00 00 00       	mov    $0xa,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <getpid>:
SYSCALL(getpid)
 371:	b8 0b 00 00 00       	mov    $0xb,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <sbrk>:
SYSCALL(sbrk)
 379:	b8 0c 00 00 00       	mov    $0xc,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sleep>:
SYSCALL(sleep)
 381:	b8 0d 00 00 00       	mov    $0xd,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <uptime>:
SYSCALL(uptime)
 389:	b8 0e 00 00 00       	mov    $0xe,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <shutdown>:
SYSCALL(shutdown)
 391:	b8 16 00 00 00       	mov    $0x16,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <shutdown2>:
 399:	b8 17 00 00 00       	mov    $0x17,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    
 3a1:	66 90                	xchg   %ax,%ax
 3a3:	66 90                	xchg   %ax,%ax
 3a5:	66 90                	xchg   %ax,%ax
 3a7:	66 90                	xchg   %ax,%ax
 3a9:	66 90                	xchg   %ax,%ax
 3ab:	66 90                	xchg   %ax,%ax
 3ad:	66 90                	xchg   %ax,%ax
 3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3b6:	89 d3                	mov    %edx,%ebx
{
 3b8:	83 ec 3c             	sub    $0x3c,%esp
 3bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 3be:	85 d2                	test   %edx,%edx
 3c0:	0f 89 92 00 00 00    	jns    458 <printint+0xa8>
 3c6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ca:	0f 84 88 00 00 00    	je     458 <printint+0xa8>
    neg = 1;
 3d0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 3d7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 3d9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3e0:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3e3:	eb 08                	jmp    3ed <printint+0x3d>
 3e5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 3eb:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 3ed:	89 d8                	mov    %ebx,%eax
 3ef:	31 d2                	xor    %edx,%edx
 3f1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 3f4:	f7 f1                	div    %ecx
 3f6:	83 c7 01             	add    $0x1,%edi
 3f9:	0f b6 92 e0 07 00 00 	movzbl 0x7e0(%edx),%edx
 400:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 403:	39 d9                	cmp    %ebx,%ecx
 405:	76 e1                	jbe    3e8 <printint+0x38>
  if(neg)
 407:	8b 45 c0             	mov    -0x40(%ebp),%eax
 40a:	85 c0                	test   %eax,%eax
 40c:	74 0d                	je     41b <printint+0x6b>
    buf[i++] = '-';
 40e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 413:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 418:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 41b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 41e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 421:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 425:	eb 0f                	jmp    436 <printint+0x86>
 427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42e:	66 90                	xchg   %ax,%ax
 430:	0f b6 13             	movzbl (%ebx),%edx
 433:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 436:	83 ec 04             	sub    $0x4,%esp
 439:	88 55 d7             	mov    %dl,-0x29(%ebp)
 43c:	6a 01                	push   $0x1
 43e:	56                   	push   %esi
 43f:	57                   	push   %edi
 440:	e8 cc fe ff ff       	call   311 <write>

  while(--i >= 0)
 445:	83 c4 10             	add    $0x10,%esp
 448:	39 de                	cmp    %ebx,%esi
 44a:	75 e4                	jne    430 <printint+0x80>
    putc(fd, buf[i]);
}
 44c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44f:	5b                   	pop    %ebx
 450:	5e                   	pop    %esi
 451:	5f                   	pop    %edi
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 458:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 45f:	e9 75 ff ff ff       	jmp    3d9 <printint+0x29>
 464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 46f:	90                   	nop

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 479:	8b 75 0c             	mov    0xc(%ebp),%esi
 47c:	0f b6 1e             	movzbl (%esi),%ebx
 47f:	84 db                	test   %bl,%bl
 481:	0f 84 b9 00 00 00    	je     540 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 45 10             	lea    0x10(%ebp),%eax
 48a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 48d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 490:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 492:	89 45 d0             	mov    %eax,-0x30(%ebp)
 495:	eb 38                	jmp    4cf <printf+0x5f>
 497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49e:	66 90                	xchg   %ax,%ax
 4a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4a3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4a8:	83 f8 25             	cmp    $0x25,%eax
 4ab:	74 17                	je     4c4 <printf+0x54>
  write(fd, &c, 1);
 4ad:	83 ec 04             	sub    $0x4,%esp
 4b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4b3:	6a 01                	push   $0x1
 4b5:	57                   	push   %edi
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 53 fe ff ff       	call   311 <write>
 4be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4c7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4cb:	84 db                	test   %bl,%bl
 4cd:	74 71                	je     540 <printf+0xd0>
    c = fmt[i] & 0xff;
 4cf:	0f be cb             	movsbl %bl,%ecx
 4d2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4d5:	85 d2                	test   %edx,%edx
 4d7:	74 c7                	je     4a0 <printf+0x30>
      }
    } else if(state == '%'){
 4d9:	83 fa 25             	cmp    $0x25,%edx
 4dc:	75 e6                	jne    4c4 <printf+0x54>
      if(c == 'd'){
 4de:	83 f8 64             	cmp    $0x64,%eax
 4e1:	0f 84 99 00 00 00    	je     580 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4ed:	83 f9 70             	cmp    $0x70,%ecx
 4f0:	74 5e                	je     550 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f2:	83 f8 73             	cmp    $0x73,%eax
 4f5:	0f 84 d5 00 00 00    	je     5d0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fb:	83 f8 63             	cmp    $0x63,%eax
 4fe:	0f 84 8c 00 00 00    	je     590 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 504:	83 f8 25             	cmp    $0x25,%eax
 507:	0f 84 b3 00 00 00    	je     5c0 <printf+0x150>
  write(fd, &c, 1);
 50d:	83 ec 04             	sub    $0x4,%esp
 510:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 514:	6a 01                	push   $0x1
 516:	57                   	push   %edi
 517:	ff 75 08             	pushl  0x8(%ebp)
 51a:	e8 f2 fd ff ff       	call   311 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 51f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 522:	83 c4 0c             	add    $0xc,%esp
 525:	6a 01                	push   $0x1
 527:	83 c6 01             	add    $0x1,%esi
 52a:	57                   	push   %edi
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 de fd ff ff       	call   311 <write>
  for(i = 0; fmt[i]; i++){
 533:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 537:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 53a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 53c:	84 db                	test   %bl,%bl
 53e:	75 8f                	jne    4cf <printf+0x5f>
    }
  }
}
 540:	8d 65 f4             	lea    -0xc(%ebp),%esp
 543:	5b                   	pop    %ebx
 544:	5e                   	pop    %esi
 545:	5f                   	pop    %edi
 546:	5d                   	pop    %ebp
 547:	c3                   	ret    
 548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop
        printint(fd, *ap, 16, 0);
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	b9 10 00 00 00       	mov    $0x10,%ecx
 558:	6a 00                	push   $0x0
 55a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	8b 13                	mov    (%ebx),%edx
 562:	e8 49 fe ff ff       	call   3b0 <printint>
        ap++;
 567:	89 d8                	mov    %ebx,%eax
 569:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56c:	31 d2                	xor    %edx,%edx
        ap++;
 56e:	83 c0 04             	add    $0x4,%eax
 571:	89 45 d0             	mov    %eax,-0x30(%ebp)
 574:	e9 4b ff ff ff       	jmp    4c4 <printf+0x54>
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 580:	83 ec 0c             	sub    $0xc,%esp
 583:	b9 0a 00 00 00       	mov    $0xa,%ecx
 588:	6a 01                	push   $0x1
 58a:	eb ce                	jmp    55a <printf+0xea>
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 590:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 596:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 598:	6a 01                	push   $0x1
        ap++;
 59a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 59d:	57                   	push   %edi
 59e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 5a1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5a4:	e8 68 fd ff ff       	call   311 <write>
        ap++;
 5a9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5af:	31 d2                	xor    %edx,%edx
 5b1:	e9 0e ff ff ff       	jmp    4c4 <printf+0x54>
 5b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 5c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5c3:	83 ec 04             	sub    $0x4,%esp
 5c6:	e9 5a ff ff ff       	jmp    525 <printf+0xb5>
 5cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop
        s = (char*)*ap;
 5d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5d3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5d5:	83 c0 04             	add    $0x4,%eax
 5d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5db:	85 db                	test   %ebx,%ebx
 5dd:	74 17                	je     5f6 <printf+0x186>
        while(*s != 0){
 5df:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5e2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5e4:	84 c0                	test   %al,%al
 5e6:	0f 84 d8 fe ff ff    	je     4c4 <printf+0x54>
 5ec:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5ef:	89 de                	mov    %ebx,%esi
 5f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5f4:	eb 1a                	jmp    610 <printf+0x1a0>
          s = "(null)";
 5f6:	bb d8 07 00 00       	mov    $0x7d8,%ebx
        while(*s != 0){
 5fb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5fe:	b8 28 00 00 00       	mov    $0x28,%eax
 603:	89 de                	mov    %ebx,%esi
 605:	8b 5d 08             	mov    0x8(%ebp),%ebx
 608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
          s++;
 613:	83 c6 01             	add    $0x1,%esi
 616:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 619:	6a 01                	push   $0x1
 61b:	57                   	push   %edi
 61c:	53                   	push   %ebx
 61d:	e8 ef fc ff ff       	call   311 <write>
        while(*s != 0){
 622:	0f b6 06             	movzbl (%esi),%eax
 625:	83 c4 10             	add    $0x10,%esp
 628:	84 c0                	test   %al,%al
 62a:	75 e4                	jne    610 <printf+0x1a0>
 62c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 62f:	31 d2                	xor    %edx,%edx
 631:	e9 8e fe ff ff       	jmp    4c4 <printf+0x54>
 636:	66 90                	xchg   %ax,%ax
 638:	66 90                	xchg   %ax,%ax
 63a:	66 90                	xchg   %ax,%ax
 63c:	66 90                	xchg   %ax,%ax
 63e:	66 90                	xchg   %ax,%ax

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 98 0a 00 00       	mov    0xa98,%eax
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 64e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 650:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 653:	39 c8                	cmp    %ecx,%eax
 655:	73 19                	jae    670 <free+0x30>
 657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65e:	66 90                	xchg   %ax,%ax
 660:	39 d1                	cmp    %edx,%ecx
 662:	72 14                	jb     678 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	39 d0                	cmp    %edx,%eax
 666:	73 10                	jae    678 <free+0x38>
{
 668:	89 d0                	mov    %edx,%eax
 66a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	39 c8                	cmp    %ecx,%eax
 66e:	72 f0                	jb     660 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	39 d0                	cmp    %edx,%eax
 672:	72 f4                	jb     668 <free+0x28>
 674:	39 d1                	cmp    %edx,%ecx
 676:	73 f0                	jae    668 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 678:	8b 73 fc             	mov    -0x4(%ebx),%esi
 67b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67e:	39 fa                	cmp    %edi,%edx
 680:	74 1e                	je     6a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 682:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 68b:	39 f1                	cmp    %esi,%ecx
 68d:	74 28                	je     6b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 68f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 691:	5b                   	pop    %ebx
  freep = p;
 692:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 697:	5e                   	pop    %esi
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    
 69b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 69f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 6a0:	03 72 04             	add    0x4(%edx),%esi
 6a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 12                	mov    (%edx),%edx
 6aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ad:	8b 50 04             	mov    0x4(%eax),%edx
 6b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6b3:	39 f1                	cmp    %esi,%ecx
 6b5:	75 d8                	jne    68f <free+0x4f>
    p->s.size += bp->s.size;
 6b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6ba:	a3 98 0a 00 00       	mov    %eax,0xa98
    p->s.size += bp->s.size;
 6bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6c5:	89 10                	mov    %edx,(%eax)
}
 6c7:	5b                   	pop    %ebx
 6c8:	5e                   	pop    %esi
 6c9:	5f                   	pop    %edi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6dc:	8b 3d 98 0a 00 00    	mov    0xa98,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	8d 70 07             	lea    0x7(%eax),%esi
 6e5:	c1 ee 03             	shr    $0x3,%esi
 6e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6eb:	85 ff                	test   %edi,%edi
 6ed:	0f 84 ad 00 00 00    	je     7a0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 6f5:	8b 4a 04             	mov    0x4(%edx),%ecx
 6f8:	39 f1                	cmp    %esi,%ecx
 6fa:	73 72                	jae    76e <malloc+0x9e>
 6fc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 702:	bb 00 10 00 00       	mov    $0x1000,%ebx
 707:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 70a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 711:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 714:	eb 1b                	jmp    731 <malloc+0x61>
 716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 720:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 722:	8b 48 04             	mov    0x4(%eax),%ecx
 725:	39 f1                	cmp    %esi,%ecx
 727:	73 4f                	jae    778 <malloc+0xa8>
 729:	8b 3d 98 0a 00 00    	mov    0xa98,%edi
 72f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 731:	39 d7                	cmp    %edx,%edi
 733:	75 eb                	jne    720 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 735:	83 ec 0c             	sub    $0xc,%esp
 738:	ff 75 e4             	pushl  -0x1c(%ebp)
 73b:	e8 39 fc ff ff       	call   379 <sbrk>
  if(p == (char*)-1)
 740:	83 c4 10             	add    $0x10,%esp
 743:	83 f8 ff             	cmp    $0xffffffff,%eax
 746:	74 1c                	je     764 <malloc+0x94>
  hp->s.size = nu;
 748:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 74b:	83 ec 0c             	sub    $0xc,%esp
 74e:	83 c0 08             	add    $0x8,%eax
 751:	50                   	push   %eax
 752:	e8 e9 fe ff ff       	call   640 <free>
  return freep;
 757:	8b 15 98 0a 00 00    	mov    0xa98,%edx
      if((p = morecore(nunits)) == 0)
 75d:	83 c4 10             	add    $0x10,%esp
 760:	85 d2                	test   %edx,%edx
 762:	75 bc                	jne    720 <malloc+0x50>
        return 0;
  }
}
 764:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 767:	31 c0                	xor    %eax,%eax
}
 769:	5b                   	pop    %ebx
 76a:	5e                   	pop    %esi
 76b:	5f                   	pop    %edi
 76c:	5d                   	pop    %ebp
 76d:	c3                   	ret    
    if(p->s.size >= nunits){
 76e:	89 d0                	mov    %edx,%eax
 770:	89 fa                	mov    %edi,%edx
 772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 778:	39 ce                	cmp    %ecx,%esi
 77a:	74 54                	je     7d0 <malloc+0x100>
        p->s.size -= nunits;
 77c:	29 f1                	sub    %esi,%ecx
 77e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 781:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 784:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 787:	89 15 98 0a 00 00    	mov    %edx,0xa98
}
 78d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 790:	83 c0 08             	add    $0x8,%eax
}
 793:	5b                   	pop    %ebx
 794:	5e                   	pop    %esi
 795:	5f                   	pop    %edi
 796:	5d                   	pop    %ebp
 797:	c3                   	ret    
 798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 7a0:	c7 05 98 0a 00 00 9c 	movl   $0xa9c,0xa98
 7a7:	0a 00 00 
    base.s.size = 0;
 7aa:	bf 9c 0a 00 00       	mov    $0xa9c,%edi
    base.s.ptr = freep = prevp = &base;
 7af:	c7 05 9c 0a 00 00 9c 	movl   $0xa9c,0xa9c
 7b6:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7bb:	c7 05 a0 0a 00 00 00 	movl   $0x0,0xaa0
 7c2:	00 00 00 
    if(p->s.size >= nunits){
 7c5:	e9 32 ff ff ff       	jmp    6fc <malloc+0x2c>
 7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7d0:	8b 08                	mov    (%eax),%ecx
 7d2:	89 0a                	mov    %ecx,(%edx)
 7d4:	eb b1                	jmp    787 <malloc+0xb7>
