
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2f 10 80       	mov    $0x80102fb0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 6f 10 80       	push   $0x80106fc0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 95 42 00 00       	call   801042f0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6f 10 80       	push   $0x80106fc7
80100097:	50                   	push   %eax
80100098:	e8 43 41 00 00       	call   801041e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 07 43 00 00       	call   801043f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 a9 43 00 00       	call   80104510 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 40 00 00       	call   80104220 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 20 00 00       	call   80102200 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 6f 10 80       	push   $0x80106fce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 fd 40 00 00       	call   801042c0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 27 20 00 00       	jmp    80102200 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 6f 10 80       	push   $0x80106fdf
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 40 00 00       	call   801042c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 40 00 00       	call   80104280 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 d0 41 00 00       	call   801043f0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 9f 42 00 00       	jmp    80104510 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 6f 10 80       	push   $0x80106fe6
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 6c 15 00 00       	call   80101800 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 50 41 00 00       	call   801043f0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002ba:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 b6 3b 00 00       	call   80103e90 <sleep>
    while(input.r == input.w){
801002da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 f0 35 00 00       	call   801038e0 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 0c 42 00 00       	call   80104510 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 13 14 00 00       	call   80101720 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 ae 41 00 00       	call   80104510 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 b5 13 00 00       	call   80101720 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 24 00 00       	call   80102830 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 6f 10 80       	push   $0x80106fed
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 3f 79 10 80 	movl   $0x8010793f,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 3f 00 00       	call   80104310 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 70 10 80       	push   $0x80107001
801003ed:	e8 be 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
    ;
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 b1 57 00 00       	call   80105be0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 c6 56 00 00       	call   80105be0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 56 00 00       	call   80105be0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 56 00 00       	call   80105be0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 9a 40 00 00       	call   80104600 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 e5 3f 00 00       	call   80104560 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 70 10 80       	push   $0x80107005
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 30 70 10 80 	movzbl -0x7fef8fd0(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
      ;
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 b9 11 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 9d 3d 00 00       	call   801043f0 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
      ;
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068f:	90                   	nop
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 73 3e 00 00       	call   80104510 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 7a 10 00 00       	call   80101720 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
      ;
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100727:	90                   	nop
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
    switch(c){
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 18 70 10 80       	mov    $0x80107018,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
      ;
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
      ;
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 3b 3c 00 00       	call   801043f0 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
      ;
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
      ;
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 e3 3c 00 00       	call   80104510 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 70 10 80       	push   $0x8010701f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 78 3b 00 00       	call   801043f0 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a0:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
      ;
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
    switch(c){
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095a:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
      ;
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100999:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 44 3b 00 00       	call   80104510 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
      ;
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a0c:	e8 2f 36 00 00       	call   80104040 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 fb 36 00 00       	jmp    80104120 <procdump>
80100a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 28 70 10 80       	push   $0x80107028
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 ab 38 00 00       	call   801042f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 42 19 00 00       	call   801023b0 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 4f 2e 00 00       	call   801038e0 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 04 22 00 00       	call   80102ca0 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	pushl  0x8(%ebp)
80100aa2:	e8 19 15 00 00       	call   80101fc0 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 02 03 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 63 0c 00 00       	call   80101720 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 32 0f 00 00       	call   80101a00 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 d1 0e 00 00       	call   801019b0 <iunlockput>
    end_op();
80100adf:	e8 2c 22 00 00       	call   80102d10 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 27 62 00 00       	call   80106d30 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 ac 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 d8 5f 00 00       	call   80106b50 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 e2 5e 00 00       	call   80106a90 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 2a 0e 00 00       	call   80101a00 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 c0 60 00 00       	call   80106cb0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 8f 0d 00 00       	call   801019b0 <iunlockput>
  end_op();
80100c21:	e8 ea 20 00 00       	call   80102d10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 19 5f 00 00       	call   80106b50 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 78 61 00 00       	call   80106dd0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 c8 3a 00 00       	call   80104770 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 b5 3a 00 00       	call   80104770 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 54 62 00 00       	call   80106f20 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 5f 00 00       	call   80106cb0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 e8 61 00 00       	call   80106f20 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 ba 39 00 00       	call   80104730 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 5e 5b 00 00       	call   80106900 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 06 5f 00 00       	call   80106cb0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 38 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100db4:	e8 57 1f 00 00       	call   80102d10 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 41 70 10 80       	push   $0x80107041
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 19 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 4d 70 10 80       	push   $0x8010704d
80100deb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df0:	e8 fb 34 00 00       	call   801042f0 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e11:	e8 da 35 00 00       	call   801043f0 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 ca 36 00 00       	call   80104510 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 b1 36 00 00       	call   80104510 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7f:	e8 6c 35 00 00       	call   801043f0 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e9c:	e8 6f 36 00 00       	call   80104510 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 54 70 10 80       	push   $0x80107054
80100eb0:	e8 db f4 ff ff       	call   80100390 <panic>
80100eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed1:	e8 1a 35 00 00       	call   801043f0 <acquire>
  if(f->ref < 1)
80100ed6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 8e a3 00 00 00    	jle    80100f87 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 e8 01             	sub    $0x1,%eax
80100ee7:	89 43 04             	mov    %eax,0x4(%ebx)
80100eea:	75 44                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100efe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f04:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f0c:	e8 ff 35 00 00       	call   80104510 <release>

  if(ff.type == FD_PIPE)
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	83 ff 01             	cmp    $0x1,%edi
80100f17:	74 2f                	je     80100f48 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f19:	83 ff 02             	cmp    $0x2,%edi
80100f1c:	74 4a                	je     80100f68 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f21:	5b                   	pop    %ebx
80100f22:	5e                   	pop    %esi
80100f23:	5f                   	pop    %edi
80100f24:	5d                   	pop    %ebp
80100f25:	c3                   	ret    
80100f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 cd 35 00 00       	jmp    80104510 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 fa 24 00 00       	call   80103450 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5c:	5b                   	pop    %ebx
80100f5d:	5e                   	pop    %esi
80100f5e:	5f                   	pop    %edi
80100f5f:	5d                   	pop    %ebp
80100f60:	c3                   	ret    
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f68:	e8 33 1d 00 00       	call   80102ca0 <begin_op>
    iput(ff.ip);
80100f6d:	83 ec 0c             	sub    $0xc,%esp
80100f70:	ff 75 e0             	pushl  -0x20(%ebp)
80100f73:	e8 d8 08 00 00       	call   80101850 <iput>
    end_op();
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
    end_op();
80100f82:	e9 89 1d 00 00       	jmp    80102d10 <end_op>
    panic("fileclose");
80100f87:	83 ec 0c             	sub    $0xc,%esp
80100f8a:	68 5c 70 10 80       	push   $0x8010705c
80100f8f:	e8 fc f3 ff ff       	call   80100390 <panic>
80100f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	pushl  0x10(%ebx)
80100fb5:	e8 66 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	pushl  0xc(%ebp)
80100fbf:	ff 73 10             	pushl  0x10(%ebx)
80100fc2:	e8 09 0a 00 00       	call   801019d0 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	pushl  0x10(%ebx)
80100fcb:	e8 30 08 00 00       	call   80101800 <iunlock>
    return 0;
80100fd0:	83 c4 10             	add    $0x10,%esp
80100fd3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	pushl  0x10(%ebx)
8010101a:	e8 01 07 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	pushl  0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	pushl  0x10(%ebx)
80101027:	e8 d4 09 00 00       	call   80101a00 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	89 c6                	mov    %eax,%esi
80101031:	85 c0                	test   %eax,%eax
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 bd 07 00 00       	call   80101800 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 9e 25 00 00       	jmp    80103600 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 66 70 10 80       	push   $0x80107066
80101077:	e8 14 f3 ff ff       	call   80100390 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010108c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101092:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101095:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 bb 00 00 00    	je     8010115d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 03                	mov    (%ebx),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 bf 00 00 00    	je     8010116c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 c8 00 00 00    	jne    8010117e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 30                	jg     801010ef <filewrite+0x6f>
801010bf:	e9 94 00 00 00       	jmp    80101158 <filewrite+0xd8>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 73 10             	pushl  0x10(%ebx)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 27 07 00 00       	call   80101800 <iunlock>
      end_op();
801010d9:	e8 32 1c 00 00       	call   80102d10 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	39 f0                	cmp    %esi,%eax
801010e6:	75 60                	jne    80101148 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010e8:	01 c7                	add    %eax,%edi
    while(i < n){
801010ea:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010ed:	7e 69                	jle    80101158 <filewrite+0xd8>
      int n1 = n - i;
801010ef:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801010f2:	b8 00 06 00 00       	mov    $0x600,%eax
801010f7:	29 fe                	sub    %edi,%esi
      if(n1 > max)
801010f9:	81 fe 00 06 00 00    	cmp    $0x600,%esi
801010ff:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101102:	e8 99 1b 00 00       	call   80102ca0 <begin_op>
      ilock(f->ip);
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	ff 73 10             	pushl  0x10(%ebx)
8010110d:	e8 0e 06 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101112:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101115:	56                   	push   %esi
80101116:	ff 73 14             	pushl  0x14(%ebx)
80101119:	01 f8                	add    %edi,%eax
8010111b:	50                   	push   %eax
8010111c:	ff 73 10             	pushl  0x10(%ebx)
8010111f:	e8 dc 09 00 00       	call   80101b00 <writei>
80101124:	83 c4 20             	add    $0x20,%esp
80101127:	85 c0                	test   %eax,%eax
80101129:	7f 9d                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 73 10             	pushl  0x10(%ebx)
80101131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101134:	e8 c7 06 00 00       	call   80101800 <iunlock>
      end_op();
80101139:	e8 d2 1b 00 00       	call   80102d10 <end_op>
      if(r < 0)
8010113e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101141:	83 c4 10             	add    $0x10,%esp
80101144:	85 c0                	test   %eax,%eax
80101146:	75 15                	jne    8010115d <filewrite+0xdd>
        panic("short filewrite");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 6f 70 10 80       	push   $0x8010706f
80101150:	e8 3b f2 ff ff       	call   80100390 <panic>
80101155:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101158:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010115b:	74 05                	je     80101162 <filewrite+0xe2>
8010115d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101165:	89 f8                	mov    %edi,%eax
80101167:	5b                   	pop    %ebx
80101168:	5e                   	pop    %esi
80101169:	5f                   	pop    %edi
8010116a:	5d                   	pop    %ebp
8010116b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010116c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010116f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101179:	e9 72 23 00 00       	jmp    801034f0 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 75 70 10 80       	push   $0x80107075
80101186:	e8 05 f2 ff ff       	call   80100390 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101199:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010119f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011a2:	85 c9                	test   %ecx,%ecx
801011a4:	0f 84 87 00 00 00    	je     80101231 <balloc+0xa1>
801011aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b4:	83 ec 08             	sub    $0x8,%esp
801011b7:	89 f0                	mov    %esi,%eax
801011b9:	c1 f8 0c             	sar    $0xc,%eax
801011bc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011c2:	50                   	push   %eax
801011c3:	ff 75 d8             	pushl  -0x28(%ebp)
801011c6:	e8 05 ef ff ff       	call   801000d0 <bread>
801011cb:	83 c4 10             	add    $0x10,%esp
801011ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011d9:	31 c0                	xor    %eax,%eax
801011db:	eb 2f                	jmp    8010120c <balloc+0x7c>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011e0:	89 c1                	mov    %eax,%ecx
801011e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ef:	89 c1                	mov    %eax,%ecx
801011f1:	c1 f9 03             	sar    $0x3,%ecx
801011f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011f9:	89 fa                	mov    %edi,%edx
801011fb:	85 df                	test   %ebx,%edi
801011fd:	74 41                	je     80101240 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ff:	83 c0 01             	add    $0x1,%eax
80101202:	83 c6 01             	add    $0x1,%esi
80101205:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010120a:	74 05                	je     80101211 <balloc+0x81>
8010120c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010120f:	77 cf                	ja     801011e0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	ff 75 e4             	pushl  -0x1c(%ebp)
80101217:	e8 d4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010122f:	77 80                	ja     801011b1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 7f 70 10 80       	push   $0x8010707f
80101239:	e8 52 f1 ff ff       	call   80100390 <panic>
8010123e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101240:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101243:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101246:	09 da                	or     %ebx,%edx
80101248:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010124c:	57                   	push   %edi
8010124d:	e8 2e 1c 00 00       	call   80102e80 <log_write>
        brelse(bp);
80101252:	89 3c 24             	mov    %edi,(%esp)
80101255:	e8 96 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010125a:	58                   	pop    %eax
8010125b:	5a                   	pop    %edx
8010125c:	56                   	push   %esi
8010125d:	ff 75 d8             	pushl  -0x28(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101265:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101268:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010126a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010126d:	68 00 02 00 00       	push   $0x200
80101272:	6a 00                	push   $0x0
80101274:	50                   	push   %eax
80101275:	e8 e6 32 00 00       	call   80104560 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 fe 1b 00 00       	call   80102e80 <log_write>
  brelse(bp);
80101282:	89 1c 24             	mov    %ebx,(%esp)
80101285:	e8 66 ef ff ff       	call   801001f0 <brelse>
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
{
801012a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012af:	83 ec 28             	sub    $0x28,%esp
801012b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012b5:	68 e0 09 11 80       	push   $0x801109e0
801012ba:	e8 31 31 00 00       	call   801043f0 <acquire>
801012bf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c5:	eb 1b                	jmp    801012e2 <iget+0x42>
801012c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d0:	39 3b                	cmp    %edi,(%ebx)
801012d2:	74 6c                	je     80101340 <iget+0xa0>
801012d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012e0:	73 26                	jae    80101308 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012e5:	85 c9                	test   %ecx,%ecx
801012e7:	7f e7                	jg     801012d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012e9:	85 f6                	test   %esi,%esi
801012eb:	75 e7                	jne    801012d4 <iget+0x34>
801012ed:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
801012f3:	85 c9                	test   %ecx,%ecx
801012f5:	75 70                	jne    80101367 <iget+0xc7>
801012f7:	89 de                	mov    %ebx,%esi
801012f9:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fb:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101301:	72 df                	jb     801012e2 <iget+0x42>
80101303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101307:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101308:	85 f6                	test   %esi,%esi
8010130a:	74 74                	je     80101380 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010130c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010130f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101311:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101314:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010131b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101322:	68 e0 09 11 80       	push   $0x801109e0
80101327:	e8 e4 31 00 00       	call   80104510 <release>

  return ip;
8010132c:	83 c4 10             	add    $0x10,%esp
}
8010132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101332:	89 f0                	mov    %esi,%eax
80101334:	5b                   	pop    %ebx
80101335:	5e                   	pop    %esi
80101336:	5f                   	pop    %edi
80101337:	5d                   	pop    %ebp
80101338:	c3                   	ret    
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101340:	39 53 04             	cmp    %edx,0x4(%ebx)
80101343:	75 8f                	jne    801012d4 <iget+0x34>
      release(&icache.lock);
80101345:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101348:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010134b:	89 de                	mov    %ebx,%esi
      ip->ref++;
8010134d:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101350:	68 e0 09 11 80       	push   $0x801109e0
80101355:	e8 b6 31 00 00       	call   80104510 <release>
      return ip;
8010135a:	83 c4 10             	add    $0x10,%esp
}
8010135d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101360:	89 f0                	mov    %esi,%eax
80101362:	5b                   	pop    %ebx
80101363:	5e                   	pop    %esi
80101364:	5f                   	pop    %edi
80101365:	5d                   	pop    %ebp
80101366:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101367:	3d 34 26 11 80       	cmp    $0x80112634,%eax
8010136c:	73 12                	jae    80101380 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010136e:	8b 48 08             	mov    0x8(%eax),%ecx
80101371:	89 c3                	mov    %eax,%ebx
80101373:	85 c9                	test   %ecx,%ecx
80101375:	0f 8f 55 ff ff ff    	jg     801012d0 <iget+0x30>
8010137b:	e9 6d ff ff ff       	jmp    801012ed <iget+0x4d>
    panic("iget: no inodes");
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	68 95 70 10 80       	push   $0x80107095
80101388:	e8 03 f0 ff ff       	call   80100390 <panic>
8010138d:	8d 76 00             	lea    0x0(%esi),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	89 c6                	mov    %eax,%esi
80101397:	53                   	push   %ebx
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	0f 86 84 00 00 00    	jbe    80101428 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013a7:	83 fb 7f             	cmp    $0x7f,%ebx
801013aa:	0f 87 98 00 00 00    	ja     80101448 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013b0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013b6:	8b 00                	mov    (%eax),%eax
801013b8:	85 d2                	test   %edx,%edx
801013ba:	74 54                	je     80101410 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013bc:	83 ec 08             	sub    $0x8,%esp
801013bf:	52                   	push   %edx
801013c0:	50                   	push   %eax
801013c1:	e8 0a ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013c6:	83 c4 10             	add    $0x10,%esp
801013c9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013cd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013cf:	8b 1a                	mov    (%edx),%ebx
801013d1:	85 db                	test   %ebx,%ebx
801013d3:	74 1b                	je     801013f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	57                   	push   %edi
801013d9:	e8 12 ee ff ff       	call   801001f0 <brelse>
    return addr;
801013de:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e4:	89 d8                	mov    %ebx,%eax
801013e6:	5b                   	pop    %ebx
801013e7:	5e                   	pop    %esi
801013e8:	5f                   	pop    %edi
801013e9:	5d                   	pop    %ebp
801013ea:	c3                   	ret    
801013eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ef:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801013f0:	8b 06                	mov    (%esi),%eax
801013f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013f5:	e8 96 fd ff ff       	call   80101190 <balloc>
801013fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101400:	89 c3                	mov    %eax,%ebx
80101402:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101404:	57                   	push   %edi
80101405:	e8 76 1a 00 00       	call   80102e80 <log_write>
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	eb c6                	jmp    801013d5 <bmap+0x45>
8010140f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 7b fd ff ff       	call   80101190 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	eb 9b                	jmp    801013bc <bmap+0x2c>
80101421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101428:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010142b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010142e:	85 db                	test   %ebx,%ebx
80101430:	75 af                	jne    801013e1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101432:	8b 00                	mov    (%eax),%eax
80101434:	e8 57 fd ff ff       	call   80101190 <balloc>
80101439:	89 47 5c             	mov    %eax,0x5c(%edi)
8010143c:	89 c3                	mov    %eax,%ebx
}
8010143e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101441:	89 d8                	mov    %ebx,%eax
80101443:	5b                   	pop    %ebx
80101444:	5e                   	pop    %esi
80101445:	5f                   	pop    %edi
80101446:	5d                   	pop    %ebp
80101447:	c3                   	ret    
  panic("bmap: out of range");
80101448:	83 ec 0c             	sub    $0xc,%esp
8010144b:	68 a5 70 10 80       	push   $0x801070a5
80101450:	e8 3b ef ff ff       	call   80100390 <panic>
80101455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101460 <readsb>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	56                   	push   %esi
80101464:	53                   	push   %ebx
80101465:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101468:	83 ec 08             	sub    $0x8,%esp
8010146b:	6a 01                	push   $0x1
8010146d:	ff 75 08             	pushl  0x8(%ebp)
80101470:	e8 5b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101475:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101478:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010147a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147d:	6a 1c                	push   $0x1c
8010147f:	50                   	push   %eax
80101480:	56                   	push   %esi
80101481:	e8 7a 31 00 00       	call   80104600 <memmove>
  brelse(bp);
80101486:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101489:	83 c4 10             	add    $0x10,%esp
}
8010148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5d                   	pop    %ebp
  brelse(bp);
80101492:	e9 59 ed ff ff       	jmp    801001f0 <brelse>
80101497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149e:	66 90                	xchg   %ax,%ax

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	89 c6                	mov    %eax,%esi
801014a6:	53                   	push   %ebx
801014a7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014a9:	83 ec 08             	sub    $0x8,%esp
801014ac:	68 c0 09 11 80       	push   $0x801109c0
801014b1:	50                   	push   %eax
801014b2:	e8 a9 ff ff ff       	call   80101460 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014b7:	58                   	pop    %eax
801014b8:	5a                   	pop    %edx
801014b9:	89 da                	mov    %ebx,%edx
801014bb:	c1 ea 0c             	shr    $0xc,%edx
801014be:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014c4:	52                   	push   %edx
801014c5:	56                   	push   %esi
801014c6:	e8 05 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014cb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014cd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014d0:	ba 01 00 00 00       	mov    $0x1,%edx
801014d5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014d8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014de:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014e1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014e3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014e8:	85 d1                	test   %edx,%ecx
801014ea:	74 25                	je     80101511 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014ec:	f7 d2                	not    %edx
801014ee:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014f0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014f3:	21 ca                	and    %ecx,%edx
801014f5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014f9:	56                   	push   %esi
801014fa:	e8 81 19 00 00       	call   80102e80 <log_write>
  brelse(bp);
801014ff:	89 34 24             	mov    %esi,(%esp)
80101502:	e8 e9 ec ff ff       	call   801001f0 <brelse>
}
80101507:	83 c4 10             	add    $0x10,%esp
8010150a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150d:	5b                   	pop    %ebx
8010150e:	5e                   	pop    %esi
8010150f:	5d                   	pop    %ebp
80101510:	c3                   	ret    
    panic("freeing free block");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 b8 70 10 80       	push   $0x801070b8
80101519:	e8 72 ee ff ff       	call   80100390 <panic>
8010151e:	66 90                	xchg   %ax,%ax

80101520 <iinit>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101529:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010152c:	68 cb 70 10 80       	push   $0x801070cb
80101531:	68 e0 09 11 80       	push   $0x801109e0
80101536:	e8 b5 2d 00 00       	call   801042f0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	68 d2 70 10 80       	push   $0x801070d2
80101548:	53                   	push   %ebx
80101549:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010154f:	e8 8c 2c 00 00       	call   801041e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010155d:	75 e1                	jne    80101540 <iinit+0x20>
  readsb(dev, &sb);
8010155f:	83 ec 08             	sub    $0x8,%esp
80101562:	68 c0 09 11 80       	push   $0x801109c0
80101567:	ff 75 08             	pushl  0x8(%ebp)
8010156a:	e8 f1 fe ff ff       	call   80101460 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010156f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101575:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010157b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101581:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101587:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010158d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101593:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101599:	68 38 71 10 80       	push   $0x80107138
8010159e:	e8 0d f1 ff ff       	call   801006b0 <cprintf>
}
801015a3:	83 c4 30             	add    $0x30,%esp
801015a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015a9:	c9                   	leave  
801015aa:	c3                   	ret    
801015ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015af:	90                   	nop

801015b0 <ialloc>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 1c             	sub    $0x1c,%esp
801015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015bc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015c3:	8b 75 08             	mov    0x8(%ebp),%esi
801015c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015c9:	0f 86 91 00 00 00    	jbe    80101660 <ialloc+0xb0>
801015cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015d4:	eb 21                	jmp    801015f7 <ialloc+0x47>
801015d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801015e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015e6:	57                   	push   %edi
801015e7:	e8 04 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
801015f5:	73 69                	jae    80101660 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015f7:	89 d8                	mov    %ebx,%eax
801015f9:	83 ec 08             	sub    $0x8,%esp
801015fc:	c1 e8 03             	shr    $0x3,%eax
801015ff:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101605:	50                   	push   %eax
80101606:	56                   	push   %esi
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010160c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010160f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101611:	89 d8                	mov    %ebx,%eax
80101613:	83 e0 07             	and    $0x7,%eax
80101616:	c1 e0 06             	shl    $0x6,%eax
80101619:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010161d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101621:	75 bd                	jne    801015e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101623:	83 ec 04             	sub    $0x4,%esp
80101626:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101629:	6a 40                	push   $0x40
8010162b:	6a 00                	push   $0x0
8010162d:	51                   	push   %ecx
8010162e:	e8 2d 2f 00 00       	call   80104560 <memset>
      dip->type = type;
80101633:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010163a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010163d:	89 3c 24             	mov    %edi,(%esp)
80101640:	e8 3b 18 00 00       	call   80102e80 <log_write>
      brelse(bp);
80101645:	89 3c 24             	mov    %edi,(%esp)
80101648:	e8 a3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010164d:	83 c4 10             	add    $0x10,%esp
}
80101650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101653:	89 da                	mov    %ebx,%edx
80101655:	89 f0                	mov    %esi,%eax
}
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5f                   	pop    %edi
8010165a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010165b:	e9 40 fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
80101660:	83 ec 0c             	sub    $0xc,%esp
80101663:	68 d8 70 10 80       	push   $0x801070d8
80101668:	e8 23 ed ff ff       	call   80100390 <panic>
8010166d:	8d 76 00             	lea    0x0(%esi),%esi

80101670 <iupdate>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101678:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010167e:	83 ec 08             	sub    $0x8,%esp
80101681:	c1 e8 03             	shr    $0x3,%eax
80101684:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010168a:	50                   	push   %eax
8010168b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010168e:	e8 3d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101693:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101697:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010169a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010169c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010169f:	83 e0 07             	and    $0x7,%eax
801016a2:	c1 e0 06             	shl    $0x6,%eax
801016a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cd:	6a 34                	push   $0x34
801016cf:	53                   	push   %ebx
801016d0:	50                   	push   %eax
801016d1:	e8 2a 2f 00 00       	call   80104600 <memmove>
  log_write(bp);
801016d6:	89 34 24             	mov    %esi,(%esp)
801016d9:	e8 a2 17 00 00       	call   80102e80 <log_write>
  brelse(bp);
801016de:	89 75 08             	mov    %esi,0x8(%ebp)
801016e1:	83 c4 10             	add    $0x10,%esp
}
801016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5d                   	pop    %ebp
  brelse(bp);
801016ea:	e9 01 eb ff ff       	jmp    801001f0 <brelse>
801016ef:	90                   	nop

801016f0 <idup>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 10             	sub    $0x10,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	68 e0 09 11 80       	push   $0x801109e0
801016ff:	e8 ec 2c 00 00       	call   801043f0 <acquire>
  ip->ref++;
80101704:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101708:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010170f:	e8 fc 2d 00 00       	call   80104510 <release>
}
80101714:	89 d8                	mov    %ebx,%eax
80101716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101719:	c9                   	leave  
8010171a:	c3                   	ret    
8010171b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010171f:	90                   	nop

80101720 <ilock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101728:	85 db                	test   %ebx,%ebx
8010172a:	0f 84 b7 00 00 00    	je     801017e7 <ilock+0xc7>
80101730:	8b 53 08             	mov    0x8(%ebx),%edx
80101733:	85 d2                	test   %edx,%edx
80101735:	0f 8e ac 00 00 00    	jle    801017e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010173b:	83 ec 0c             	sub    $0xc,%esp
8010173e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101741:	50                   	push   %eax
80101742:	e8 d9 2a 00 00       	call   80104220 <acquiresleep>
  if(ip->valid == 0){
80101747:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	85 c0                	test   %eax,%eax
8010174f:	74 0f                	je     80101760 <ilock+0x40>
}
80101751:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101754:	5b                   	pop    %ebx
80101755:	5e                   	pop    %esi
80101756:	5d                   	pop    %ebp
80101757:	c3                   	ret    
80101758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010175f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	8b 43 04             	mov    0x4(%ebx),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	pushl  (%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101777:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177c:	8b 43 04             	mov    0x4(%ebx),%eax
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101789:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010178f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101793:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101797:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010179b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010179f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	50                   	push   %eax
801017b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017b7:	50                   	push   %eax
801017b8:	e8 43 2e 00 00       	call   80104600 <memmove>
    brelse(bp);
801017bd:	89 34 24             	mov    %esi,(%esp)
801017c0:	e8 2b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017c5:	83 c4 10             	add    $0x10,%esp
801017c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 77 ff ff ff    	jne    80101751 <ilock+0x31>
      panic("ilock: no type");
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	68 f0 70 10 80       	push   $0x801070f0
801017e2:	e8 a9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 ea 70 10 80       	push   $0x801070ea
801017ef:	e8 9c eb ff ff       	call   80100390 <panic>
801017f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ff:	90                   	nop

80101800 <iunlock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	74 28                	je     80101834 <iunlock+0x34>
8010180c:	83 ec 0c             	sub    $0xc,%esp
8010180f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101812:	56                   	push   %esi
80101813:	e8 a8 2a 00 00       	call   801042c0 <holdingsleep>
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	85 c0                	test   %eax,%eax
8010181d:	74 15                	je     80101834 <iunlock+0x34>
8010181f:	8b 43 08             	mov    0x8(%ebx),%eax
80101822:	85 c0                	test   %eax,%eax
80101824:	7e 0e                	jle    80101834 <iunlock+0x34>
  releasesleep(&ip->lock);
80101826:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010182f:	e9 4c 2a 00 00       	jmp    80104280 <releasesleep>
    panic("iunlock");
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	68 ff 70 10 80       	push   $0x801070ff
8010183c:	e8 4f eb ff ff       	call   80100390 <panic>
80101841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iput>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	57                   	push   %edi
80101854:	56                   	push   %esi
80101855:	53                   	push   %ebx
80101856:	83 ec 28             	sub    $0x28,%esp
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010185c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010185f:	57                   	push   %edi
80101860:	e8 bb 29 00 00       	call   80104220 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101865:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	85 d2                	test   %edx,%edx
8010186d:	74 07                	je     80101876 <iput+0x26>
8010186f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101874:	74 32                	je     801018a8 <iput+0x58>
  releasesleep(&ip->lock);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	57                   	push   %edi
8010187a:	e8 01 2a 00 00       	call   80104280 <releasesleep>
  acquire(&icache.lock);
8010187f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101886:	e8 65 2b 00 00       	call   801043f0 <acquire>
  ip->ref--;
8010188b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5f                   	pop    %edi
8010189f:	5d                   	pop    %ebp
  release(&icache.lock);
801018a0:	e9 6b 2c 00 00       	jmp    80104510 <release>
801018a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 e0 09 11 80       	push   $0x801109e0
801018b0:	e8 3b 2b 00 00       	call   801043f0 <acquire>
    int r = ip->ref;
801018b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018b8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018bf:	e8 4c 2c 00 00       	call   80104510 <release>
    if(r == 1){
801018c4:	83 c4 10             	add    $0x10,%esp
801018c7:	83 fe 01             	cmp    $0x1,%esi
801018ca:	75 aa                	jne    80101876 <iput+0x26>
801018cc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018d8:	89 cf                	mov    %ecx,%edi
801018da:	eb 0b                	jmp    801018e7 <iput+0x97>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018e0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018e3:	39 fe                	cmp    %edi,%esi
801018e5:	74 19                	je     80101900 <iput+0xb0>
    if(ip->addrs[i]){
801018e7:	8b 16                	mov    (%esi),%edx
801018e9:	85 d2                	test   %edx,%edx
801018eb:	74 f3                	je     801018e0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018ed:	8b 03                	mov    (%ebx),%eax
801018ef:	e8 ac fb ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
801018f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018fa:	eb e4                	jmp    801018e0 <iput+0x90>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101900:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101906:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101909:	85 c0                	test   %eax,%eax
8010190b:	75 33                	jne    80101940 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010190d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101910:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101917:	53                   	push   %ebx
80101918:	e8 53 fd ff ff       	call   80101670 <iupdate>
      ip->type = 0;
8010191d:	31 c0                	xor    %eax,%eax
8010191f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 45 fd ff ff       	call   80101670 <iupdate>
      ip->valid = 0;
8010192b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	e9 3c ff ff ff       	jmp    80101876 <iput+0x26>
8010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	50                   	push   %eax
80101944:	ff 33                	pushl  (%ebx)
80101946:	e8 85 e7 ff ff       	call   801000d0 <bread>
8010194b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010194e:	83 c4 10             	add    $0x10,%esp
80101951:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101957:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010195a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010195d:	89 cf                	mov    %ecx,%edi
8010195f:	eb 0e                	jmp    8010196f <iput+0x11f>
80101961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101968:	83 c6 04             	add    $0x4,%esi
8010196b:	39 f7                	cmp    %esi,%edi
8010196d:	74 11                	je     80101980 <iput+0x130>
      if(a[j])
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x118>
        bfree(ip->dev, a[j]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 24 fb ff ff       	call   801014a0 <bfree>
8010197c:	eb ea                	jmp    80101968 <iput+0x118>
8010197e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	ff 75 e4             	pushl  -0x1c(%ebp)
80101986:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101989:	e8 62 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010198e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101994:	8b 03                	mov    (%ebx),%eax
80101996:	e8 05 fb ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019a5:	00 00 00 
801019a8:	e9 60 ff ff ff       	jmp    8010190d <iput+0xbd>
801019ad:	8d 76 00             	lea    0x0(%esi),%esi

801019b0 <iunlockput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	53                   	push   %ebx
801019b4:	83 ec 10             	sub    $0x10,%esp
801019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ba:	53                   	push   %ebx
801019bb:	e8 40 fe ff ff       	call   80101800 <iunlock>
  iput(ip);
801019c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c9:	c9                   	leave  
  iput(ip);
801019ca:	e9 81 fe ff ff       	jmp    80101850 <iput>
801019cf:	90                   	nop

801019d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	8b 55 08             	mov    0x8(%ebp),%edx
801019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d9:	8b 0a                	mov    (%edx),%ecx
801019db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019de:	8b 4a 04             	mov    0x4(%edx),%ecx
801019e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019eb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019f3:	8b 52 58             	mov    0x58(%edx),%edx
801019f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ff:	90                   	nop

80101a00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a12:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a15:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a18:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a23:	0f 84 a7 00 00 00    	je     80101ad0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2c:	8b 40 58             	mov    0x58(%eax),%eax
80101a2f:	39 c6                	cmp    %eax,%esi
80101a31:	0f 87 ba 00 00 00    	ja     80101af1 <readi+0xf1>
80101a37:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a3a:	31 c9                	xor    %ecx,%ecx
80101a3c:	89 da                	mov    %ebx,%edx
80101a3e:	01 f2                	add    %esi,%edx
80101a40:	0f 92 c1             	setb   %cl
80101a43:	89 cf                	mov    %ecx,%edi
80101a45:	0f 82 a6 00 00 00    	jb     80101af1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a4b:	89 c1                	mov    %eax,%ecx
80101a4d:	29 f1                	sub    %esi,%ecx
80101a4f:	39 d0                	cmp    %edx,%eax
80101a51:	0f 43 cb             	cmovae %ebx,%ecx
80101a54:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	85 c9                	test   %ecx,%ecx
80101a59:	74 67                	je     80101ac2 <readi+0xc2>
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a63:	89 f2                	mov    %esi,%edx
80101a65:	c1 ea 09             	shr    $0x9,%edx
80101a68:	89 d8                	mov    %ebx,%eax
80101a6a:	e8 21 f9 ff ff       	call   80101390 <bmap>
80101a6f:	83 ec 08             	sub    $0x8,%esp
80101a72:	50                   	push   %eax
80101a73:	ff 33                	pushl  (%ebx)
80101a75:	e8 56 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a7d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a82:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a85:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a87:	89 f0                	mov    %esi,%eax
80101a89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a8e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a93:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a95:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a99:	39 d9                	cmp    %ebx,%ecx
80101a9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a9f:	01 df                	add    %ebx,%edi
80101aa1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa3:	50                   	push   %eax
80101aa4:	ff 75 e0             	pushl  -0x20(%ebp)
80101aa7:	e8 54 2b 00 00       	call   80104600 <memmove>
    brelse(bp);
80101aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aaf:	89 14 24             	mov    %edx,(%esp)
80101ab2:	e8 39 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ac0:	77 9e                	ja     80101a60 <readi+0x60>
  }
  return n;
80101ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5f                   	pop    %edi
80101acb:	5d                   	pop    %ebp
80101acc:	c3                   	ret    
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf1>
80101ada:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb cd                	jmp    80101ac5 <readi+0xc5>
80101af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 b7 00 00 00    	je     80101be0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2f:	0f 82 e7 00 00 00    	jb     80101c1c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b38:	89 f8                	mov    %edi,%eax
80101b3a:	01 f0                	add    %esi,%eax
80101b3c:	0f 82 da 00 00 00    	jb     80101c1c <writei+0x11c>
80101b42:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b47:	0f 87 cf 00 00 00    	ja     80101c1c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b54:	85 ff                	test   %edi,%edi
80101b56:	74 79                	je     80101bd1 <writei+0xd1>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	e8 21 f8 ff ff       	call   80101390 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 37                	pushl  (%edi)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b7f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b82:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b85:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	89 f0                	mov    %esi,%eax
80101b89:	83 c4 0c             	add    $0xc,%esp
80101b8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	39 d9                	cmp    %ebx,%ecx
80101b99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b9c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b9d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b9f:	ff 75 dc             	pushl  -0x24(%ebp)
80101ba2:	50                   	push   %eax
80101ba3:	e8 58 2a 00 00       	call   80104600 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 d0 12 00 00       	call   80102e80 <log_write>
    brelse(bp);
80101bb0:	89 3c 24             	mov    %edi,(%esp)
80101bb3:	e8 38 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bbb:	83 c4 10             	add    $0x10,%esp
80101bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bc7:	77 97                	ja     80101b60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	77 37                	ja     80101c08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd7:	5b                   	pop    %ebx
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 32                	ja     80101c1c <writei+0x11c>
80101bea:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 27                	je     80101c1c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bff:	ff e0                	jmp    *%eax
80101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c11:	50                   	push   %eax
80101c12:	e8 59 fa ff ff       	call   80101670 <iupdate>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	eb b5                	jmp    80101bd1 <writei+0xd1>
      return -1;
80101c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c21:	eb b1                	jmp    80101bd4 <writei+0xd4>
80101c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c36:	6a 0e                	push   $0xe
80101c38:	ff 75 0c             	pushl  0xc(%ebp)
80101c3b:	ff 75 08             	pushl  0x8(%ebp)
80101c3e:	e8 2d 2a 00 00       	call   80104670 <strncmp>
}
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    
80101c45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c61:	0f 85 85 00 00 00    	jne    80101cec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 53 58             	mov    0x58(%ebx),%edx
80101c6a:	31 ff                	xor    %edi,%edi
80101c6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 3e                	je     80101cb1 <dirlookup+0x61>
80101c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c78:	6a 10                	push   $0x10
80101c7a:	57                   	push   %edi
80101c7b:	56                   	push   %esi
80101c7c:	53                   	push   %ebx
80101c7d:	e8 7e fd ff ff       	call   80101a00 <readi>
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	83 f8 10             	cmp    $0x10,%eax
80101c88:	75 55                	jne    80101cdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c8f:	74 18                	je     80101ca9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c91:	83 ec 04             	sub    $0x4,%esp
80101c94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c97:	6a 0e                	push   $0xe
80101c99:	50                   	push   %eax
80101c9a:	ff 75 0c             	pushl  0xc(%ebp)
80101c9d:	e8 ce 29 00 00       	call   80104670 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 17                	je     80101cc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca9:	83 c7 10             	add    $0x10,%edi
80101cac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101caf:	72 c7                	jb     80101c78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cb4:	31 c0                	xor    %eax,%eax
}
80101cb6:	5b                   	pop    %ebx
80101cb7:	5e                   	pop    %esi
80101cb8:	5f                   	pop    %edi
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop
      if(poff)
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	85 c0                	test   %eax,%eax
80101cc5:	74 05                	je     80101ccc <dirlookup+0x7c>
        *poff = off;
80101cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ccc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cd0:	8b 03                	mov    (%ebx),%eax
80101cd2:	e8 c9 f5 ff ff       	call   801012a0 <iget>
}
80101cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cda:	5b                   	pop    %ebx
80101cdb:	5e                   	pop    %esi
80101cdc:	5f                   	pop    %edi
80101cdd:	5d                   	pop    %ebp
80101cde:	c3                   	ret    
      panic("dirlookup read");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 19 71 10 80       	push   $0x80107119
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 07 71 10 80       	push   $0x80107107
80101cf4:	e8 97 e6 ff ff       	call   80100390 <panic>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 c3                	mov    %eax,%ebx
80101d08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d0e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d14:	0f 84 86 01 00 00    	je     80101ea0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d1a:	e8 c1 1b 00 00       	call   801038e0 <myproc>
  acquire(&icache.lock);
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d24:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d27:	68 e0 09 11 80       	push   $0x801109e0
80101d2c:	e8 bf 26 00 00       	call   801043f0 <acquire>
  ip->ref++;
80101d31:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d35:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d3c:	e8 cf 27 00 00       	call   80104510 <release>
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	eb 0d                	jmp    80101d53 <namex+0x53>
80101d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d50:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d53:	0f b6 07             	movzbl (%edi),%eax
80101d56:	3c 2f                	cmp    $0x2f,%al
80101d58:	74 f6                	je     80101d50 <namex+0x50>
  if(*path == 0)
80101d5a:	84 c0                	test   %al,%al
80101d5c:	0f 84 ee 00 00 00    	je     80101e50 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d62:	0f b6 07             	movzbl (%edi),%eax
80101d65:	84 c0                	test   %al,%al
80101d67:	0f 84 fb 00 00 00    	je     80101e68 <namex+0x168>
80101d6d:	89 fb                	mov    %edi,%ebx
80101d6f:	3c 2f                	cmp    $0x2f,%al
80101d71:	0f 84 f1 00 00 00    	je     80101e68 <namex+0x168>
80101d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7e:	66 90                	xchg   %ax,%ax
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d83:	0f b6 03             	movzbl (%ebx),%eax
80101d86:	3c 2f                	cmp    $0x2f,%al
80101d88:	74 04                	je     80101d8e <namex+0x8e>
80101d8a:	84 c0                	test   %al,%al
80101d8c:	75 f2                	jne    80101d80 <namex+0x80>
  len = path - s;
80101d8e:	89 d8                	mov    %ebx,%eax
80101d90:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d92:	83 f8 0d             	cmp    $0xd,%eax
80101d95:	0f 8e 85 00 00 00    	jle    80101e20 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d9b:	83 ec 04             	sub    $0x4,%esp
80101d9e:	6a 0e                	push   $0xe
80101da0:	57                   	push   %edi
    path++;
80101da1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101da3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101da6:	e8 55 28 00 00       	call   80104600 <memmove>
80101dab:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dae:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db1:	75 0d                	jne    80101dc0 <namex+0xc0>
80101db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101db7:	90                   	nop
    path++;
80101db8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dbb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dbe:	74 f8                	je     80101db8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 57 f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101dc9:	83 c4 10             	add    $0x10,%esp
80101dcc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dd1:	0f 85 a1 00 00 00    	jne    80101e78 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dda:	85 d2                	test   %edx,%edx
80101ddc:	74 09                	je     80101de7 <namex+0xe7>
80101dde:	80 3f 00             	cmpb   $0x0,(%edi)
80101de1:	0f 84 d9 00 00 00    	je     80101ec0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101de7:	83 ec 04             	sub    $0x4,%esp
80101dea:	6a 00                	push   $0x0
80101dec:	ff 75 e4             	pushl  -0x1c(%ebp)
80101def:	56                   	push   %esi
80101df0:	e8 5b fe ff ff       	call   80101c50 <dirlookup>
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	89 c3                	mov    %eax,%ebx
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	74 7a                	je     80101e78 <namex+0x178>
  iunlock(ip);
80101dfe:	83 ec 0c             	sub    $0xc,%esp
80101e01:	56                   	push   %esi
80101e02:	e8 f9 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e07:	89 34 24             	mov    %esi,(%esp)
80101e0a:	89 de                	mov    %ebx,%esi
80101e0c:	e8 3f fa ff ff       	call   80101850 <iput>
  while(*path == '/')
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	e9 3a ff ff ff       	jmp    80101d53 <namex+0x53>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e26:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e29:	83 ec 04             	sub    $0x4,%esp
80101e2c:	50                   	push   %eax
80101e2d:	57                   	push   %edi
    name[len] = 0;
80101e2e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e30:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e33:	e8 c8 27 00 00       	call   80104600 <memmove>
    name[len] = 0;
80101e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e3b:	83 c4 10             	add    $0x10,%esp
80101e3e:	c6 00 00             	movb   $0x0,(%eax)
80101e41:	e9 68 ff ff ff       	jmp    80101dae <namex+0xae>
80101e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 85 00 00 00    	jne    80101ee0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5e:	89 f0                	mov    %esi,%eax
80101e60:	5b                   	pop    %ebx
80101e61:	5e                   	pop    %esi
80101e62:	5f                   	pop    %edi
80101e63:	5d                   	pop    %ebp
80101e64:	c3                   	ret    
80101e65:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e6b:	89 fb                	mov    %edi,%ebx
80101e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e70:	31 c0                	xor    %eax,%eax
80101e72:	eb b5                	jmp    80101e29 <namex+0x129>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	56                   	push   %esi
80101e7c:	e8 7f f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e81:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e84:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e86:	e8 c5 f9 ff ff       	call   80101850 <iput>
      return 0;
80101e8b:	83 c4 10             	add    $0x10,%esp
}
80101e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e91:	89 f0                	mov    %esi,%eax
80101e93:	5b                   	pop    %ebx
80101e94:	5e                   	pop    %esi
80101e95:	5f                   	pop    %edi
80101e96:	5d                   	pop    %ebp
80101e97:	c3                   	ret    
80101e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101ea0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eaa:	89 df                	mov    %ebx,%edi
80101eac:	e8 ef f3 ff ff       	call   801012a0 <iget>
80101eb1:	89 c6                	mov    %eax,%esi
80101eb3:	e9 9b fe ff ff       	jmp    80101d53 <namex+0x53>
80101eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebf:	90                   	nop
      iunlock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 37 f9 ff ff       	call   80101800 <iunlock>
      return ip;
80101ec9:	83 c4 10             	add    $0x10,%esp
}
80101ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecf:	89 f0                	mov    %esi,%eax
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
80101ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	56                   	push   %esi
    return 0;
80101ee4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ee6:	e8 65 f9 ff ff       	call   80101850 <iput>
    return 0;
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	e9 68 ff ff ff       	jmp    80101e5b <namex+0x15b>
80101ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f00 <dirlink>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	83 ec 20             	sub    $0x20,%esp
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0c:	6a 00                	push   $0x0
80101f0e:	ff 75 0c             	pushl  0xc(%ebp)
80101f11:	53                   	push   %ebx
80101f12:	e8 39 fd ff ff       	call   80101c50 <dirlookup>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	75 67                	jne    80101f85 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f24:	85 ff                	test   %edi,%edi
80101f26:	74 29                	je     80101f51 <dirlink+0x51>
80101f28:	31 ff                	xor    %edi,%edi
80101f2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2d:	eb 09                	jmp    80101f38 <dirlink+0x38>
80101f2f:	90                   	nop
80101f30:	83 c7 10             	add    $0x10,%edi
80101f33:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f36:	73 19                	jae    80101f51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 be fa ff ff       	call   80101a00 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 4e                	jne    80101f98 <dirlink+0x98>
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	75 df                	jne    80101f30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f51:	83 ec 04             	sub    $0x4,%esp
80101f54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f57:	6a 0e                	push   $0xe
80101f59:	ff 75 0c             	pushl  0xc(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	e8 6e 27 00 00       	call   801046d0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f62:	6a 10                	push   $0x10
  de.inum = inum;
80101f64:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f67:	57                   	push   %edi
80101f68:	56                   	push   %esi
80101f69:	53                   	push   %ebx
  de.inum = inum;
80101f6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6e:	e8 8d fb ff ff       	call   80101b00 <writei>
80101f73:	83 c4 20             	add    $0x20,%esp
80101f76:	83 f8 10             	cmp    $0x10,%eax
80101f79:	75 2a                	jne    80101fa5 <dirlink+0xa5>
  return 0;
80101f7b:	31 c0                	xor    %eax,%eax
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
    iput(ip);
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	50                   	push   %eax
80101f89:	e8 c2 f8 ff ff       	call   80101850 <iput>
    return -1;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	eb e5                	jmp    80101f7d <dirlink+0x7d>
      panic("dirlink read");
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	68 28 71 10 80       	push   $0x80107128
80101fa0:	e8 eb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 26 77 10 80       	push   $0x80107726
80101fad:	e8 de e3 ff ff       	call   80100390 <panic>
80101fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fc0 <namei>:

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 2d fd ff ff       	call   80101d00 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fef:	e9 0c fd ff ff       	jmp    80101d00 <namex>
80101ff4:	66 90                	xchg   %ax,%ax
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	66 90                	xchg   %ax,%ax
80101ffa:	66 90                	xchg   %ax,%ax
80101ffc:	66 90                	xchg   %ax,%ax
80101ffe:	66 90                	xchg   %ax,%ax

80102000 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102009:	85 c0                	test   %eax,%eax
8010200b:	0f 84 b4 00 00 00    	je     801020c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102011:	8b 70 08             	mov    0x8(%eax),%esi
80102014:	89 c3                	mov    %eax,%ebx
80102016:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010201c:	0f 87 96 00 00 00    	ja     801020b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202e:	66 90                	xchg   %ax,%ax
80102030:	89 ca                	mov    %ecx,%edx
80102032:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102033:	83 e0 c0             	and    $0xffffffc0,%eax
80102036:	3c 40                	cmp    $0x40,%al
80102038:	75 f6                	jne    80102030 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010203a:	31 ff                	xor    %edi,%edi
8010203c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102041:	89 f8                	mov    %edi,%eax
80102043:	ee                   	out    %al,(%dx)
80102044:	b8 01 00 00 00       	mov    $0x1,%eax
80102049:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010204e:	ee                   	out    %al,(%dx)
8010204f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102054:	89 f0                	mov    %esi,%eax
80102056:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102057:	89 f0                	mov    %esi,%eax
80102059:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010205e:	c1 f8 08             	sar    $0x8,%eax
80102061:	ee                   	out    %al,(%dx)
80102062:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102067:	89 f8                	mov    %edi,%eax
80102069:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010206a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010206e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102073:	c1 e0 04             	shl    $0x4,%eax
80102076:	83 e0 10             	and    $0x10,%eax
80102079:	83 c8 e0             	or     $0xffffffe0,%eax
8010207c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010207d:	f6 03 04             	testb  $0x4,(%ebx)
80102080:	75 16                	jne    80102098 <idestart+0x98>
80102082:	b8 20 00 00 00       	mov    $0x20,%eax
80102087:	89 ca                	mov    %ecx,%edx
80102089:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010208a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208d:	5b                   	pop    %ebx
8010208e:	5e                   	pop    %esi
8010208f:	5f                   	pop    %edi
80102090:	5d                   	pop    %ebp
80102091:	c3                   	ret    
80102092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102098:	b8 30 00 00 00       	mov    $0x30,%eax
8010209d:	89 ca                	mov    %ecx,%edx
8010209f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ad:	fc                   	cld    
801020ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b3:	5b                   	pop    %ebx
801020b4:	5e                   	pop    %esi
801020b5:	5f                   	pop    %edi
801020b6:	5d                   	pop    %ebp
801020b7:	c3                   	ret    
    panic("incorrect blockno");
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 94 71 10 80       	push   $0x80107194
801020c0:	e8 cb e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 8b 71 10 80       	push   $0x8010718b
801020cd:	e8 be e2 ff ff       	call   80100390 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <ideinit>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020e6:	68 a6 71 10 80       	push   $0x801071a6
801020eb:	68 80 a5 10 80       	push   $0x8010a580
801020f0:	e8 fb 21 00 00       	call   801042f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020f5:	58                   	pop    %eax
801020f6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020fb:	5a                   	pop    %edx
801020fc:	83 e8 01             	sub    $0x1,%eax
801020ff:	50                   	push   %eax
80102100:	6a 0e                	push   $0xe
80102102:	e8 a9 02 00 00       	call   801023b0 <ioapicenable>
80102107:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010210a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210f:	90                   	nop
80102110:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102111:	83 e0 c0             	and    $0xffffffc0,%eax
80102114:	3c 40                	cmp    $0x40,%al
80102116:	75 f8                	jne    80102110 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102118:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010211d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102122:	ee                   	out    %al,(%dx)
80102123:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102128:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010212d:	eb 06                	jmp    80102135 <ideinit+0x55>
8010212f:	90                   	nop
  for(i=0; i<1000; i++){
80102130:	83 e9 01             	sub    $0x1,%ecx
80102133:	74 0f                	je     80102144 <ideinit+0x64>
80102135:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102136:	84 c0                	test   %al,%al
80102138:	74 f6                	je     80102130 <ideinit+0x50>
      havedisk1 = 1;
8010213a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102141:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102144:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102149:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010214e:	ee                   	out    %al,(%dx)
}
8010214f:	c9                   	leave  
80102150:	c3                   	ret    
80102151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215f:	90                   	nop

80102160 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102169:	68 80 a5 10 80       	push   $0x8010a580
8010216e:	e8 7d 22 00 00       	call   801043f0 <acquire>

  if((b = idequeue) == 0){
80102173:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	85 db                	test   %ebx,%ebx
8010217e:	74 63                	je     801021e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102180:	8b 43 58             	mov    0x58(%ebx),%eax
80102183:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102188:	8b 33                	mov    (%ebx),%esi
8010218a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102190:	75 2f                	jne    801021c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102192:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219e:	66 90                	xchg   %ax,%ax
801021a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a1:	89 c1                	mov    %eax,%ecx
801021a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021a6:	80 f9 40             	cmp    $0x40,%cl
801021a9:	75 f5                	jne    801021a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021ab:	a8 21                	test   $0x21,%al
801021ad:	75 12                	jne    801021c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021bc:	fc                   	cld    
801021bd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021bf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021c7:	83 ce 02             	or     $0x2,%esi
801021ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021cc:	53                   	push   %ebx
801021cd:	e8 6e 1e 00 00       	call   80104040 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021d2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	74 05                	je     801021e3 <ideintr+0x83>
    idestart(idequeue);
801021de:	e8 1d fe ff ff       	call   80102000 <idestart>
    release(&idelock);
801021e3:	83 ec 0c             	sub    $0xc,%esp
801021e6:	68 80 a5 10 80       	push   $0x8010a580
801021eb:	e8 20 23 00 00       	call   80104510 <release>

  release(&idelock);
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret    
801021f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ff:	90                   	nop

80102200 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	53                   	push   %ebx
80102204:	83 ec 10             	sub    $0x10,%esp
80102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010220a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010220d:	50                   	push   %eax
8010220e:	e8 ad 20 00 00       	call   801042c0 <holdingsleep>
80102213:	83 c4 10             	add    $0x10,%esp
80102216:	85 c0                	test   %eax,%eax
80102218:	0f 84 d3 00 00 00    	je     801022f1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 e0 06             	and    $0x6,%eax
80102223:	83 f8 02             	cmp    $0x2,%eax
80102226:	0f 84 b8 00 00 00    	je     801022e4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010222c:	8b 53 04             	mov    0x4(%ebx),%edx
8010222f:	85 d2                	test   %edx,%edx
80102231:	74 0d                	je     80102240 <iderw+0x40>
80102233:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102238:	85 c0                	test   %eax,%eax
8010223a:	0f 84 97 00 00 00    	je     801022d7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102240:	83 ec 0c             	sub    $0xc,%esp
80102243:	68 80 a5 10 80       	push   $0x8010a580
80102248:	e8 a3 21 00 00       	call   801043f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102253:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	85 d2                	test   %edx,%edx
8010225f:	75 09                	jne    8010226a <iderw+0x6a>
80102261:	eb 6d                	jmp    801022d0 <iderw+0xd0>
80102263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102267:	90                   	nop
80102268:	89 c2                	mov    %eax,%edx
8010226a:	8b 42 58             	mov    0x58(%edx),%eax
8010226d:	85 c0                	test   %eax,%eax
8010226f:	75 f7                	jne    80102268 <iderw+0x68>
80102271:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102274:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102276:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010227c:	74 42                	je     801022c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010227e:	8b 03                	mov    (%ebx),%eax
80102280:	83 e0 06             	and    $0x6,%eax
80102283:	83 f8 02             	cmp    $0x2,%eax
80102286:	74 23                	je     801022ab <iderw+0xab>
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop
    sleep(b, &idelock);
80102290:	83 ec 08             	sub    $0x8,%esp
80102293:	68 80 a5 10 80       	push   $0x8010a580
80102298:	53                   	push   %ebx
80102299:	e8 f2 1b 00 00       	call   80103e90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010229e:	8b 03                	mov    (%ebx),%eax
801022a0:	83 c4 10             	add    $0x10,%esp
801022a3:	83 e0 06             	and    $0x6,%eax
801022a6:	83 f8 02             	cmp    $0x2,%eax
801022a9:	75 e5                	jne    80102290 <iderw+0x90>
  }


  release(&idelock);
801022ab:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022b5:	c9                   	leave  
  release(&idelock);
801022b6:	e9 55 22 00 00       	jmp    80104510 <release>
801022bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop
    idestart(b);
801022c0:	89 d8                	mov    %ebx,%eax
801022c2:	e8 39 fd ff ff       	call   80102000 <idestart>
801022c7:	eb b5                	jmp    8010227e <iderw+0x7e>
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022d5:	eb 9d                	jmp    80102274 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	68 d5 71 10 80       	push   $0x801071d5
801022df:	e8 ac e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 c0 71 10 80       	push   $0x801071c0
801022ec:	e8 9f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022f1:	83 ec 0c             	sub    $0xc,%esp
801022f4:	68 aa 71 10 80       	push   $0x801071aa
801022f9:	e8 92 e0 ff ff       	call   80100390 <panic>
801022fe:	66 90                	xchg   %ax,%ax

80102300 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102300:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102301:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102308:	00 c0 fe 
{
8010230b:	89 e5                	mov    %esp,%ebp
8010230d:	56                   	push   %esi
8010230e:	53                   	push   %ebx
  ioapic->reg = reg;
8010230f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102316:	00 00 00 
  return ioapic->data;
80102319:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010231f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102322:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102328:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010232e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102335:	c1 ee 10             	shr    $0x10,%esi
80102338:	89 f0                	mov    %esi,%eax
8010233a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010233d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102340:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102343:	39 c2                	cmp    %eax,%edx
80102345:	74 16                	je     8010235d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102347:	83 ec 0c             	sub    $0xc,%esp
8010234a:	68 f4 71 10 80       	push   $0x801071f4
8010234f:	e8 5c e3 ff ff       	call   801006b0 <cprintf>
80102354:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010235a:	83 c4 10             	add    $0x10,%esp
8010235d:	83 c6 21             	add    $0x21,%esi
{
80102360:	ba 10 00 00 00       	mov    $0x10,%edx
80102365:	b8 20 00 00 00       	mov    $0x20,%eax
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102370:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102372:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102374:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010237a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010237d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102383:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102386:	8d 5a 01             	lea    0x1(%edx),%ebx
80102389:	83 c2 02             	add    $0x2,%edx
8010238c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010238e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102394:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010239b:	39 f0                	cmp    %esi,%eax
8010239d:	75 d1                	jne    80102370 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010239f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5e                   	pop    %esi
801023a4:	5d                   	pop    %ebp
801023a5:	c3                   	ret    
801023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ad:	8d 76 00             	lea    0x0(%esi),%esi

801023b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023b0:	55                   	push   %ebp
  ioapic->reg = reg;
801023b1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023b7:	89 e5                	mov    %esp,%ebp
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023bc:	8d 50 20             	lea    0x20(%eax),%edx
801023bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023d6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023de:	89 50 10             	mov    %edx,0x10(%eax)
}
801023e1:	5d                   	pop    %ebp
801023e2:	c3                   	ret    
801023e3:	66 90                	xchg   %ax,%ax
801023e5:	66 90                	xchg   %ax,%ax
801023e7:	66 90                	xchg   %ax,%ax
801023e9:	66 90                	xchg   %ax,%ax
801023eb:	66 90                	xchg   %ax,%ax
801023ed:	66 90                	xchg   %ax,%ax
801023ef:	90                   	nop

801023f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
801023f4:	83 ec 04             	sub    $0x4,%esp
801023f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102400:	75 76                	jne    80102478 <kfree+0x88>
80102402:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102408:	72 6e                	jb     80102478 <kfree+0x88>
8010240a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102410:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102415:	77 61                	ja     80102478 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102417:	83 ec 04             	sub    $0x4,%esp
8010241a:	68 00 10 00 00       	push   $0x1000
8010241f:	6a 01                	push   $0x1
80102421:	53                   	push   %ebx
80102422:	e8 39 21 00 00       	call   80104560 <memset>

  if(kmem.use_lock)
80102427:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	85 d2                	test   %edx,%edx
80102432:	75 1c                	jne    80102450 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102434:	a1 78 26 11 80       	mov    0x80112678,%eax
80102439:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010243b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102440:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102446:	85 c0                	test   %eax,%eax
80102448:	75 1e                	jne    80102468 <kfree+0x78>
    release(&kmem.lock);
}
8010244a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010244d:	c9                   	leave  
8010244e:	c3                   	ret    
8010244f:	90                   	nop
    acquire(&kmem.lock);
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	68 40 26 11 80       	push   $0x80112640
80102458:	e8 93 1f 00 00       	call   801043f0 <acquire>
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	eb d2                	jmp    80102434 <kfree+0x44>
80102462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102468:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010246f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102472:	c9                   	leave  
    release(&kmem.lock);
80102473:	e9 98 20 00 00       	jmp    80104510 <release>
    panic("kfree");
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	68 26 72 10 80       	push   $0x80107226
80102480:	e8 0b df ff ff       	call   80100390 <panic>
80102485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <freerange>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102494:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102497:	8b 75 0c             	mov    0xc(%ebp),%esi
8010249a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010249b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ad:	39 de                	cmp    %ebx,%esi
801024af:	72 23                	jb     801024d4 <freerange+0x44>
801024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024b8:	83 ec 0c             	sub    $0xc,%esp
801024bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024c7:	50                   	push   %eax
801024c8:	e8 23 ff ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	39 f3                	cmp    %esi,%ebx
801024d2:	76 e4                	jbe    801024b8 <freerange+0x28>
}
801024d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d7:	5b                   	pop    %ebx
801024d8:	5e                   	pop    %esi
801024d9:	5d                   	pop    %ebp
801024da:	c3                   	ret    
801024db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024df:	90                   	nop

801024e0 <kinit1>:
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	56                   	push   %esi
801024e4:	53                   	push   %ebx
801024e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024e8:	83 ec 08             	sub    $0x8,%esp
801024eb:	68 2c 72 10 80       	push   $0x8010722c
801024f0:	68 40 26 11 80       	push   $0x80112640
801024f5:	e8 f6 1d 00 00       	call   801042f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102500:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102507:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010250a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102510:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102516:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010251c:	39 de                	cmp    %ebx,%esi
8010251e:	72 1c                	jb     8010253c <kinit1+0x5c>
    kfree(p);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102529:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010252f:	50                   	push   %eax
80102530:	e8 bb fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102535:	83 c4 10             	add    $0x10,%esp
80102538:	39 de                	cmp    %ebx,%esi
8010253a:	73 e4                	jae    80102520 <kinit1+0x40>
}
8010253c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010253f:	5b                   	pop    %ebx
80102540:	5e                   	pop    %esi
80102541:	5d                   	pop    %ebp
80102542:	c3                   	ret    
80102543:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102550 <kinit2>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102554:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102557:	8b 75 0c             	mov    0xc(%ebp),%esi
8010255a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010255b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102561:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102567:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010256d:	39 de                	cmp    %ebx,%esi
8010256f:	72 23                	jb     80102594 <kinit2+0x44>
80102571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102587:	50                   	push   %eax
80102588:	e8 63 fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	39 de                	cmp    %ebx,%esi
80102592:	73 e4                	jae    80102578 <kinit2+0x28>
  kmem.use_lock = 1;
80102594:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010259b:	00 00 00 
}
8010259e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a1:	5b                   	pop    %ebx
801025a2:	5e                   	pop    %esi
801025a3:	5d                   	pop    %ebp
801025a4:	c3                   	ret    
801025a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025bc:	85 c0                	test   %eax,%eax
801025be:	75 20                	jne    801025e0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025c6:	85 db                	test   %ebx,%ebx
801025c8:	74 07                	je     801025d1 <kalloc+0x21>
    kmem.freelist = r->next;
801025ca:	8b 03                	mov    (%ebx),%eax
801025cc:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025d1:	89 d8                	mov    %ebx,%eax
801025d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d6:	c9                   	leave  
801025d7:	c3                   	ret    
801025d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop
    acquire(&kmem.lock);
801025e0:	83 ec 0c             	sub    $0xc,%esp
801025e3:	68 40 26 11 80       	push   $0x80112640
801025e8:	e8 03 1e 00 00       	call   801043f0 <acquire>
  r = kmem.freelist;
801025ed:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	a1 74 26 11 80       	mov    0x80112674,%eax
801025fb:	85 db                	test   %ebx,%ebx
801025fd:	74 08                	je     80102607 <kalloc+0x57>
    kmem.freelist = r->next;
801025ff:	8b 13                	mov    (%ebx),%edx
80102601:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102607:	85 c0                	test   %eax,%eax
80102609:	74 c6                	je     801025d1 <kalloc+0x21>
    release(&kmem.lock);
8010260b:	83 ec 0c             	sub    $0xc,%esp
8010260e:	68 40 26 11 80       	push   $0x80112640
80102613:	e8 f8 1e 00 00       	call   80104510 <release>
}
80102618:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010261a:	83 c4 10             	add    $0x10,%esp
}
8010261d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102620:	c9                   	leave  
80102621:	c3                   	ret    
80102622:	66 90                	xchg   %ax,%ax
80102624:	66 90                	xchg   %ax,%ax
80102626:	66 90                	xchg   %ax,%ax
80102628:	66 90                	xchg   %ax,%ax
8010262a:	66 90                	xchg   %ax,%ax
8010262c:	66 90                	xchg   %ax,%ax
8010262e:	66 90                	xchg   %ax,%ax

80102630 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102630:	ba 64 00 00 00       	mov    $0x64,%edx
80102635:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102636:	a8 01                	test   $0x1,%al
80102638:	0f 84 c2 00 00 00    	je     80102700 <kbdgetc+0xd0>
{
8010263e:	55                   	push   %ebp
8010263f:	ba 60 00 00 00       	mov    $0x60,%edx
80102644:	89 e5                	mov    %esp,%ebp
80102646:	53                   	push   %ebx
80102647:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102648:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010264b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102651:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102657:	74 57                	je     801026b0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102659:	89 d9                	mov    %ebx,%ecx
8010265b:	83 e1 40             	and    $0x40,%ecx
8010265e:	84 c0                	test   %al,%al
80102660:	78 5e                	js     801026c0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102662:	85 c9                	test   %ecx,%ecx
80102664:	74 09                	je     8010266f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102666:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102669:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010266c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010266f:	0f b6 8a 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%ecx
  shift ^= togglecode[data];
80102676:	0f b6 82 60 72 10 80 	movzbl -0x7fef8da0(%edx),%eax
  shift |= shiftcode[data];
8010267d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010267f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102681:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102683:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102689:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010268c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010268f:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
80102696:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010269a:	74 0b                	je     801026a7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010269c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010269f:	83 fa 19             	cmp    $0x19,%edx
801026a2:	77 44                	ja     801026e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026a4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026a7:	5b                   	pop    %ebx
801026a8:	5d                   	pop    %ebp
801026a9:	c3                   	ret    
801026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026b0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026b3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026b5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026bb:	5b                   	pop    %ebx
801026bc:	5d                   	pop    %ebp
801026bd:	c3                   	ret    
801026be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026c0:	83 e0 7f             	and    $0x7f,%eax
801026c3:	85 c9                	test   %ecx,%ecx
801026c5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026c8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026ca:	0f b6 8a 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%ecx
801026d1:	83 c9 40             	or     $0x40,%ecx
801026d4:	0f b6 c9             	movzbl %cl,%ecx
801026d7:	f7 d1                	not    %ecx
801026d9:	21 d9                	and    %ebx,%ecx
}
801026db:	5b                   	pop    %ebx
801026dc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026dd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026e3:	c3                   	ret    
801026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801026ee:	5b                   	pop    %ebx
801026ef:	5d                   	pop    %ebp
      c += 'a' - 'A';
801026f0:	83 f9 1a             	cmp    $0x1a,%ecx
801026f3:	0f 42 c2             	cmovb  %edx,%eax
}
801026f6:	c3                   	ret    
801026f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fe:	66 90                	xchg   %ax,%ax
    return -1;
80102700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102705:	c3                   	ret    
80102706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010270d:	8d 76 00             	lea    0x0(%esi),%esi

80102710 <kbdintr>:

void
kbdintr(void)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102716:	68 30 26 10 80       	push   $0x80102630
8010271b:	e8 40 e1 ff ff       	call   80100860 <consoleintr>
}
80102720:	83 c4 10             	add    $0x10,%esp
80102723:	c9                   	leave  
80102724:	c3                   	ret    
80102725:	66 90                	xchg   %ax,%ax
80102727:	66 90                	xchg   %ax,%ax
80102729:	66 90                	xchg   %ax,%ax
8010272b:	66 90                	xchg   %ax,%ax
8010272d:	66 90                	xchg   %ax,%ax
8010272f:	90                   	nop

80102730 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102730:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102735:	85 c0                	test   %eax,%eax
80102737:	0f 84 cb 00 00 00    	je     80102808 <lapicinit+0xd8>
  lapic[index] = value;
8010273d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102744:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102751:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102757:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010275e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102761:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102764:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010276b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010276e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102771:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102778:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010277b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010277e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102785:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102788:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010278b:	8b 50 30             	mov    0x30(%eax),%edx
8010278e:	c1 ea 10             	shr    $0x10,%edx
80102791:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102797:	75 77                	jne    80102810 <lapicinit+0xe0>
  lapic[index] = value;
80102799:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 50 20             	mov    0x20(%eax),%edx
801027e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ee:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027f6:	80 e6 10             	and    $0x10,%dh
801027f9:	75 f5                	jne    801027f0 <lapicinit+0xc0>
  lapic[index] = value;
801027fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102802:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102808:	c3                   	ret    
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102810:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102817:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281a:	8b 50 20             	mov    0x20(%eax),%edx
8010281d:	e9 77 ff ff ff       	jmp    80102799 <lapicinit+0x69>
80102822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102830 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102830:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	74 07                	je     80102840 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102839:	8b 40 20             	mov    0x20(%eax),%eax
8010283c:	c1 e8 18             	shr    $0x18,%eax
8010283f:	c3                   	ret    
    return 0;
80102840:	31 c0                	xor    %eax,%eax
}
80102842:	c3                   	ret    
80102843:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102850 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102850:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	74 0d                	je     80102866 <lapiceoi+0x16>
  lapic[index] = value;
80102859:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102866:	c3                   	ret    
80102867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286e:	66 90                	xchg   %ax,%ax

80102870 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102870:	c3                   	ret    
80102871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop

80102880 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102880:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102881:	b8 0f 00 00 00       	mov    $0xf,%eax
80102886:	ba 70 00 00 00       	mov    $0x70,%edx
8010288b:	89 e5                	mov    %esp,%ebp
8010288d:	53                   	push   %ebx
8010288e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102891:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102894:	ee                   	out    %al,(%dx)
80102895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010289a:	ba 71 00 00 00       	mov    $0x71,%edx
8010289f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028ad:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801028b0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801028b2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801028b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028be:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102901:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102907:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102908:	8b 40 20             	mov    0x20(%eax),%eax
}
8010290b:	5d                   	pop    %ebp
8010290c:	c3                   	ret    
8010290d:	8d 76 00             	lea    0x0(%esi),%esi

80102910 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102910:	55                   	push   %ebp
80102911:	b8 0b 00 00 00       	mov    $0xb,%eax
80102916:	ba 70 00 00 00       	mov    $0x70,%edx
8010291b:	89 e5                	mov    %esp,%ebp
8010291d:	57                   	push   %edi
8010291e:	56                   	push   %esi
8010291f:	53                   	push   %ebx
80102920:	83 ec 4c             	sub    $0x4c,%esp
80102923:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102924:	ba 71 00 00 00       	mov    $0x71,%edx
80102929:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010292a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102932:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102935:	8d 76 00             	lea    0x0(%esi),%esi
80102938:	31 c0                	xor    %eax,%eax
8010293a:	89 da                	mov    %ebx,%edx
8010293c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102942:	89 ca                	mov    %ecx,%edx
80102944:	ec                   	in     (%dx),%al
80102945:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102948:	89 da                	mov    %ebx,%edx
8010294a:	b8 02 00 00 00       	mov    $0x2,%eax
8010294f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
80102953:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 da                	mov    %ebx,%edx
80102958:	b8 04 00 00 00       	mov    $0x4,%eax
8010295d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295e:	89 ca                	mov    %ecx,%edx
80102960:	ec                   	in     (%dx),%al
80102961:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102964:	89 da                	mov    %ebx,%edx
80102966:	b8 07 00 00 00       	mov    $0x7,%eax
8010296b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296c:	89 ca                	mov    %ecx,%edx
8010296e:	ec                   	in     (%dx),%al
8010296f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102972:	89 da                	mov    %ebx,%edx
80102974:	b8 08 00 00 00       	mov    $0x8,%eax
80102979:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297a:	89 ca                	mov    %ecx,%edx
8010297c:	ec                   	in     (%dx),%al
8010297d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010297f:	89 da                	mov    %ebx,%edx
80102981:	b8 09 00 00 00       	mov    $0x9,%eax
80102986:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102987:	89 ca                	mov    %ecx,%edx
80102989:	ec                   	in     (%dx),%al
8010298a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010298c:	89 da                	mov    %ebx,%edx
8010298e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102993:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102994:	89 ca                	mov    %ecx,%edx
80102996:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102997:	84 c0                	test   %al,%al
80102999:	78 9d                	js     80102938 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010299b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010299f:	89 fa                	mov    %edi,%edx
801029a1:	0f b6 fa             	movzbl %dl,%edi
801029a4:	89 f2                	mov    %esi,%edx
801029a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029a9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029ad:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b0:	89 da                	mov    %ebx,%edx
801029b2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801029b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029b8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029bc:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029c9:	31 c0                	xor    %eax,%eax
801029cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cc:	89 ca                	mov    %ecx,%edx
801029ce:	ec                   	in     (%dx),%al
801029cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029d7:	b8 02 00 00 00       	mov    $0x2,%eax
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	89 ca                	mov    %ecx,%edx
801029df:	ec                   	in     (%dx),%al
801029e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e3:	89 da                	mov    %ebx,%edx
801029e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029e8:	b8 04 00 00 00       	mov    $0x4,%eax
801029ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ee:	89 ca                	mov    %ecx,%edx
801029f0:	ec                   	in     (%dx),%al
801029f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f4:	89 da                	mov    %ebx,%edx
801029f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029f9:	b8 07 00 00 00       	mov    $0x7,%eax
801029fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ff:	89 ca                	mov    %ecx,%edx
80102a01:	ec                   	in     (%dx),%al
80102a02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a05:	89 da                	mov    %ebx,%edx
80102a07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a21:	89 ca                	mov    %ecx,%edx
80102a23:	ec                   	in     (%dx),%al
80102a24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a30:	6a 18                	push   $0x18
80102a32:	50                   	push   %eax
80102a33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a36:	50                   	push   %eax
80102a37:	e8 74 1b 00 00       	call   801045b0 <memcmp>
80102a3c:	83 c4 10             	add    $0x10,%esp
80102a3f:	85 c0                	test   %eax,%eax
80102a41:	0f 85 f1 fe ff ff    	jne    80102938 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a4b:	75 78                	jne    80102ac5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a50:	89 c2                	mov    %eax,%edx
80102a52:	83 e0 0f             	and    $0xf,%eax
80102a55:	c1 ea 04             	shr    $0x4,%edx
80102a58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a64:	89 c2                	mov    %eax,%edx
80102a66:	83 e0 0f             	and    $0xf,%eax
80102a69:	c1 ea 04             	shr    $0x4,%edx
80102a6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a78:	89 c2                	mov    %eax,%edx
80102a7a:	83 e0 0f             	and    $0xf,%eax
80102a7d:	c1 ea 04             	shr    $0x4,%edx
80102a80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a8c:	89 c2                	mov    %eax,%edx
80102a8e:	83 e0 0f             	and    $0xf,%eax
80102a91:	c1 ea 04             	shr    $0x4,%edx
80102a94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102aa0:	89 c2                	mov    %eax,%edx
80102aa2:	83 e0 0f             	and    $0xf,%eax
80102aa5:	c1 ea 04             	shr    $0x4,%edx
80102aa8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ab1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ab4:	89 c2                	mov    %eax,%edx
80102ab6:	83 e0 0f             	and    $0xf,%eax
80102ab9:	c1 ea 04             	shr    $0x4,%edx
80102abc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102abf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ac2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102acb:	89 06                	mov    %eax,(%esi)
80102acd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ad0:	89 46 04             	mov    %eax,0x4(%esi)
80102ad3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ad6:	89 46 08             	mov    %eax,0x8(%esi)
80102ad9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102adc:	89 46 0c             	mov    %eax,0xc(%esi)
80102adf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ae2:	89 46 10             	mov    %eax,0x10(%esi)
80102ae5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ae8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102aeb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102af2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102af5:	5b                   	pop    %ebx
80102af6:	5e                   	pop    %esi
80102af7:	5f                   	pop    %edi
80102af8:	5d                   	pop    %ebp
80102af9:	c3                   	ret    
80102afa:	66 90                	xchg   %ax,%ax
80102afc:	66 90                	xchg   %ax,%ax
80102afe:	66 90                	xchg   %ax,%ax

80102b00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b00:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b06:	85 c9                	test   %ecx,%ecx
80102b08:	0f 8e 8a 00 00 00    	jle    80102b98 <install_trans+0x98>
{
80102b0e:	55                   	push   %ebp
80102b0f:	89 e5                	mov    %esp,%ebp
80102b11:	57                   	push   %edi
80102b12:	56                   	push   %esi
80102b13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b14:	31 db                	xor    %ebx,%ebx
{
80102b16:	83 ec 0c             	sub    $0xc,%esp
80102b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b25:	83 ec 08             	sub    $0x8,%esp
80102b28:	01 d8                	add    %ebx,%eax
80102b2a:	83 c0 01             	add    $0x1,%eax
80102b2d:	50                   	push   %eax
80102b2e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b34:	e8 97 d5 ff ff       	call   801000d0 <bread>
80102b39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b3b:	58                   	pop    %eax
80102b3c:	5a                   	pop    %edx
80102b3d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b44:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b4d:	e8 7e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b52:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b55:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b57:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b5a:	68 00 02 00 00       	push   $0x200
80102b5f:	50                   	push   %eax
80102b60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b63:	50                   	push   %eax
80102b64:	e8 97 1a 00 00       	call   80104600 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b69:	89 34 24             	mov    %esi,(%esp)
80102b6c:	e8 3f d6 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102b71:	89 3c 24             	mov    %edi,(%esp)
80102b74:	e8 77 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102b79:	89 34 24             	mov    %esi,(%esp)
80102b7c:	e8 6f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b81:	83 c4 10             	add    $0x10,%esp
80102b84:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102b8a:	7f 94                	jg     80102b20 <install_trans+0x20>
  }
}
80102b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8f:	5b                   	pop    %ebx
80102b90:	5e                   	pop    %esi
80102b91:	5f                   	pop    %edi
80102b92:	5d                   	pop    %ebp
80102b93:	c3                   	ret    
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b98:	c3                   	ret    
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ba0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	53                   	push   %ebx
80102ba4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ba7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102bad:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bb3:	e8 18 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102bb8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bbb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102bbd:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bc2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	7e 19                	jle    80102be2 <write_head+0x42>
80102bc9:	31 d2                	xor    %edx,%edx
80102bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102bd0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102bd7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102bdb:	83 c2 01             	add    $0x1,%edx
80102bde:	39 d0                	cmp    %edx,%eax
80102be0:	75 ee                	jne    80102bd0 <write_head+0x30>
  }
  bwrite(buf);
80102be2:	83 ec 0c             	sub    $0xc,%esp
80102be5:	53                   	push   %ebx
80102be6:	e8 c5 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102beb:	89 1c 24             	mov    %ebx,(%esp)
80102bee:	e8 fd d5 ff ff       	call   801001f0 <brelse>
}
80102bf3:	83 c4 10             	add    $0x10,%esp
80102bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bf9:	c9                   	leave  
80102bfa:	c3                   	ret    
80102bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bff:	90                   	nop

80102c00 <initlog>:
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	53                   	push   %ebx
80102c04:	83 ec 2c             	sub    $0x2c,%esp
80102c07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c0a:	68 60 74 10 80       	push   $0x80107460
80102c0f:	68 80 26 11 80       	push   $0x80112680
80102c14:	e8 d7 16 00 00       	call   801042f0 <initlock>
  readsb(dev, &sb);
80102c19:	58                   	pop    %eax
80102c1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c1d:	5a                   	pop    %edx
80102c1e:	50                   	push   %eax
80102c1f:	53                   	push   %ebx
80102c20:	e8 3b e8 ff ff       	call   80101460 <readsb>
  log.start = sb.logstart;
80102c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c28:	59                   	pop    %ecx
  log.dev = dev;
80102c29:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c32:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c37:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c3d:	5a                   	pop    %edx
80102c3e:	50                   	push   %eax
80102c3f:	53                   	push   %ebx
80102c40:	e8 8b d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c45:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c48:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c4b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c51:	85 c9                	test   %ecx,%ecx
80102c53:	7e 1d                	jle    80102c72 <initlog+0x72>
80102c55:	31 d2                	xor    %edx,%edx
80102c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c60:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c64:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d1                	cmp    %edx,%ecx
80102c70:	75 ee                	jne    80102c60 <initlog+0x60>
  brelse(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	50                   	push   %eax
80102c76:	e8 75 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c7b:	e8 80 fe ff ff       	call   80102b00 <install_trans>
  log.lh.n = 0;
80102c80:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c87:	00 00 00 
  write_head(); // clear the log
80102c8a:	e8 11 ff ff ff       	call   80102ba0 <write_head>
}
80102c8f:	83 c4 10             	add    $0x10,%esp
80102c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c95:	c9                   	leave  
80102c96:	c3                   	ret    
80102c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c9e:	66 90                	xchg   %ax,%ax

80102ca0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ca6:	68 80 26 11 80       	push   $0x80112680
80102cab:	e8 40 17 00 00       	call   801043f0 <acquire>
80102cb0:	83 c4 10             	add    $0x10,%esp
80102cb3:	eb 18                	jmp    80102ccd <begin_op+0x2d>
80102cb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102cb8:	83 ec 08             	sub    $0x8,%esp
80102cbb:	68 80 26 11 80       	push   $0x80112680
80102cc0:	68 80 26 11 80       	push   $0x80112680
80102cc5:	e8 c6 11 00 00       	call   80103e90 <sleep>
80102cca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ccd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102cd2:	85 c0                	test   %eax,%eax
80102cd4:	75 e2                	jne    80102cb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cd6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cdb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ce1:	83 c0 01             	add    $0x1,%eax
80102ce4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ce7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cea:	83 fa 1e             	cmp    $0x1e,%edx
80102ced:	7f c9                	jg     80102cb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102cef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102cf2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102cf7:	68 80 26 11 80       	push   $0x80112680
80102cfc:	e8 0f 18 00 00       	call   80104510 <release>
      break;
    }
  }
}
80102d01:	83 c4 10             	add    $0x10,%esp
80102d04:	c9                   	leave  
80102d05:	c3                   	ret    
80102d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d0d:	8d 76 00             	lea    0x0(%esi),%esi

80102d10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	57                   	push   %edi
80102d14:	56                   	push   %esi
80102d15:	53                   	push   %ebx
80102d16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d19:	68 80 26 11 80       	push   $0x80112680
80102d1e:	e8 cd 16 00 00       	call   801043f0 <acquire>
  log.outstanding -= 1;
80102d23:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d28:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d31:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d34:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d3a:	85 f6                	test   %esi,%esi
80102d3c:	0f 85 22 01 00 00    	jne    80102e64 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d42:	85 db                	test   %ebx,%ebx
80102d44:	0f 85 f6 00 00 00    	jne    80102e40 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d4a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d51:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d54:	83 ec 0c             	sub    $0xc,%esp
80102d57:	68 80 26 11 80       	push   $0x80112680
80102d5c:	e8 af 17 00 00       	call   80104510 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d61:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d67:	83 c4 10             	add    $0x10,%esp
80102d6a:	85 c9                	test   %ecx,%ecx
80102d6c:	7f 42                	jg     80102db0 <end_op+0xa0>
    acquire(&log.lock);
80102d6e:	83 ec 0c             	sub    $0xc,%esp
80102d71:	68 80 26 11 80       	push   $0x80112680
80102d76:	e8 75 16 00 00       	call   801043f0 <acquire>
    wakeup(&log);
80102d7b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d82:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d89:	00 00 00 
    wakeup(&log);
80102d8c:	e8 af 12 00 00       	call   80104040 <wakeup>
    release(&log.lock);
80102d91:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d98:	e8 73 17 00 00       	call   80104510 <release>
80102d9d:	83 c4 10             	add    $0x10,%esp
}
80102da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102da3:	5b                   	pop    %ebx
80102da4:	5e                   	pop    %esi
80102da5:	5f                   	pop    %edi
80102da6:	5d                   	pop    %ebp
80102da7:	c3                   	ret    
80102da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102daf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102db0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102db5:	83 ec 08             	sub    $0x8,%esp
80102db8:	01 d8                	add    %ebx,%eax
80102dba:	83 c0 01             	add    $0x1,%eax
80102dbd:	50                   	push   %eax
80102dbe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102dc4:	e8 07 d3 ff ff       	call   801000d0 <bread>
80102dc9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dcb:	58                   	pop    %eax
80102dcc:	5a                   	pop    %edx
80102dcd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102dd4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dda:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ddd:	e8 ee d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102de2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102de5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102de7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dea:	68 00 02 00 00       	push   $0x200
80102def:	50                   	push   %eax
80102df0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102df3:	50                   	push   %eax
80102df4:	e8 07 18 00 00       	call   80104600 <memmove>
    bwrite(to);  // write the log
80102df9:	89 34 24             	mov    %esi,(%esp)
80102dfc:	e8 af d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e01:	89 3c 24             	mov    %edi,(%esp)
80102e04:	e8 e7 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 df d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e1a:	7c 94                	jl     80102db0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e1c:	e8 7f fd ff ff       	call   80102ba0 <write_head>
    install_trans(); // Now install writes to home locations
80102e21:	e8 da fc ff ff       	call   80102b00 <install_trans>
    log.lh.n = 0;
80102e26:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e2d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e30:	e8 6b fd ff ff       	call   80102ba0 <write_head>
80102e35:	e9 34 ff ff ff       	jmp    80102d6e <end_op+0x5e>
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	68 80 26 11 80       	push   $0x80112680
80102e48:	e8 f3 11 00 00       	call   80104040 <wakeup>
  release(&log.lock);
80102e4d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e54:	e8 b7 16 00 00       	call   80104510 <release>
80102e59:	83 c4 10             	add    $0x10,%esp
}
80102e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5f:	5b                   	pop    %ebx
80102e60:	5e                   	pop    %esi
80102e61:	5f                   	pop    %edi
80102e62:	5d                   	pop    %ebp
80102e63:	c3                   	ret    
    panic("log.committing");
80102e64:	83 ec 0c             	sub    $0xc,%esp
80102e67:	68 64 74 10 80       	push   $0x80107464
80102e6c:	e8 1f d5 ff ff       	call   80100390 <panic>
80102e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop

80102e80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e87:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102e8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e90:	83 fa 1d             	cmp    $0x1d,%edx
80102e93:	0f 8f 94 00 00 00    	jg     80102f2d <log_write+0xad>
80102e99:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e9e:	83 e8 01             	sub    $0x1,%eax
80102ea1:	39 c2                	cmp    %eax,%edx
80102ea3:	0f 8d 84 00 00 00    	jge    80102f2d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ea9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102eae:	85 c0                	test   %eax,%eax
80102eb0:	0f 8e 84 00 00 00    	jle    80102f3a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102eb6:	83 ec 0c             	sub    $0xc,%esp
80102eb9:	68 80 26 11 80       	push   $0x80112680
80102ebe:	e8 2d 15 00 00       	call   801043f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ec3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ec9:	83 c4 10             	add    $0x10,%esp
80102ecc:	85 d2                	test   %edx,%edx
80102ece:	7e 51                	jle    80102f21 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ed0:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ed3:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ed5:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102edb:	75 0c                	jne    80102ee9 <log_write+0x69>
80102edd:	eb 39                	jmp    80102f18 <log_write+0x98>
80102edf:	90                   	nop
80102ee0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ee7:	74 2f                	je     80102f18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ee9:	83 c0 01             	add    $0x1,%eax
80102eec:	39 c2                	cmp    %eax,%edx
80102eee:	75 f0                	jne    80102ee0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ef0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ef7:	83 c2 01             	add    $0x1,%edx
80102efa:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f00:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f06:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f0d:	c9                   	leave  
  release(&log.lock);
80102f0e:	e9 fd 15 00 00       	jmp    80104510 <release>
80102f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f17:	90                   	nop
  log.lh.block[i] = b->blockno;
80102f18:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102f1f:	eb df                	jmp    80102f00 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102f21:	8b 43 08             	mov    0x8(%ebx),%eax
80102f24:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f29:	75 d5                	jne    80102f00 <log_write+0x80>
80102f2b:	eb ca                	jmp    80102ef7 <log_write+0x77>
    panic("too big a transaction");
80102f2d:	83 ec 0c             	sub    $0xc,%esp
80102f30:	68 73 74 10 80       	push   $0x80107473
80102f35:	e8 56 d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f3a:	83 ec 0c             	sub    $0xc,%esp
80102f3d:	68 89 74 10 80       	push   $0x80107489
80102f42:	e8 49 d4 ff ff       	call   80100390 <panic>
80102f47:	66 90                	xchg   %ax,%ax
80102f49:	66 90                	xchg   %ax,%ax
80102f4b:	66 90                	xchg   %ax,%ax
80102f4d:	66 90                	xchg   %ax,%ax
80102f4f:	90                   	nop

80102f50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f57:	e8 64 09 00 00       	call   801038c0 <cpuid>
80102f5c:	89 c3                	mov    %eax,%ebx
80102f5e:	e8 5d 09 00 00       	call   801038c0 <cpuid>
80102f63:	83 ec 04             	sub    $0x4,%esp
80102f66:	53                   	push   %ebx
80102f67:	50                   	push   %eax
80102f68:	68 a4 74 10 80       	push   $0x801074a4
80102f6d:	e8 3e d7 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102f72:	e8 79 28 00 00       	call   801057f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f77:	e8 c4 08 00 00       	call   80103840 <mycpu>
80102f7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f8a:	e8 11 0c 00 00       	call   80103ba0 <scheduler>
80102f8f:	90                   	nop

80102f90 <mpenter>:
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f96:	e8 55 39 00 00       	call   801068f0 <switchkvm>
  seginit();
80102f9b:	e8 c0 38 00 00       	call   80106860 <seginit>
  lapicinit();
80102fa0:	e8 8b f7 ff ff       	call   80102730 <lapicinit>
  mpmain();
80102fa5:	e8 a6 ff ff ff       	call   80102f50 <mpmain>
80102faa:	66 90                	xchg   %ax,%ax
80102fac:	66 90                	xchg   %ax,%ax
80102fae:	66 90                	xchg   %ax,%ax

80102fb0 <main>:
{
80102fb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102fba:	55                   	push   %ebp
80102fbb:	89 e5                	mov    %esp,%ebp
80102fbd:	53                   	push   %ebx
80102fbe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fbf:	83 ec 08             	sub    $0x8,%esp
80102fc2:	68 00 00 40 80       	push   $0x80400000
80102fc7:	68 a8 54 11 80       	push   $0x801154a8
80102fcc:	e8 0f f5 ff ff       	call   801024e0 <kinit1>
  kvmalloc();      // kernel page table
80102fd1:	e8 da 3d 00 00       	call   80106db0 <kvmalloc>
  mpinit();        // detect other processors
80102fd6:	e8 85 01 00 00       	call   80103160 <mpinit>
  lapicinit();     // interrupt controller
80102fdb:	e8 50 f7 ff ff       	call   80102730 <lapicinit>
  seginit();       // segment descriptors
80102fe0:	e8 7b 38 00 00       	call   80106860 <seginit>
  picinit();       // disable pic
80102fe5:	e8 46 03 00 00       	call   80103330 <picinit>
  ioapicinit();    // another interrupt controller
80102fea:	e8 11 f3 ff ff       	call   80102300 <ioapicinit>
  consoleinit();   // console hardware
80102fef:	e8 3c da ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80102ff4:	e8 27 2b 00 00       	call   80105b20 <uartinit>
  pinit();         // process table
80102ff9:	e8 22 08 00 00       	call   80103820 <pinit>
  tvinit();        // trap vectors
80102ffe:	e8 6d 27 00 00       	call   80105770 <tvinit>
  binit();         // buffer cache
80103003:	e8 38 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103008:	e8 d3 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
8010300d:	e8 ce f0 ff ff       	call   801020e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103012:	83 c4 0c             	add    $0xc,%esp
80103015:	68 8a 00 00 00       	push   $0x8a
8010301a:	68 8c a4 10 80       	push   $0x8010a48c
8010301f:	68 00 70 00 80       	push   $0x80007000
80103024:	e8 d7 15 00 00       	call   80104600 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103033:	00 00 00 
80103036:	05 80 27 11 80       	add    $0x80112780,%eax
8010303b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103040:	76 7e                	jbe    801030c0 <main+0x110>
80103042:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103047:	eb 20                	jmp    80103069 <main+0xb9>
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103050:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103057:	00 00 00 
8010305a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103060:	05 80 27 11 80       	add    $0x80112780,%eax
80103065:	39 c3                	cmp    %eax,%ebx
80103067:	73 57                	jae    801030c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103069:	e8 d2 07 00 00       	call   80103840 <mycpu>
8010306e:	39 d8                	cmp    %ebx,%eax
80103070:	74 de                	je     80103050 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103072:	e8 39 f5 ff ff       	call   801025b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103077:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010307a:	c7 05 f8 6f 00 80 90 	movl   $0x80102f90,0x80006ff8
80103081:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103084:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010308b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010308e:	05 00 10 00 00       	add    $0x1000,%eax
80103093:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103098:	0f b6 03             	movzbl (%ebx),%eax
8010309b:	68 00 70 00 00       	push   $0x7000
801030a0:	50                   	push   %eax
801030a1:	e8 da f7 ff ff       	call   80102880 <lapicstartap>
801030a6:	83 c4 10             	add    $0x10,%esp
801030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030b6:	85 c0                	test   %eax,%eax
801030b8:	74 f6                	je     801030b0 <main+0x100>
801030ba:	eb 94                	jmp    80103050 <main+0xa0>
801030bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030c0:	83 ec 08             	sub    $0x8,%esp
801030c3:	68 00 00 00 8e       	push   $0x8e000000
801030c8:	68 00 00 40 80       	push   $0x80400000
801030cd:	e8 7e f4 ff ff       	call   80102550 <kinit2>
  userinit();      // first user process
801030d2:	e8 39 08 00 00       	call   80103910 <userinit>
  mpmain();        // finish this processor's setup
801030d7:	e8 74 fe ff ff       	call   80102f50 <mpmain>
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030eb:	53                   	push   %ebx
  e = addr+len;
801030ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030f2:	39 de                	cmp    %ebx,%esi
801030f4:	72 10                	jb     80103106 <mpsearch1+0x26>
801030f6:	eb 50                	jmp    80103148 <mpsearch1+0x68>
801030f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop
80103100:	89 fe                	mov    %edi,%esi
80103102:	39 fb                	cmp    %edi,%ebx
80103104:	76 42                	jbe    80103148 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103106:	83 ec 04             	sub    $0x4,%esp
80103109:	8d 7e 10             	lea    0x10(%esi),%edi
8010310c:	6a 04                	push   $0x4
8010310e:	68 b8 74 10 80       	push   $0x801074b8
80103113:	56                   	push   %esi
80103114:	e8 97 14 00 00       	call   801045b0 <memcmp>
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	85 c0                	test   %eax,%eax
8010311e:	75 e0                	jne    80103100 <mpsearch1+0x20>
80103120:	89 f1                	mov    %esi,%ecx
80103122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103128:	0f b6 11             	movzbl (%ecx),%edx
8010312b:	83 c1 01             	add    $0x1,%ecx
8010312e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103130:	39 f9                	cmp    %edi,%ecx
80103132:	75 f4                	jne    80103128 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103134:	84 c0                	test   %al,%al
80103136:	75 c8                	jne    80103100 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103138:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010313b:	89 f0                	mov    %esi,%eax
8010313d:	5b                   	pop    %ebx
8010313e:	5e                   	pop    %esi
8010313f:	5f                   	pop    %edi
80103140:	5d                   	pop    %ebp
80103141:	c3                   	ret    
80103142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010314b:	31 f6                	xor    %esi,%esi
}
8010314d:	5b                   	pop    %ebx
8010314e:	89 f0                	mov    %esi,%eax
80103150:	5e                   	pop    %esi
80103151:	5f                   	pop    %edi
80103152:	5d                   	pop    %ebp
80103153:	c3                   	ret    
80103154:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop

80103160 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103169:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103170:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103177:	c1 e0 08             	shl    $0x8,%eax
8010317a:	09 d0                	or     %edx,%eax
8010317c:	c1 e0 04             	shl    $0x4,%eax
8010317f:	75 1b                	jne    8010319c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103181:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103188:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010318f:	c1 e0 08             	shl    $0x8,%eax
80103192:	09 d0                	or     %edx,%eax
80103194:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103197:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010319c:	ba 00 04 00 00       	mov    $0x400,%edx
801031a1:	e8 3a ff ff ff       	call   801030e0 <mpsearch1>
801031a6:	89 c7                	mov    %eax,%edi
801031a8:	85 c0                	test   %eax,%eax
801031aa:	0f 84 c0 00 00 00    	je     80103270 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031b0:	8b 5f 04             	mov    0x4(%edi),%ebx
801031b3:	85 db                	test   %ebx,%ebx
801031b5:	0f 84 d5 00 00 00    	je     80103290 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801031bb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031be:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801031c4:	6a 04                	push   $0x4
801031c6:	68 d5 74 10 80       	push   $0x801074d5
801031cb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031cf:	e8 dc 13 00 00       	call   801045b0 <memcmp>
801031d4:	83 c4 10             	add    $0x10,%esp
801031d7:	85 c0                	test   %eax,%eax
801031d9:	0f 85 b1 00 00 00    	jne    80103290 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
801031df:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031e6:	3c 01                	cmp    $0x1,%al
801031e8:	0f 95 c2             	setne  %dl
801031eb:	3c 04                	cmp    $0x4,%al
801031ed:	0f 95 c0             	setne  %al
801031f0:	20 c2                	and    %al,%dl
801031f2:	0f 85 98 00 00 00    	jne    80103290 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
801031f8:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
801031ff:	66 85 c9             	test   %cx,%cx
80103202:	74 21                	je     80103225 <mpinit+0xc5>
80103204:	89 d8                	mov    %ebx,%eax
80103206:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103209:	31 d2                	xor    %edx,%edx
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
    sum += addr[i];
80103210:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103217:	83 c0 01             	add    $0x1,%eax
8010321a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010321c:	39 c6                	cmp    %eax,%esi
8010321e:	75 f0                	jne    80103210 <mpinit+0xb0>
80103220:	84 d2                	test   %dl,%dl
80103222:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103225:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103228:	85 c9                	test   %ecx,%ecx
8010322a:	74 64                	je     80103290 <mpinit+0x130>
8010322c:	84 d2                	test   %dl,%dl
8010322e:	75 60                	jne    80103290 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103230:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103236:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010323b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103242:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103248:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010324d:	01 d1                	add    %edx,%ecx
8010324f:	89 ce                	mov    %ecx,%esi
80103251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103258:	39 c6                	cmp    %eax,%esi
8010325a:	76 4b                	jbe    801032a7 <mpinit+0x147>
    switch(*p){
8010325c:	0f b6 10             	movzbl (%eax),%edx
8010325f:	80 fa 04             	cmp    $0x4,%dl
80103262:	0f 87 bf 00 00 00    	ja     80103327 <mpinit+0x1c7>
80103268:	ff 24 95 fc 74 10 80 	jmp    *-0x7fef8b04(,%edx,4)
8010326f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80103270:	ba 00 00 01 00       	mov    $0x10000,%edx
80103275:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010327a:	e8 61 fe ff ff       	call   801030e0 <mpsearch1>
8010327f:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103281:	85 c0                	test   %eax,%eax
80103283:	0f 85 27 ff ff ff    	jne    801031b0 <mpinit+0x50>
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103290:	83 ec 0c             	sub    $0xc,%esp
80103293:	68 bd 74 10 80       	push   $0x801074bd
80103298:	e8 f3 d0 ff ff       	call   80100390 <panic>
8010329d:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a3:	39 c6                	cmp    %eax,%esi
801032a5:	77 b5                	ja     8010325c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032a7:	85 db                	test   %ebx,%ebx
801032a9:	74 6f                	je     8010331a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032ab:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801032af:	74 15                	je     801032c6 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b1:	b8 70 00 00 00       	mov    $0x70,%eax
801032b6:	ba 22 00 00 00       	mov    $0x22,%edx
801032bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032bc:	ba 23 00 00 00       	mov    $0x23,%edx
801032c1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032c2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c5:	ee                   	out    %al,(%dx)
  }
}
801032c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032c9:	5b                   	pop    %ebx
801032ca:	5e                   	pop    %esi
801032cb:	5f                   	pop    %edi
801032cc:	5d                   	pop    %ebp
801032cd:	c3                   	ret    
801032ce:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801032d0:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
801032d6:	83 fa 07             	cmp    $0x7,%edx
801032d9:	7f 1f                	jg     801032fa <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032db:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801032e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801032e4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032e8:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
801032ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032f1:	83 c2 01             	add    $0x1,%edx
801032f4:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
801032fa:	83 c0 14             	add    $0x14,%eax
      continue;
801032fd:	e9 56 ff ff ff       	jmp    80103258 <mpinit+0xf8>
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103308:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010330c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010330f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103315:	e9 3e ff ff ff       	jmp    80103258 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010331a:	83 ec 0c             	sub    $0xc,%esp
8010331d:	68 dc 74 10 80       	push   $0x801074dc
80103322:	e8 69 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
80103327:	31 db                	xor    %ebx,%ebx
80103329:	e9 31 ff ff ff       	jmp    8010325f <mpinit+0xff>
8010332e:	66 90                	xchg   %ax,%ax

80103330 <picinit>:
80103330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103335:	ba 21 00 00 00       	mov    $0x21,%edx
8010333a:	ee                   	out    %al,(%dx)
8010333b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103340:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103341:	c3                   	ret    
80103342:	66 90                	xchg   %ax,%ax
80103344:	66 90                	xchg   %ax,%ax
80103346:	66 90                	xchg   %ax,%ax
80103348:	66 90                	xchg   %ax,%ax
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
80103355:	53                   	push   %ebx
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010335c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010335f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103365:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010336b:	e8 90 da ff ff       	call   80100e00 <filealloc>
80103370:	89 03                	mov    %eax,(%ebx)
80103372:	85 c0                	test   %eax,%eax
80103374:	0f 84 a8 00 00 00    	je     80103422 <pipealloc+0xd2>
8010337a:	e8 81 da ff ff       	call   80100e00 <filealloc>
8010337f:	89 06                	mov    %eax,(%esi)
80103381:	85 c0                	test   %eax,%eax
80103383:	0f 84 87 00 00 00    	je     80103410 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103389:	e8 22 f2 ff ff       	call   801025b0 <kalloc>
8010338e:	89 c7                	mov    %eax,%edi
80103390:	85 c0                	test   %eax,%eax
80103392:	0f 84 b0 00 00 00    	je     80103448 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103398:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010339f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801033a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033ac:	00 00 00 
  p->nwrite = 0;
801033af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033b6:	00 00 00 
  p->nread = 0;
801033b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033c0:	00 00 00 
  initlock(&p->lock, "pipe");
801033c3:	68 10 75 10 80       	push   $0x80107510
801033c8:	50                   	push   %eax
801033c9:	e8 22 0f 00 00       	call   801042f0 <initlock>
  (*f0)->type = FD_PIPE;
801033ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033d9:	8b 03                	mov    (%ebx),%eax
801033db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033df:	8b 03                	mov    (%ebx),%eax
801033e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033e5:	8b 03                	mov    (%ebx),%eax
801033e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033ea:	8b 06                	mov    (%esi),%eax
801033ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033f2:	8b 06                	mov    (%esi),%eax
801033f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033f8:	8b 06                	mov    (%esi),%eax
801033fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033fe:	8b 06                	mov    (%esi),%eax
80103400:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103406:	31 c0                	xor    %eax,%eax
}
80103408:	5b                   	pop    %ebx
80103409:	5e                   	pop    %esi
8010340a:	5f                   	pop    %edi
8010340b:	5d                   	pop    %ebp
8010340c:	c3                   	ret    
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103410:	8b 03                	mov    (%ebx),%eax
80103412:	85 c0                	test   %eax,%eax
80103414:	74 1e                	je     80103434 <pipealloc+0xe4>
    fileclose(*f0);
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	50                   	push   %eax
8010341a:	e8 a1 da ff ff       	call   80100ec0 <fileclose>
8010341f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103422:	8b 06                	mov    (%esi),%eax
80103424:	85 c0                	test   %eax,%eax
80103426:	74 0c                	je     80103434 <pipealloc+0xe4>
    fileclose(*f1);
80103428:	83 ec 0c             	sub    $0xc,%esp
8010342b:	50                   	push   %eax
8010342c:	e8 8f da ff ff       	call   80100ec0 <fileclose>
80103431:	83 c4 10             	add    $0x10,%esp
}
80103434:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010343c:	5b                   	pop    %ebx
8010343d:	5e                   	pop    %esi
8010343e:	5f                   	pop    %edi
8010343f:	5d                   	pop    %ebp
80103440:	c3                   	ret    
80103441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103448:	8b 03                	mov    (%ebx),%eax
8010344a:	85 c0                	test   %eax,%eax
8010344c:	75 c8                	jne    80103416 <pipealloc+0xc6>
8010344e:	eb d2                	jmp    80103422 <pipealloc+0xd2>

80103450 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	56                   	push   %esi
80103454:	53                   	push   %ebx
80103455:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103458:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010345b:	83 ec 0c             	sub    $0xc,%esp
8010345e:	53                   	push   %ebx
8010345f:	e8 8c 0f 00 00       	call   801043f0 <acquire>
  if(writable){
80103464:	83 c4 10             	add    $0x10,%esp
80103467:	85 f6                	test   %esi,%esi
80103469:	74 65                	je     801034d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010346b:	83 ec 0c             	sub    $0xc,%esp
8010346e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103474:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010347b:	00 00 00 
    wakeup(&p->nread);
8010347e:	50                   	push   %eax
8010347f:	e8 bc 0b 00 00       	call   80104040 <wakeup>
80103484:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103487:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010348d:	85 d2                	test   %edx,%edx
8010348f:	75 0a                	jne    8010349b <pipeclose+0x4b>
80103491:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103497:	85 c0                	test   %eax,%eax
80103499:	74 15                	je     801034b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010349b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010349e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a1:	5b                   	pop    %ebx
801034a2:	5e                   	pop    %esi
801034a3:	5d                   	pop    %ebp
    release(&p->lock);
801034a4:	e9 67 10 00 00       	jmp    80104510 <release>
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	53                   	push   %ebx
801034b4:	e8 57 10 00 00       	call   80104510 <release>
    kfree((char*)p);
801034b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034bc:	83 c4 10             	add    $0x10,%esp
}
801034bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034c2:	5b                   	pop    %ebx
801034c3:	5e                   	pop    %esi
801034c4:	5d                   	pop    %ebp
    kfree((char*)p);
801034c5:	e9 26 ef ff ff       	jmp    801023f0 <kfree>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801034d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034e0:	00 00 00 
    wakeup(&p->nwrite);
801034e3:	50                   	push   %eax
801034e4:	e8 57 0b 00 00       	call   80104040 <wakeup>
801034e9:	83 c4 10             	add    $0x10,%esp
801034ec:	eb 99                	jmp    80103487 <pipeclose+0x37>
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 28             	sub    $0x28,%esp
801034f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034fc:	53                   	push   %ebx
801034fd:	e8 ee 0e 00 00       	call   801043f0 <acquire>
  for(i = 0; i < n; i++){
80103502:	8b 45 10             	mov    0x10(%ebp),%eax
80103505:	83 c4 10             	add    $0x10,%esp
80103508:	85 c0                	test   %eax,%eax
8010350a:	0f 8e c8 00 00 00    	jle    801035d8 <pipewrite+0xe8>
80103510:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103513:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103519:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010351f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103522:	03 4d 10             	add    0x10(%ebp),%ecx
80103525:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103528:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010352e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103534:	39 d0                	cmp    %edx,%eax
80103536:	75 71                	jne    801035a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103538:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010353e:	85 c0                	test   %eax,%eax
80103540:	74 4e                	je     80103590 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103542:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103548:	eb 3a                	jmp    80103584 <pipewrite+0x94>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	57                   	push   %edi
80103554:	e8 e7 0a 00 00       	call   80104040 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103559:	5a                   	pop    %edx
8010355a:	59                   	pop    %ecx
8010355b:	53                   	push   %ebx
8010355c:	56                   	push   %esi
8010355d:	e8 2e 09 00 00       	call   80103e90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103562:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103568:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010356e:	83 c4 10             	add    $0x10,%esp
80103571:	05 00 02 00 00       	add    $0x200,%eax
80103576:	39 c2                	cmp    %eax,%edx
80103578:	75 36                	jne    801035b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010357a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103580:	85 c0                	test   %eax,%eax
80103582:	74 0c                	je     80103590 <pipewrite+0xa0>
80103584:	e8 57 03 00 00       	call   801038e0 <myproc>
80103589:	8b 40 24             	mov    0x24(%eax),%eax
8010358c:	85 c0                	test   %eax,%eax
8010358e:	74 c0                	je     80103550 <pipewrite+0x60>
        release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 77 0f 00 00       	call   80104510 <release>
        return -1;
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a4:	5b                   	pop    %ebx
801035a5:	5e                   	pop    %esi
801035a6:	5f                   	pop    %edi
801035a7:	5d                   	pop    %ebp
801035a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035a9:	89 c2                	mov    %eax,%edx
801035ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035af:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035b3:	8d 42 01             	lea    0x1(%edx),%eax
801035b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035c2:	0f b6 0e             	movzbl (%esi),%ecx
801035c5:	83 c6 01             	add    $0x1,%esi
801035c8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801035cb:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035cf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801035d2:	0f 85 50 ff ff ff    	jne    80103528 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035d8:	83 ec 0c             	sub    $0xc,%esp
801035db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035e1:	50                   	push   %eax
801035e2:	e8 59 0a 00 00       	call   80104040 <wakeup>
  release(&p->lock);
801035e7:	89 1c 24             	mov    %ebx,(%esp)
801035ea:	e8 21 0f 00 00       	call   80104510 <release>
  return n;
801035ef:	83 c4 10             	add    $0x10,%esp
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	eb aa                	jmp    801035a1 <pipewrite+0xb1>
801035f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035fe:	66 90                	xchg   %ax,%ax

80103600 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
80103606:	83 ec 18             	sub    $0x18,%esp
80103609:	8b 75 08             	mov    0x8(%ebp),%esi
8010360c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010360f:	56                   	push   %esi
80103610:	e8 db 0d 00 00       	call   801043f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103615:	83 c4 10             	add    $0x10,%esp
80103618:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010361e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103624:	75 6a                	jne    80103690 <piperead+0x90>
80103626:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010362c:	85 db                	test   %ebx,%ebx
8010362e:	0f 84 c4 00 00 00    	je     801036f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103634:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010363a:	eb 2d                	jmp    80103669 <piperead+0x69>
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103640:	83 ec 08             	sub    $0x8,%esp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	e8 46 08 00 00       	call   80103e90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010364a:	83 c4 10             	add    $0x10,%esp
8010364d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103653:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103659:	75 35                	jne    80103690 <piperead+0x90>
8010365b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103661:	85 d2                	test   %edx,%edx
80103663:	0f 84 8f 00 00 00    	je     801036f8 <piperead+0xf8>
    if(myproc()->killed){
80103669:	e8 72 02 00 00       	call   801038e0 <myproc>
8010366e:	8b 48 24             	mov    0x24(%eax),%ecx
80103671:	85 c9                	test   %ecx,%ecx
80103673:	74 cb                	je     80103640 <piperead+0x40>
      release(&p->lock);
80103675:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103678:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010367d:	56                   	push   %esi
8010367e:	e8 8d 0e 00 00       	call   80104510 <release>
      return -1;
80103683:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103686:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103689:	89 d8                	mov    %ebx,%eax
8010368b:	5b                   	pop    %ebx
8010368c:	5e                   	pop    %esi
8010368d:	5f                   	pop    %edi
8010368e:	5d                   	pop    %ebp
8010368f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103690:	8b 45 10             	mov    0x10(%ebp),%eax
80103693:	85 c0                	test   %eax,%eax
80103695:	7e 61                	jle    801036f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103697:	31 db                	xor    %ebx,%ebx
80103699:	eb 13                	jmp    801036ae <piperead+0xae>
8010369b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010369f:	90                   	nop
801036a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036ac:	74 1f                	je     801036cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036ae:	8d 41 01             	lea    0x1(%ecx),%eax
801036b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c5:	83 c3 01             	add    $0x1,%ebx
801036c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036cb:	75 d3                	jne    801036a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036cd:	83 ec 0c             	sub    $0xc,%esp
801036d0:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801036d6:	50                   	push   %eax
801036d7:	e8 64 09 00 00       	call   80104040 <wakeup>
  release(&p->lock);
801036dc:	89 34 24             	mov    %esi,(%esp)
801036df:	e8 2c 0e 00 00       	call   80104510 <release>
  return i;
801036e4:	83 c4 10             	add    $0x10,%esp
}
801036e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ea:	89 d8                	mov    %ebx,%eax
801036ec:	5b                   	pop    %ebx
801036ed:	5e                   	pop    %esi
801036ee:	5f                   	pop    %edi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801036f8:	31 db                	xor    %ebx,%ebx
801036fa:	eb d1                	jmp    801036cd <piperead+0xcd>
801036fc:	66 90                	xchg   %ax,%ax
801036fe:	66 90                	xchg   %ax,%ax

80103700 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103704:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103709:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010370c:	68 20 2d 11 80       	push   $0x80112d20
80103711:	e8 da 0c 00 00       	call   801043f0 <acquire>
80103716:	83 c4 10             	add    $0x10,%esp
80103719:	eb 10                	jmp    8010372b <allocproc+0x2b>
8010371b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103720:	83 c3 7c             	add    $0x7c,%ebx
80103723:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103729:	74 75                	je     801037a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010372b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010372e:	85 c0                	test   %eax,%eax
80103730:	75 ee                	jne    80103720 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103732:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103737:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010373a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103741:	89 43 10             	mov    %eax,0x10(%ebx)
80103744:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103747:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010374c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103752:	e8 b9 0d 00 00       	call   80104510 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103757:	e8 54 ee ff ff       	call   801025b0 <kalloc>
8010375c:	83 c4 10             	add    $0x10,%esp
8010375f:	89 43 08             	mov    %eax,0x8(%ebx)
80103762:	85 c0                	test   %eax,%eax
80103764:	74 53                	je     801037b9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103766:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010376c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010376f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103774:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103777:	c7 40 14 59 57 10 80 	movl   $0x80105759,0x14(%eax)
  p->context = (struct context*)sp;
8010377e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103781:	6a 14                	push   $0x14
80103783:	6a 00                	push   $0x0
80103785:	50                   	push   %eax
80103786:	e8 d5 0d 00 00       	call   80104560 <memset>
  p->context->eip = (uint)forkret;
8010378b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010378e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103791:	c7 40 10 d0 37 10 80 	movl   $0x801037d0,0x10(%eax)
}
80103798:	89 d8                	mov    %ebx,%eax
8010379a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010379d:	c9                   	leave  
8010379e:	c3                   	ret    
8010379f:	90                   	nop
  release(&ptable.lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037a5:	68 20 2d 11 80       	push   $0x80112d20
801037aa:	e8 61 0d 00 00       	call   80104510 <release>
}
801037af:	89 d8                	mov    %ebx,%eax
  return 0;
801037b1:	83 c4 10             	add    $0x10,%esp
}
801037b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037b7:	c9                   	leave  
801037b8:	c3                   	ret    
    p->state = UNUSED;
801037b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037c0:	31 db                	xor    %ebx,%ebx
}
801037c2:	89 d8                	mov    %ebx,%eax
801037c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037c7:	c9                   	leave  
801037c8:	c3                   	ret    
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037d6:	68 20 2d 11 80       	push   $0x80112d20
801037db:	e8 30 0d 00 00       	call   80104510 <release>

  if (first) {
801037e0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	85 c0                	test   %eax,%eax
801037ea:	75 04                	jne    801037f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037ec:	c9                   	leave  
801037ed:	c3                   	ret    
801037ee:	66 90                	xchg   %ax,%ax
    first = 0;
801037f0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037f7:	00 00 00 
    iinit(ROOTDEV);
801037fa:	83 ec 0c             	sub    $0xc,%esp
801037fd:	6a 01                	push   $0x1
801037ff:	e8 1c dd ff ff       	call   80101520 <iinit>
    initlog(ROOTDEV);
80103804:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010380b:	e8 f0 f3 ff ff       	call   80102c00 <initlog>
80103810:	83 c4 10             	add    $0x10,%esp
}
80103813:	c9                   	leave  
80103814:	c3                   	ret    
80103815:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103820 <pinit>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103826:	68 15 75 10 80       	push   $0x80107515
8010382b:	68 20 2d 11 80       	push   $0x80112d20
80103830:	e8 bb 0a 00 00       	call   801042f0 <initlock>
}
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	c9                   	leave  
80103839:	c3                   	ret    
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103840 <mycpu>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103845:	9c                   	pushf  
80103846:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103847:	f6 c4 02             	test   $0x2,%ah
8010384a:	75 5d                	jne    801038a9 <mycpu+0x69>
  apicid = lapicid();
8010384c:	e8 df ef ff ff       	call   80102830 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103851:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103857:	85 f6                	test   %esi,%esi
80103859:	7e 41                	jle    8010389c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
8010385b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103862:	39 d0                	cmp    %edx,%eax
80103864:	74 2f                	je     80103895 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103866:	31 d2                	xor    %edx,%edx
80103868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010386f:	90                   	nop
80103870:	83 c2 01             	add    $0x1,%edx
80103873:	39 f2                	cmp    %esi,%edx
80103875:	74 25                	je     8010389c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103877:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010387d:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
80103884:	39 c3                	cmp    %eax,%ebx
80103886:	75 e8                	jne    80103870 <mycpu+0x30>
80103888:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
8010388e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103891:	5b                   	pop    %ebx
80103892:	5e                   	pop    %esi
80103893:	5d                   	pop    %ebp
80103894:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103895:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010389a:	eb f2                	jmp    8010388e <mycpu+0x4e>
  panic("unknown apicid\n");
8010389c:	83 ec 0c             	sub    $0xc,%esp
8010389f:	68 1c 75 10 80       	push   $0x8010751c
801038a4:	e8 e7 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038a9:	83 ec 0c             	sub    $0xc,%esp
801038ac:	68 f8 75 10 80       	push   $0x801075f8
801038b1:	e8 da ca ff ff       	call   80100390 <panic>
801038b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bd:	8d 76 00             	lea    0x0(%esi),%esi

801038c0 <cpuid>:
cpuid() {
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038c6:	e8 75 ff ff ff       	call   80103840 <mycpu>
}
801038cb:	c9                   	leave  
  return mycpu()-cpus;
801038cc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801038d1:	c1 f8 04             	sar    $0x4,%eax
801038d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038da:	c3                   	ret    
801038db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038df:	90                   	nop

801038e0 <myproc>:
myproc(void) {
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
801038e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038e7:	e8 b4 0a 00 00       	call   801043a0 <pushcli>
  c = mycpu();
801038ec:	e8 4f ff ff ff       	call   80103840 <mycpu>
  p = c->proc;
801038f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038f7:	e8 b4 0b 00 00       	call   801044b0 <popcli>
}
801038fc:	83 c4 04             	add    $0x4,%esp
801038ff:	89 d8                	mov    %ebx,%eax
80103901:	5b                   	pop    %ebx
80103902:	5d                   	pop    %ebp
80103903:	c3                   	ret    
80103904:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010390b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010390f:	90                   	nop

80103910 <userinit>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
80103914:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103917:	e8 e4 fd ff ff       	call   80103700 <allocproc>
8010391c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010391e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103923:	e8 08 34 00 00       	call   80106d30 <setupkvm>
80103928:	89 43 04             	mov    %eax,0x4(%ebx)
8010392b:	85 c0                	test   %eax,%eax
8010392d:	0f 84 bd 00 00 00    	je     801039f0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103933:	83 ec 04             	sub    $0x4,%esp
80103936:	68 2c 00 00 00       	push   $0x2c
8010393b:	68 60 a4 10 80       	push   $0x8010a460
80103940:	50                   	push   %eax
80103941:	e8 ca 30 00 00       	call   80106a10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103946:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103949:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010394f:	6a 4c                	push   $0x4c
80103951:	6a 00                	push   $0x0
80103953:	ff 73 18             	pushl  0x18(%ebx)
80103956:	e8 05 0c 00 00       	call   80104560 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010395b:	8b 43 18             	mov    0x18(%ebx),%eax
8010395e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103963:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103966:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010396b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010396f:	8b 43 18             	mov    0x18(%ebx),%eax
80103972:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103976:	8b 43 18             	mov    0x18(%ebx),%eax
80103979:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010397d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103981:	8b 43 18             	mov    0x18(%ebx),%eax
80103984:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103988:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010398c:	8b 43 18             	mov    0x18(%ebx),%eax
8010398f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103996:	8b 43 18             	mov    0x18(%ebx),%eax
80103999:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039a0:	8b 43 18             	mov    0x18(%ebx),%eax
801039a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039aa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039ad:	6a 10                	push   $0x10
801039af:	68 45 75 10 80       	push   $0x80107545
801039b4:	50                   	push   %eax
801039b5:	e8 76 0d 00 00       	call   80104730 <safestrcpy>
  p->cwd = namei("/");
801039ba:	c7 04 24 4e 75 10 80 	movl   $0x8010754e,(%esp)
801039c1:	e8 fa e5 ff ff       	call   80101fc0 <namei>
801039c6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039c9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d0:	e8 1b 0a 00 00       	call   801043f0 <acquire>
  p->state = RUNNABLE;
801039d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801039dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039e3:	e8 28 0b 00 00       	call   80104510 <release>
}
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ee:	c9                   	leave  
801039ef:	c3                   	ret    
    panic("userinit: out of memory?");
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	68 2c 75 10 80       	push   $0x8010752c
801039f8:	e8 93 c9 ff ff       	call   80100390 <panic>
801039fd:	8d 76 00             	lea    0x0(%esi),%esi

80103a00 <growproc>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
80103a05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a08:	e8 93 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103a0d:	e8 2e fe ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103a12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a18:	e8 93 0a 00 00       	call   801044b0 <popcli>
  sz = curproc->sz;
80103a1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a1f:	85 f6                	test   %esi,%esi
80103a21:	7f 1d                	jg     80103a40 <growproc+0x40>
  } else if(n < 0){
80103a23:	75 3b                	jne    80103a60 <growproc+0x60>
  switchuvm(curproc);
80103a25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a2a:	53                   	push   %ebx
80103a2b:	e8 d0 2e 00 00       	call   80106900 <switchuvm>
  return 0;
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	31 c0                	xor    %eax,%eax
}
80103a35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a38:	5b                   	pop    %ebx
80103a39:	5e                   	pop    %esi
80103a3a:	5d                   	pop    %ebp
80103a3b:	c3                   	ret    
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a40:	83 ec 04             	sub    $0x4,%esp
80103a43:	01 c6                	add    %eax,%esi
80103a45:	56                   	push   %esi
80103a46:	50                   	push   %eax
80103a47:	ff 73 04             	pushl  0x4(%ebx)
80103a4a:	e8 01 31 00 00       	call   80106b50 <allocuvm>
80103a4f:	83 c4 10             	add    $0x10,%esp
80103a52:	85 c0                	test   %eax,%eax
80103a54:	75 cf                	jne    80103a25 <growproc+0x25>
      return -1;
80103a56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a5b:	eb d8                	jmp    80103a35 <growproc+0x35>
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a60:	83 ec 04             	sub    $0x4,%esp
80103a63:	01 c6                	add    %eax,%esi
80103a65:	56                   	push   %esi
80103a66:	50                   	push   %eax
80103a67:	ff 73 04             	pushl  0x4(%ebx)
80103a6a:	e8 11 32 00 00       	call   80106c80 <deallocuvm>
80103a6f:	83 c4 10             	add    $0x10,%esp
80103a72:	85 c0                	test   %eax,%eax
80103a74:	75 af                	jne    80103a25 <growproc+0x25>
80103a76:	eb de                	jmp    80103a56 <growproc+0x56>
80103a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7f:	90                   	nop

80103a80 <fork>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	57                   	push   %edi
80103a84:	56                   	push   %esi
80103a85:	53                   	push   %ebx
80103a86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a89:	e8 12 09 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103a8e:	e8 ad fd ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103a93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a99:	e8 12 0a 00 00       	call   801044b0 <popcli>
  if((np = allocproc()) == 0){
80103a9e:	e8 5d fc ff ff       	call   80103700 <allocproc>
80103aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aa6:	85 c0                	test   %eax,%eax
80103aa8:	0f 84 b7 00 00 00    	je     80103b65 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103aae:	83 ec 08             	sub    $0x8,%esp
80103ab1:	ff 33                	pushl  (%ebx)
80103ab3:	89 c7                	mov    %eax,%edi
80103ab5:	ff 73 04             	pushl  0x4(%ebx)
80103ab8:	e8 43 33 00 00       	call   80106e00 <copyuvm>
80103abd:	83 c4 10             	add    $0x10,%esp
80103ac0:	89 47 04             	mov    %eax,0x4(%edi)
80103ac3:	85 c0                	test   %eax,%eax
80103ac5:	0f 84 a1 00 00 00    	je     80103b6c <fork+0xec>
  np->sz = curproc->sz;
80103acb:	8b 03                	mov    (%ebx),%eax
80103acd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ad0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ad2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ad5:	89 c8                	mov    %ecx,%eax
80103ad7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103ada:	b9 13 00 00 00       	mov    $0x13,%ecx
80103adf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ae2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ae4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ae6:	8b 40 18             	mov    0x18(%eax),%eax
80103ae9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103af0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103af4:	85 c0                	test   %eax,%eax
80103af6:	74 13                	je     80103b0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	50                   	push   %eax
80103afc:	e8 6f d3 ff ff       	call   80100e70 <filedup>
80103b01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b04:	83 c4 10             	add    $0x10,%esp
80103b07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b0b:	83 c6 01             	add    $0x1,%esi
80103b0e:	83 fe 10             	cmp    $0x10,%esi
80103b11:	75 dd                	jne    80103af0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b13:	83 ec 0c             	sub    $0xc,%esp
80103b16:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b1c:	e8 cf db ff ff       	call   801016f0 <idup>
80103b21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b2d:	6a 10                	push   $0x10
80103b2f:	53                   	push   %ebx
80103b30:	50                   	push   %eax
80103b31:	e8 fa 0b 00 00       	call   80104730 <safestrcpy>
  pid = np->pid;
80103b36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b39:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b40:	e8 ab 08 00 00       	call   801043f0 <acquire>
  np->state = RUNNABLE;
80103b45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b53:	e8 b8 09 00 00       	call   80104510 <release>
  return pid;
80103b58:	83 c4 10             	add    $0x10,%esp
}
80103b5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b5e:	89 d8                	mov    %ebx,%eax
80103b60:	5b                   	pop    %ebx
80103b61:	5e                   	pop    %esi
80103b62:	5f                   	pop    %edi
80103b63:	5d                   	pop    %ebp
80103b64:	c3                   	ret    
    return -1;
80103b65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b6a:	eb ef                	jmp    80103b5b <fork+0xdb>
    kfree(np->kstack);
80103b6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b6f:	83 ec 0c             	sub    $0xc,%esp
80103b72:	ff 73 08             	pushl  0x8(%ebx)
80103b75:	e8 76 e8 ff ff       	call   801023f0 <kfree>
    np->kstack = 0;
80103b7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103b81:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103b84:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b90:	eb c9                	jmp    80103b5b <fork+0xdb>
80103b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <scheduler>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	57                   	push   %edi
80103ba4:	56                   	push   %esi
80103ba5:	53                   	push   %ebx
80103ba6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103ba9:	e8 92 fc ff ff       	call   80103840 <mycpu>
  c->proc = 0;
80103bae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103bb5:	00 00 00 
  struct cpu *c = mycpu();
80103bb8:	89 c6                	mov    %eax,%esi
  int ran = 0; // CS 350/550: to solve the 100%-CPU-utilization-when-idling problem
80103bba:	8d 78 04             	lea    0x4(%eax),%edi
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103bc0:	fb                   	sti    
    acquire(&ptable.lock);
80103bc1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bc4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103bc9:	68 20 2d 11 80       	push   $0x80112d20
80103bce:	e8 1d 08 00 00       	call   801043f0 <acquire>
80103bd3:	83 c4 10             	add    $0x10,%esp
    ran = 0;
80103bd6:	31 c0                	xor    %eax,%eax
80103bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bdf:	90                   	nop
      if(p->state != RUNNABLE)
80103be0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103be4:	75 38                	jne    80103c1e <scheduler+0x7e>
      switchuvm(p);
80103be6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103be9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103bef:	53                   	push   %ebx
80103bf0:	e8 0b 2d 00 00       	call   80106900 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103bf5:	58                   	pop    %eax
80103bf6:	5a                   	pop    %edx
80103bf7:	ff 73 1c             	pushl  0x1c(%ebx)
80103bfa:	57                   	push   %edi
      p->state = RUNNING;
80103bfb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c02:	e8 84 0b 00 00       	call   8010478b <swtch>
      switchkvm();
80103c07:	e8 e4 2c 00 00       	call   801068f0 <switchkvm>
      c->proc = 0;
80103c0c:	83 c4 10             	add    $0x10,%esp
      ran = 1;
80103c0f:	b8 01 00 00 00       	mov    $0x1,%eax
      c->proc = 0;
80103c14:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c1b:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c1e:	83 c3 7c             	add    $0x7c,%ebx
80103c21:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103c27:	75 b7                	jne    80103be0 <scheduler+0x40>
    release(&ptable.lock);
80103c29:	83 ec 0c             	sub    $0xc,%esp
80103c2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c2f:	68 20 2d 11 80       	push   $0x80112d20
80103c34:	e8 d7 08 00 00       	call   80104510 <release>
    if (ran == 0){
80103c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c3c:	83 c4 10             	add    $0x10,%esp
80103c3f:	85 c0                	test   %eax,%eax
80103c41:	0f 85 79 ff ff ff    	jne    80103bc0 <scheduler+0x20>

// CS 350/550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
    asm volatile("hlt" : : :"memory");
80103c47:	f4                   	hlt    
80103c48:	e9 73 ff ff ff       	jmp    80103bc0 <scheduler+0x20>
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi

80103c50 <sched>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
  pushcli();
80103c55:	e8 46 07 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103c5a:	e8 e1 fb ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103c5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c65:	e8 46 08 00 00       	call   801044b0 <popcli>
  if(!holding(&ptable.lock))
80103c6a:	83 ec 0c             	sub    $0xc,%esp
80103c6d:	68 20 2d 11 80       	push   $0x80112d20
80103c72:	e8 e9 06 00 00       	call   80104360 <holding>
80103c77:	83 c4 10             	add    $0x10,%esp
80103c7a:	85 c0                	test   %eax,%eax
80103c7c:	74 4f                	je     80103ccd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c7e:	e8 bd fb ff ff       	call   80103840 <mycpu>
80103c83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c8a:	75 68                	jne    80103cf4 <sched+0xa4>
  if(p->state == RUNNING)
80103c8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c90:	74 55                	je     80103ce7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c92:	9c                   	pushf  
80103c93:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c94:	f6 c4 02             	test   $0x2,%ah
80103c97:	75 41                	jne    80103cda <sched+0x8a>
  intena = mycpu()->intena;
80103c99:	e8 a2 fb ff ff       	call   80103840 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c9e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ca1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ca7:	e8 94 fb ff ff       	call   80103840 <mycpu>
80103cac:	83 ec 08             	sub    $0x8,%esp
80103caf:	ff 70 04             	pushl  0x4(%eax)
80103cb2:	53                   	push   %ebx
80103cb3:	e8 d3 0a 00 00       	call   8010478b <swtch>
  mycpu()->intena = intena;
80103cb8:	e8 83 fb ff ff       	call   80103840 <mycpu>
}
80103cbd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cc0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cc9:	5b                   	pop    %ebx
80103cca:	5e                   	pop    %esi
80103ccb:	5d                   	pop    %ebp
80103ccc:	c3                   	ret    
    panic("sched ptable.lock");
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	68 50 75 10 80       	push   $0x80107550
80103cd5:	e8 b6 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 7c 75 10 80       	push   $0x8010757c
80103ce2:	e8 a9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ce7:	83 ec 0c             	sub    $0xc,%esp
80103cea:	68 6e 75 10 80       	push   $0x8010756e
80103cef:	e8 9c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103cf4:	83 ec 0c             	sub    $0xc,%esp
80103cf7:	68 62 75 10 80       	push   $0x80107562
80103cfc:	e8 8f c6 ff ff       	call   80100390 <panic>
80103d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop

80103d10 <exit>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d19:	e8 82 06 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103d1e:	e8 1d fb ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103d23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d29:	e8 82 07 00 00       	call   801044b0 <popcli>
  if(curproc == initproc)
80103d2e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d31:	8d 7e 68             	lea    0x68(%esi),%edi
80103d34:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d3a:	0f 84 e7 00 00 00    	je     80103e27 <exit+0x117>
    if(curproc->ofile[fd]){
80103d40:	8b 03                	mov    (%ebx),%eax
80103d42:	85 c0                	test   %eax,%eax
80103d44:	74 12                	je     80103d58 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d46:	83 ec 0c             	sub    $0xc,%esp
80103d49:	50                   	push   %eax
80103d4a:	e8 71 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103d4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d55:	83 c4 10             	add    $0x10,%esp
80103d58:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d5b:	39 df                	cmp    %ebx,%edi
80103d5d:	75 e1                	jne    80103d40 <exit+0x30>
  begin_op();
80103d5f:	e8 3c ef ff ff       	call   80102ca0 <begin_op>
  iput(curproc->cwd);
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	ff 76 68             	pushl  0x68(%esi)
80103d6a:	e8 e1 da ff ff       	call   80101850 <iput>
  end_op();
80103d6f:	e8 9c ef ff ff       	call   80102d10 <end_op>
  curproc->cwd = 0;
80103d74:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d7b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d82:	e8 69 06 00 00       	call   801043f0 <acquire>
  wakeup1(curproc->parent);
80103d87:	8b 56 14             	mov    0x14(%esi),%edx
80103d8a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d8d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d92:	eb 0e                	jmp    80103da2 <exit+0x92>
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d98:	83 c0 7c             	add    $0x7c,%eax
80103d9b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103da0:	74 1c                	je     80103dbe <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103da2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103da6:	75 f0                	jne    80103d98 <exit+0x88>
80103da8:	3b 50 20             	cmp    0x20(%eax),%edx
80103dab:	75 eb                	jne    80103d98 <exit+0x88>
      p->state = RUNNABLE;
80103dad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103db4:	83 c0 7c             	add    $0x7c,%eax
80103db7:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dbc:	75 e4                	jne    80103da2 <exit+0x92>
      p->parent = initproc;
80103dbe:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103dc9:	eb 10                	jmp    80103ddb <exit+0xcb>
80103dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop
80103dd0:	83 c2 7c             	add    $0x7c,%edx
80103dd3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103dd9:	74 33                	je     80103e0e <exit+0xfe>
    if(p->parent == curproc){
80103ddb:	39 72 14             	cmp    %esi,0x14(%edx)
80103dde:	75 f0                	jne    80103dd0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103de0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103de4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103de7:	75 e7                	jne    80103dd0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dee:	eb 0a                	jmp    80103dfa <exit+0xea>
80103df0:	83 c0 7c             	add    $0x7c,%eax
80103df3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103df8:	74 d6                	je     80103dd0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103dfa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dfe:	75 f0                	jne    80103df0 <exit+0xe0>
80103e00:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e03:	75 eb                	jne    80103df0 <exit+0xe0>
      p->state = RUNNABLE;
80103e05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e0c:	eb e2                	jmp    80103df0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e0e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e15:	e8 36 fe ff ff       	call   80103c50 <sched>
  panic("zombie exit");
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 9d 75 10 80       	push   $0x8010759d
80103e22:	e8 69 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 90 75 10 80       	push   $0x80107590
80103e2f:	e8 5c c5 ff ff       	call   80100390 <panic>
80103e34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e3f:	90                   	nop

80103e40 <yield>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e47:	68 20 2d 11 80       	push   $0x80112d20
80103e4c:	e8 9f 05 00 00       	call   801043f0 <acquire>
  pushcli();
80103e51:	e8 4a 05 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103e56:	e8 e5 f9 ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103e5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e61:	e8 4a 06 00 00       	call   801044b0 <popcli>
  myproc()->state = RUNNABLE;
80103e66:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e6d:	e8 de fd ff ff       	call   80103c50 <sched>
  release(&ptable.lock);
80103e72:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e79:	e8 92 06 00 00       	call   80104510 <release>
}
80103e7e:	83 c4 10             	add    $0x10,%esp
80103e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e84:	c9                   	leave  
80103e85:	c3                   	ret    
80103e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi

80103e90 <sleep>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e9f:	e8 fc 04 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103ea4:	e8 97 f9 ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103ea9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eaf:	e8 fc 05 00 00       	call   801044b0 <popcli>
  if(p == 0)
80103eb4:	85 db                	test   %ebx,%ebx
80103eb6:	0f 84 87 00 00 00    	je     80103f43 <sleep+0xb3>
  if(lk == 0)
80103ebc:	85 f6                	test   %esi,%esi
80103ebe:	74 76                	je     80103f36 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ec0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103ec6:	74 50                	je     80103f18 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ec8:	83 ec 0c             	sub    $0xc,%esp
80103ecb:	68 20 2d 11 80       	push   $0x80112d20
80103ed0:	e8 1b 05 00 00       	call   801043f0 <acquire>
    release(lk);
80103ed5:	89 34 24             	mov    %esi,(%esp)
80103ed8:	e8 33 06 00 00       	call   80104510 <release>
  p->chan = chan;
80103edd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ee0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ee7:	e8 64 fd ff ff       	call   80103c50 <sched>
  p->chan = 0;
80103eec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ef3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103efa:	e8 11 06 00 00       	call   80104510 <release>
    acquire(lk);
80103eff:	89 75 08             	mov    %esi,0x8(%ebp)
80103f02:	83 c4 10             	add    $0x10,%esp
}
80103f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f08:	5b                   	pop    %ebx
80103f09:	5e                   	pop    %esi
80103f0a:	5f                   	pop    %edi
80103f0b:	5d                   	pop    %ebp
    acquire(lk);
80103f0c:	e9 df 04 00 00       	jmp    801043f0 <acquire>
80103f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f18:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f1b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f22:	e8 29 fd ff ff       	call   80103c50 <sched>
  p->chan = 0;
80103f27:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f31:	5b                   	pop    %ebx
80103f32:	5e                   	pop    %esi
80103f33:	5f                   	pop    %edi
80103f34:	5d                   	pop    %ebp
80103f35:	c3                   	ret    
    panic("sleep without lk");
80103f36:	83 ec 0c             	sub    $0xc,%esp
80103f39:	68 af 75 10 80       	push   $0x801075af
80103f3e:	e8 4d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	68 a9 75 10 80       	push   $0x801075a9
80103f4b:	e8 40 c4 ff ff       	call   80100390 <panic>

80103f50 <wait>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
  pushcli();
80103f55:	e8 46 04 00 00       	call   801043a0 <pushcli>
  c = mycpu();
80103f5a:	e8 e1 f8 ff ff       	call   80103840 <mycpu>
  p = c->proc;
80103f5f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f65:	e8 46 05 00 00       	call   801044b0 <popcli>
  acquire(&ptable.lock);
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 20 2d 11 80       	push   $0x80112d20
80103f72:	e8 79 04 00 00       	call   801043f0 <acquire>
80103f77:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f7a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f81:	eb 10                	jmp    80103f93 <wait+0x43>
80103f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f87:	90                   	nop
80103f88:	83 c3 7c             	add    $0x7c,%ebx
80103f8b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f91:	74 1b                	je     80103fae <wait+0x5e>
      if(p->parent != curproc)
80103f93:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f96:	75 f0                	jne    80103f88 <wait+0x38>
      if(p->state == ZOMBIE){
80103f98:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f9c:	74 32                	je     80103fd0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fa1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103fac:	75 e5                	jne    80103f93 <wait+0x43>
    if(!havekids || curproc->killed){
80103fae:	85 c0                	test   %eax,%eax
80103fb0:	74 74                	je     80104026 <wait+0xd6>
80103fb2:	8b 46 24             	mov    0x24(%esi),%eax
80103fb5:	85 c0                	test   %eax,%eax
80103fb7:	75 6d                	jne    80104026 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103fb9:	83 ec 08             	sub    $0x8,%esp
80103fbc:	68 20 2d 11 80       	push   $0x80112d20
80103fc1:	56                   	push   %esi
80103fc2:	e8 c9 fe ff ff       	call   80103e90 <sleep>
    havekids = 0;
80103fc7:	83 c4 10             	add    $0x10,%esp
80103fca:	eb ae                	jmp    80103f7a <wait+0x2a>
80103fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
80103fd3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103fd6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fd9:	e8 12 e4 ff ff       	call   801023f0 <kfree>
        freevm(p->pgdir);
80103fde:	5a                   	pop    %edx
80103fdf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103fe2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fe9:	e8 c2 2c 00 00       	call   80106cb0 <freevm>
        release(&ptable.lock);
80103fee:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103ff5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ffc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104003:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104007:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010400e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104015:	e8 f6 04 00 00       	call   80104510 <release>
        return pid;
8010401a:	83 c4 10             	add    $0x10,%esp
}
8010401d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104020:	89 f0                	mov    %esi,%eax
80104022:	5b                   	pop    %ebx
80104023:	5e                   	pop    %esi
80104024:	5d                   	pop    %ebp
80104025:	c3                   	ret    
      release(&ptable.lock);
80104026:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104029:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010402e:	68 20 2d 11 80       	push   $0x80112d20
80104033:	e8 d8 04 00 00       	call   80104510 <release>
      return -1;
80104038:	83 c4 10             	add    $0x10,%esp
8010403b:	eb e0                	jmp    8010401d <wait+0xcd>
8010403d:	8d 76 00             	lea    0x0(%esi),%esi

80104040 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010404a:	68 20 2d 11 80       	push   $0x80112d20
8010404f:	e8 9c 03 00 00       	call   801043f0 <acquire>
80104054:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104057:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010405c:	eb 0c                	jmp    8010406a <wakeup+0x2a>
8010405e:	66 90                	xchg   %ax,%ax
80104060:	83 c0 7c             	add    $0x7c,%eax
80104063:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104068:	74 1c                	je     80104086 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010406a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010406e:	75 f0                	jne    80104060 <wakeup+0x20>
80104070:	3b 58 20             	cmp    0x20(%eax),%ebx
80104073:	75 eb                	jne    80104060 <wakeup+0x20>
      p->state = RUNNABLE;
80104075:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407c:	83 c0 7c             	add    $0x7c,%eax
8010407f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104084:	75 e4                	jne    8010406a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104086:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010408d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104090:	c9                   	leave  
  release(&ptable.lock);
80104091:	e9 7a 04 00 00       	jmp    80104510 <release>
80104096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409d:	8d 76 00             	lea    0x0(%esi),%esi

801040a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
801040a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040aa:	68 20 2d 11 80       	push   $0x80112d20
801040af:	e8 3c 03 00 00       	call   801043f0 <acquire>
801040b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040bc:	eb 0c                	jmp    801040ca <kill+0x2a>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	83 c0 7c             	add    $0x7c,%eax
801040c3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040c8:	74 36                	je     80104100 <kill+0x60>
    if(p->pid == pid){
801040ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801040cd:	75 f1                	jne    801040c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801040d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801040da:	75 07                	jne    801040e3 <kill+0x43>
        p->state = RUNNABLE;
801040dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801040e3:	83 ec 0c             	sub    $0xc,%esp
801040e6:	68 20 2d 11 80       	push   $0x80112d20
801040eb:	e8 20 04 00 00       	call   80104510 <release>
      return 0;
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f8:	c9                   	leave  
801040f9:	c3                   	ret    
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	68 20 2d 11 80       	push   $0x80112d20
80104108:	e8 03 04 00 00       	call   80104510 <release>
  return -1;
8010410d:	83 c4 10             	add    $0x10,%esp
80104110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104118:	c9                   	leave  
80104119:	c3                   	ret    
8010411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104120 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104128:	53                   	push   %ebx
80104129:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010412e:	83 ec 3c             	sub    $0x3c,%esp
80104131:	eb 24                	jmp    80104157 <procdump+0x37>
80104133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104137:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 3f 79 10 80       	push   $0x8010793f
80104140:	e8 6b c5 ff ff       	call   801006b0 <cprintf>
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104151:	0f 84 81 00 00 00    	je     801041d8 <procdump+0xb8>
    if(p->state == UNUSED)
80104157:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	74 ea                	je     80104148 <procdump+0x28>
      state = "???";
8010415e:	ba c0 75 10 80       	mov    $0x801075c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104163:	83 f8 05             	cmp    $0x5,%eax
80104166:	77 11                	ja     80104179 <procdump+0x59>
80104168:	8b 14 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%edx
      state = "???";
8010416f:	b8 c0 75 10 80       	mov    $0x801075c0,%eax
80104174:	85 d2                	test   %edx,%edx
80104176:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104179:	53                   	push   %ebx
8010417a:	52                   	push   %edx
8010417b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010417e:	68 c4 75 10 80       	push   $0x801075c4
80104183:	e8 28 c5 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104188:	83 c4 10             	add    $0x10,%esp
8010418b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010418f:	75 a7                	jne    80104138 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104191:	83 ec 08             	sub    $0x8,%esp
80104194:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104197:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010419a:	50                   	push   %eax
8010419b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010419e:	8b 40 0c             	mov    0xc(%eax),%eax
801041a1:	83 c0 08             	add    $0x8,%eax
801041a4:	50                   	push   %eax
801041a5:	e8 66 01 00 00       	call   80104310 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801041aa:	83 c4 10             	add    $0x10,%esp
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
801041b0:	8b 17                	mov    (%edi),%edx
801041b2:	85 d2                	test   %edx,%edx
801041b4:	74 82                	je     80104138 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041b6:	83 ec 08             	sub    $0x8,%esp
801041b9:	83 c7 04             	add    $0x4,%edi
801041bc:	52                   	push   %edx
801041bd:	68 01 70 10 80       	push   $0x80107001
801041c2:	e8 e9 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	39 fe                	cmp    %edi,%esi
801041cc:	75 e2                	jne    801041b0 <procdump+0x90>
801041ce:	e9 65 ff ff ff       	jmp    80104138 <procdump+0x18>
801041d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d7:	90                   	nop
  }
}
801041d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041db:	5b                   	pop    %ebx
801041dc:	5e                   	pop    %esi
801041dd:	5f                   	pop    %edi
801041de:	5d                   	pop    %ebp
801041df:	c3                   	ret    

801041e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801041ea:	68 38 76 10 80       	push   $0x80107638
801041ef:	8d 43 04             	lea    0x4(%ebx),%eax
801041f2:	50                   	push   %eax
801041f3:	e8 f8 00 00 00       	call   801042f0 <initlock>
  lk->name = name;
801041f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801041fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104201:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104204:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010420b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010420e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104211:	c9                   	leave  
80104212:	c3                   	ret    
80104213:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104228:	8d 73 04             	lea    0x4(%ebx),%esi
8010422b:	83 ec 0c             	sub    $0xc,%esp
8010422e:	56                   	push   %esi
8010422f:	e8 bc 01 00 00       	call   801043f0 <acquire>
  while (lk->locked) {
80104234:	8b 13                	mov    (%ebx),%edx
80104236:	83 c4 10             	add    $0x10,%esp
80104239:	85 d2                	test   %edx,%edx
8010423b:	74 16                	je     80104253 <acquiresleep+0x33>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104240:	83 ec 08             	sub    $0x8,%esp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	e8 46 fc ff ff       	call   80103e90 <sleep>
  while (lk->locked) {
8010424a:	8b 03                	mov    (%ebx),%eax
8010424c:	83 c4 10             	add    $0x10,%esp
8010424f:	85 c0                	test   %eax,%eax
80104251:	75 ed                	jne    80104240 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104253:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104259:	e8 82 f6 ff ff       	call   801038e0 <myproc>
8010425e:	8b 40 10             	mov    0x10(%eax),%eax
80104261:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104264:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104267:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010426a:	5b                   	pop    %ebx
8010426b:	5e                   	pop    %esi
8010426c:	5d                   	pop    %ebp
  release(&lk->lk);
8010426d:	e9 9e 02 00 00       	jmp    80104510 <release>
80104272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104280 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	56                   	push   %esi
80104284:	53                   	push   %ebx
80104285:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104288:	8d 73 04             	lea    0x4(%ebx),%esi
8010428b:	83 ec 0c             	sub    $0xc,%esp
8010428e:	56                   	push   %esi
8010428f:	e8 5c 01 00 00       	call   801043f0 <acquire>
  lk->locked = 0;
80104294:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010429a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801042a1:	89 1c 24             	mov    %ebx,(%esp)
801042a4:	e8 97 fd ff ff       	call   80104040 <wakeup>
  release(&lk->lk);
801042a9:	89 75 08             	mov    %esi,0x8(%ebp)
801042ac:	83 c4 10             	add    $0x10,%esp
}
801042af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b2:	5b                   	pop    %ebx
801042b3:	5e                   	pop    %esi
801042b4:	5d                   	pop    %ebp
  release(&lk->lk);
801042b5:	e9 56 02 00 00       	jmp    80104510 <release>
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
801042c5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801042c8:	8d 5e 04             	lea    0x4(%esi),%ebx
801042cb:	83 ec 0c             	sub    $0xc,%esp
801042ce:	53                   	push   %ebx
801042cf:	e8 1c 01 00 00       	call   801043f0 <acquire>
  r = lk->locked;
801042d4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801042d6:	89 1c 24             	mov    %ebx,(%esp)
801042d9:	e8 32 02 00 00       	call   80104510 <release>
  return r;
}
801042de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e1:	89 f0                	mov    %esi,%eax
801042e3:	5b                   	pop    %ebx
801042e4:	5e                   	pop    %esi
801042e5:	5d                   	pop    %ebp
801042e6:	c3                   	ret    
801042e7:	66 90                	xchg   %ax,%ax
801042e9:	66 90                	xchg   %ax,%ax
801042eb:	66 90                	xchg   %ax,%ax
801042ed:	66 90                	xchg   %ax,%ax
801042ef:	90                   	nop

801042f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801042f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801042f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801042ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104302:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104309:	5d                   	pop    %ebp
8010430a:	c3                   	ret    
8010430b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010430f:	90                   	nop

80104310 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104310:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104311:	31 d2                	xor    %edx,%edx
{
80104313:	89 e5                	mov    %esp,%ebp
80104315:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104316:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010431c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010431f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104320:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104326:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010432c:	77 1a                	ja     80104348 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010432e:	8b 58 04             	mov    0x4(%eax),%ebx
80104331:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104334:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104337:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104339:	83 fa 0a             	cmp    $0xa,%edx
8010433c:	75 e2                	jne    80104320 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010433e:	5b                   	pop    %ebx
8010433f:	5d                   	pop    %ebp
80104340:	c3                   	ret    
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104348:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010434b:	8d 51 28             	lea    0x28(%ecx),%edx
8010434e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104356:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104359:	39 d0                	cmp    %edx,%eax
8010435b:	75 f3                	jne    80104350 <getcallerpcs+0x40>
}
8010435d:	5b                   	pop    %ebx
8010435e:	5d                   	pop    %ebp
8010435f:	c3                   	ret    

80104360 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 04             	sub    $0x4,%esp
80104367:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010436a:	8b 02                	mov    (%edx),%eax
8010436c:	85 c0                	test   %eax,%eax
8010436e:	75 10                	jne    80104380 <holding+0x20>
}
80104370:	83 c4 04             	add    $0x4,%esp
80104373:	31 c0                	xor    %eax,%eax
80104375:	5b                   	pop    %ebx
80104376:	5d                   	pop    %ebp
80104377:	c3                   	ret    
80104378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104380:	8b 5a 08             	mov    0x8(%edx),%ebx
80104383:	e8 b8 f4 ff ff       	call   80103840 <mycpu>
80104388:	39 c3                	cmp    %eax,%ebx
8010438a:	0f 94 c0             	sete   %al
}
8010438d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104390:	0f b6 c0             	movzbl %al,%eax
}
80104393:	5b                   	pop    %ebx
80104394:	5d                   	pop    %ebp
80104395:	c3                   	ret    
80104396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 04             	sub    $0x4,%esp
801043a7:	9c                   	pushf  
801043a8:	5b                   	pop    %ebx
  asm volatile("cli");
801043a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043aa:	e8 91 f4 ff ff       	call   80103840 <mycpu>
801043af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043b5:	85 c0                	test   %eax,%eax
801043b7:	74 17                	je     801043d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801043b9:	e8 82 f4 ff ff       	call   80103840 <mycpu>
801043be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801043c5:	83 c4 04             	add    $0x4,%esp
801043c8:	5b                   	pop    %ebx
801043c9:	5d                   	pop    %ebp
801043ca:	c3                   	ret    
801043cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043cf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801043d0:	e8 6b f4 ff ff       	call   80103840 <mycpu>
801043d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801043db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801043e1:	eb d6                	jmp    801043b9 <pushcli+0x19>
801043e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <acquire>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801043f5:	e8 a6 ff ff ff       	call   801043a0 <pushcli>
  if(holding(lk))
801043fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801043fd:	8b 03                	mov    (%ebx),%eax
801043ff:	85 c0                	test   %eax,%eax
80104401:	0f 85 81 00 00 00    	jne    80104488 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104407:	ba 01 00 00 00       	mov    $0x1,%edx
8010440c:	eb 05                	jmp    80104413 <acquire+0x23>
8010440e:	66 90                	xchg   %ax,%ax
80104410:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104413:	89 d0                	mov    %edx,%eax
80104415:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104418:	85 c0                	test   %eax,%eax
8010441a:	75 f4                	jne    80104410 <acquire+0x20>
  __sync_synchronize();
8010441c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104421:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104424:	e8 17 f4 ff ff       	call   80103840 <mycpu>
  ebp = (uint*)v - 2;
80104429:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
8010442b:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
8010442e:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104430:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104436:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
8010443c:	77 22                	ja     80104460 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
8010443e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104441:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104445:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104448:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010444a:	83 f8 0a             	cmp    $0xa,%eax
8010444d:	75 e1                	jne    80104430 <acquire+0x40>
}
8010444f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104452:	5b                   	pop    %ebx
80104453:	5e                   	pop    %esi
80104454:	5d                   	pop    %ebp
80104455:	c3                   	ret    
80104456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
80104460:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104464:	83 c3 34             	add    $0x34,%ebx
80104467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104476:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104479:	39 c3                	cmp    %eax,%ebx
8010447b:	75 f3                	jne    80104470 <acquire+0x80>
}
8010447d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104480:	5b                   	pop    %ebx
80104481:	5e                   	pop    %esi
80104482:	5d                   	pop    %ebp
80104483:	c3                   	ret    
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104488:	8b 73 08             	mov    0x8(%ebx),%esi
8010448b:	e8 b0 f3 ff ff       	call   80103840 <mycpu>
80104490:	39 c6                	cmp    %eax,%esi
80104492:	0f 85 6f ff ff ff    	jne    80104407 <acquire+0x17>
    panic("acquire");
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	68 43 76 10 80       	push   $0x80107643
801044a0:	e8 eb be ff ff       	call   80100390 <panic>
801044a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <popcli>:

void
popcli(void)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044b6:	9c                   	pushf  
801044b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044b8:	f6 c4 02             	test   $0x2,%ah
801044bb:	75 35                	jne    801044f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044bd:	e8 7e f3 ff ff       	call   80103840 <mycpu>
801044c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044c9:	78 34                	js     801044ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044cb:	e8 70 f3 ff ff       	call   80103840 <mycpu>
801044d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044d6:	85 d2                	test   %edx,%edx
801044d8:	74 06                	je     801044e0 <popcli+0x30>
    sti();
}
801044da:	c9                   	leave  
801044db:	c3                   	ret    
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044e0:	e8 5b f3 ff ff       	call   80103840 <mycpu>
801044e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044eb:	85 c0                	test   %eax,%eax
801044ed:	74 eb                	je     801044da <popcli+0x2a>
  asm volatile("sti");
801044ef:	fb                   	sti    
}
801044f0:	c9                   	leave  
801044f1:	c3                   	ret    
    panic("popcli - interruptible");
801044f2:	83 ec 0c             	sub    $0xc,%esp
801044f5:	68 4b 76 10 80       	push   $0x8010764b
801044fa:	e8 91 be ff ff       	call   80100390 <panic>
    panic("popcli");
801044ff:	83 ec 0c             	sub    $0xc,%esp
80104502:	68 62 76 10 80       	push   $0x80107662
80104507:	e8 84 be ff ff       	call   80100390 <panic>
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <release>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104518:	8b 03                	mov    (%ebx),%eax
8010451a:	85 c0                	test   %eax,%eax
8010451c:	75 12                	jne    80104530 <release+0x20>
    panic("release");
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	68 69 76 10 80       	push   $0x80107669
80104526:	e8 65 be ff ff       	call   80100390 <panic>
8010452b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104530:	8b 73 08             	mov    0x8(%ebx),%esi
80104533:	e8 08 f3 ff ff       	call   80103840 <mycpu>
80104538:	39 c6                	cmp    %eax,%esi
8010453a:	75 e2                	jne    8010451e <release+0xe>
  lk->pcs[0] = 0;
8010453c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104543:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010454a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010454f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104555:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104558:	5b                   	pop    %ebx
80104559:	5e                   	pop    %esi
8010455a:	5d                   	pop    %ebp
  popcli();
8010455b:	e9 50 ff ff ff       	jmp    801044b0 <popcli>

80104560 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	8b 55 08             	mov    0x8(%ebp),%edx
80104567:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010456a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010456b:	89 d0                	mov    %edx,%eax
8010456d:	09 c8                	or     %ecx,%eax
8010456f:	a8 03                	test   $0x3,%al
80104571:	75 2d                	jne    801045a0 <memset+0x40>
    c &= 0xFF;
80104573:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104577:	c1 e9 02             	shr    $0x2,%ecx
8010457a:	89 f8                	mov    %edi,%eax
8010457c:	89 fb                	mov    %edi,%ebx
8010457e:	c1 e0 18             	shl    $0x18,%eax
80104581:	c1 e3 10             	shl    $0x10,%ebx
80104584:	09 d8                	or     %ebx,%eax
80104586:	09 f8                	or     %edi,%eax
80104588:	c1 e7 08             	shl    $0x8,%edi
8010458b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010458d:	89 d7                	mov    %edx,%edi
8010458f:	fc                   	cld    
80104590:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104592:	5b                   	pop    %ebx
80104593:	89 d0                	mov    %edx,%eax
80104595:	5f                   	pop    %edi
80104596:	5d                   	pop    %ebp
80104597:	c3                   	ret    
80104598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop
  asm volatile("cld; rep stosb" :
801045a0:	89 d7                	mov    %edx,%edi
801045a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801045a5:	fc                   	cld    
801045a6:	f3 aa                	rep stos %al,%es:(%edi)
801045a8:	5b                   	pop    %ebx
801045a9:	89 d0                	mov    %edx,%eax
801045ab:	5f                   	pop    %edi
801045ac:	5d                   	pop    %ebp
801045ad:	c3                   	ret    
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	8b 75 10             	mov    0x10(%ebp),%esi
801045b7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ba:	53                   	push   %ebx
801045bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801045be:	85 f6                	test   %esi,%esi
801045c0:	74 22                	je     801045e4 <memcmp+0x34>
    if(*s1 != *s2)
801045c2:	0f b6 08             	movzbl (%eax),%ecx
801045c5:	0f b6 1a             	movzbl (%edx),%ebx
801045c8:	01 c6                	add    %eax,%esi
801045ca:	38 cb                	cmp    %cl,%bl
801045cc:	74 0c                	je     801045da <memcmp+0x2a>
801045ce:	eb 20                	jmp    801045f0 <memcmp+0x40>
801045d0:	0f b6 08             	movzbl (%eax),%ecx
801045d3:	0f b6 1a             	movzbl (%edx),%ebx
801045d6:	38 d9                	cmp    %bl,%cl
801045d8:	75 16                	jne    801045f0 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
801045da:	83 c0 01             	add    $0x1,%eax
801045dd:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801045e0:	39 c6                	cmp    %eax,%esi
801045e2:	75 ec                	jne    801045d0 <memcmp+0x20>
  }

  return 0;
}
801045e4:	5b                   	pop    %ebx
  return 0;
801045e5:	31 c0                	xor    %eax,%eax
}
801045e7:	5e                   	pop    %esi
801045e8:	5d                   	pop    %ebp
801045e9:	c3                   	ret    
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
801045f0:	0f b6 c1             	movzbl %cl,%eax
801045f3:	29 d8                	sub    %ebx,%eax
}
801045f5:	5b                   	pop    %ebx
801045f6:	5e                   	pop    %esi
801045f7:	5d                   	pop    %ebp
801045f8:	c3                   	ret    
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104600 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	8b 45 08             	mov    0x8(%ebp),%eax
80104607:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010460a:	56                   	push   %esi
8010460b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010460e:	39 c6                	cmp    %eax,%esi
80104610:	73 26                	jae    80104638 <memmove+0x38>
80104612:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104615:	39 f8                	cmp    %edi,%eax
80104617:	73 1f                	jae    80104638 <memmove+0x38>
80104619:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
8010461c:	85 c9                	test   %ecx,%ecx
8010461e:	74 0f                	je     8010462f <memmove+0x2f>
      *--d = *--s;
80104620:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104624:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104627:	83 ea 01             	sub    $0x1,%edx
8010462a:	83 fa ff             	cmp    $0xffffffff,%edx
8010462d:	75 f1                	jne    80104620 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010462f:	5e                   	pop    %esi
80104630:	5f                   	pop    %edi
80104631:	5d                   	pop    %ebp
80104632:	c3                   	ret    
80104633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104637:	90                   	nop
80104638:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
8010463b:	89 c7                	mov    %eax,%edi
8010463d:	85 c9                	test   %ecx,%ecx
8010463f:	74 ee                	je     8010462f <memmove+0x2f>
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104648:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104649:	39 d6                	cmp    %edx,%esi
8010464b:	75 fb                	jne    80104648 <memmove+0x48>
}
8010464d:	5e                   	pop    %esi
8010464e:	5f                   	pop    %edi
8010464f:	5d                   	pop    %ebp
80104650:	c3                   	ret    
80104651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465f:	90                   	nop

80104660 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104660:	eb 9e                	jmp    80104600 <memmove>
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	8b 7d 10             	mov    0x10(%ebp),%edi
80104677:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010467a:	56                   	push   %esi
8010467b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010467e:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
8010467f:	85 ff                	test   %edi,%edi
80104681:	74 2f                	je     801046b2 <strncmp+0x42>
80104683:	0f b6 11             	movzbl (%ecx),%edx
80104686:	0f b6 1e             	movzbl (%esi),%ebx
80104689:	84 d2                	test   %dl,%dl
8010468b:	74 37                	je     801046c4 <strncmp+0x54>
8010468d:	38 da                	cmp    %bl,%dl
8010468f:	75 33                	jne    801046c4 <strncmp+0x54>
80104691:	01 f7                	add    %esi,%edi
80104693:	eb 13                	jmp    801046a8 <strncmp+0x38>
80104695:	8d 76 00             	lea    0x0(%esi),%esi
80104698:	0f b6 11             	movzbl (%ecx),%edx
8010469b:	84 d2                	test   %dl,%dl
8010469d:	74 21                	je     801046c0 <strncmp+0x50>
8010469f:	0f b6 18             	movzbl (%eax),%ebx
801046a2:	89 c6                	mov    %eax,%esi
801046a4:	38 da                	cmp    %bl,%dl
801046a6:	75 1c                	jne    801046c4 <strncmp+0x54>
    n--, p++, q++;
801046a8:	8d 46 01             	lea    0x1(%esi),%eax
801046ab:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801046ae:	39 f8                	cmp    %edi,%eax
801046b0:	75 e6                	jne    80104698 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801046b2:	5b                   	pop    %ebx
    return 0;
801046b3:	31 c0                	xor    %eax,%eax
}
801046b5:	5e                   	pop    %esi
801046b6:	5f                   	pop    %edi
801046b7:	5d                   	pop    %ebp
801046b8:	c3                   	ret    
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801046c4:	0f b6 c2             	movzbl %dl,%eax
801046c7:	29 d8                	sub    %ebx,%eax
}
801046c9:	5b                   	pop    %ebx
801046ca:	5e                   	pop    %esi
801046cb:	5f                   	pop    %edi
801046cc:	5d                   	pop    %ebp
801046cd:	c3                   	ret    
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801046d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
801046da:	56                   	push   %esi
801046db:	53                   	push   %ebx
801046dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
801046df:	eb 1a                	jmp    801046fb <strncpy+0x2b>
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e8:	83 c2 01             	add    $0x1,%edx
801046eb:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
801046ef:	83 c1 01             	add    $0x1,%ecx
801046f2:	88 41 ff             	mov    %al,-0x1(%ecx)
801046f5:	84 c0                	test   %al,%al
801046f7:	74 09                	je     80104702 <strncpy+0x32>
801046f9:	89 fb                	mov    %edi,%ebx
801046fb:	8d 7b ff             	lea    -0x1(%ebx),%edi
801046fe:	85 db                	test   %ebx,%ebx
80104700:	7f e6                	jg     801046e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104702:	89 ce                	mov    %ecx,%esi
80104704:	85 ff                	test   %edi,%edi
80104706:	7e 1b                	jle    80104723 <strncpy+0x53>
80104708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop
    *s++ = 0;
80104710:	83 c6 01             	add    $0x1,%esi
80104713:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104717:	89 f2                	mov    %esi,%edx
80104719:	f7 d2                	not    %edx
8010471b:	01 ca                	add    %ecx,%edx
8010471d:	01 da                	add    %ebx,%edx
  while(n-- > 0)
8010471f:	85 d2                	test   %edx,%edx
80104721:	7f ed                	jg     80104710 <strncpy+0x40>
  return os;
}
80104723:	5b                   	pop    %ebx
80104724:	8b 45 08             	mov    0x8(%ebp),%eax
80104727:	5e                   	pop    %esi
80104728:	5f                   	pop    %edi
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    
8010472b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop

80104730 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104737:	8b 45 08             	mov    0x8(%ebp),%eax
8010473a:	53                   	push   %ebx
8010473b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010473e:	85 c9                	test   %ecx,%ecx
80104740:	7e 26                	jle    80104768 <safestrcpy+0x38>
80104742:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104746:	89 c1                	mov    %eax,%ecx
80104748:	eb 17                	jmp    80104761 <safestrcpy+0x31>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104750:	83 c2 01             	add    $0x1,%edx
80104753:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104757:	83 c1 01             	add    $0x1,%ecx
8010475a:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010475d:	84 db                	test   %bl,%bl
8010475f:	74 04                	je     80104765 <safestrcpy+0x35>
80104761:	39 f2                	cmp    %esi,%edx
80104763:	75 eb                	jne    80104750 <safestrcpy+0x20>
    ;
  *s = 0;
80104765:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104768:	5b                   	pop    %ebx
80104769:	5e                   	pop    %esi
8010476a:	5d                   	pop    %ebp
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <strlen>:

int
strlen(const char *s)
{
80104770:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104771:	31 c0                	xor    %eax,%eax
{
80104773:	89 e5                	mov    %esp,%ebp
80104775:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104778:	80 3a 00             	cmpb   $0x0,(%edx)
8010477b:	74 0c                	je     80104789 <strlen+0x19>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	83 c0 01             	add    $0x1,%eax
80104783:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104787:	75 f7                	jne    80104780 <strlen+0x10>
    ;
  return n;
}
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    

8010478b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010478b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010478f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104793:	55                   	push   %ebp
  pushl %ebx
80104794:	53                   	push   %ebx
  pushl %esi
80104795:	56                   	push   %esi
  pushl %edi
80104796:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104797:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104799:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010479b:	5f                   	pop    %edi
  popl %esi
8010479c:	5e                   	pop    %esi
  popl %ebx
8010479d:	5b                   	pop    %ebx
  popl %ebp
8010479e:	5d                   	pop    %ebp
  ret
8010479f:	c3                   	ret    

801047a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
801047a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801047aa:	e8 31 f1 ff ff       	call   801038e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047af:	8b 00                	mov    (%eax),%eax
801047b1:	39 d8                	cmp    %ebx,%eax
801047b3:	76 1b                	jbe    801047d0 <fetchint+0x30>
801047b5:	8d 53 04             	lea    0x4(%ebx),%edx
801047b8:	39 d0                	cmp    %edx,%eax
801047ba:	72 14                	jb     801047d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801047bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801047bf:	8b 13                	mov    (%ebx),%edx
801047c1:	89 10                	mov    %edx,(%eax)
  return 0;
801047c3:	31 c0                	xor    %eax,%eax
}
801047c5:	83 c4 04             	add    $0x4,%esp
801047c8:	5b                   	pop    %ebx
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
801047cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047cf:	90                   	nop
    return -1;
801047d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d5:	eb ee                	jmp    801047c5 <fetchint+0x25>
801047d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047de:	66 90                	xchg   %ax,%ax

801047e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 04             	sub    $0x4,%esp
801047e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801047ea:	e8 f1 f0 ff ff       	call   801038e0 <myproc>

  if(addr >= curproc->sz)
801047ef:	39 18                	cmp    %ebx,(%eax)
801047f1:	76 29                	jbe    8010481c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801047f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801047f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801047f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801047fa:	39 d3                	cmp    %edx,%ebx
801047fc:	73 1e                	jae    8010481c <fetchstr+0x3c>
    if(*s == 0)
801047fe:	80 3b 00             	cmpb   $0x0,(%ebx)
80104801:	74 35                	je     80104838 <fetchstr+0x58>
80104803:	89 d8                	mov    %ebx,%eax
80104805:	eb 0e                	jmp    80104815 <fetchstr+0x35>
80104807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480e:	66 90                	xchg   %ax,%ax
80104810:	80 38 00             	cmpb   $0x0,(%eax)
80104813:	74 1b                	je     80104830 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104815:	83 c0 01             	add    $0x1,%eax
80104818:	39 c2                	cmp    %eax,%edx
8010481a:	77 f4                	ja     80104810 <fetchstr+0x30>
    return -1;
8010481c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104821:	83 c4 04             	add    $0x4,%esp
80104824:	5b                   	pop    %ebx
80104825:	5d                   	pop    %ebp
80104826:	c3                   	ret    
80104827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482e:	66 90                	xchg   %ax,%ax
80104830:	83 c4 04             	add    $0x4,%esp
80104833:	29 d8                	sub    %ebx,%eax
80104835:	5b                   	pop    %ebx
80104836:	5d                   	pop    %ebp
80104837:	c3                   	ret    
    if(*s == 0)
80104838:	31 c0                	xor    %eax,%eax
      return s - *pp;
8010483a:	eb e5                	jmp    80104821 <fetchstr+0x41>
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104845:	e8 96 f0 ff ff       	call   801038e0 <myproc>
8010484a:	8b 55 08             	mov    0x8(%ebp),%edx
8010484d:	8b 40 18             	mov    0x18(%eax),%eax
80104850:	8b 40 44             	mov    0x44(%eax),%eax
80104853:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104856:	e8 85 f0 ff ff       	call   801038e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010485b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010485e:	8b 00                	mov    (%eax),%eax
80104860:	39 c6                	cmp    %eax,%esi
80104862:	73 1c                	jae    80104880 <argint+0x40>
80104864:	8d 53 08             	lea    0x8(%ebx),%edx
80104867:	39 d0                	cmp    %edx,%eax
80104869:	72 15                	jb     80104880 <argint+0x40>
  *ip = *(int*)(addr);
8010486b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486e:	8b 53 04             	mov    0x4(%ebx),%edx
80104871:	89 10                	mov    %edx,(%eax)
  return 0;
80104873:	31 c0                	xor    %eax,%eax
}
80104875:	5b                   	pop    %ebx
80104876:	5e                   	pop    %esi
80104877:	5d                   	pop    %ebp
80104878:	c3                   	ret    
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104885:	eb ee                	jmp    80104875 <argint+0x35>
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax

80104890 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	83 ec 10             	sub    $0x10,%esp
80104898:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010489b:	e8 40 f0 ff ff       	call   801038e0 <myproc>
 
  if(argint(n, &i) < 0)
801048a0:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801048a3:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801048a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048a8:	50                   	push   %eax
801048a9:	ff 75 08             	pushl  0x8(%ebp)
801048ac:	e8 8f ff ff ff       	call   80104840 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801048b1:	83 c4 10             	add    $0x10,%esp
801048b4:	85 c0                	test   %eax,%eax
801048b6:	78 28                	js     801048e0 <argptr+0x50>
801048b8:	85 db                	test   %ebx,%ebx
801048ba:	78 24                	js     801048e0 <argptr+0x50>
801048bc:	8b 16                	mov    (%esi),%edx
801048be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c1:	39 c2                	cmp    %eax,%edx
801048c3:	76 1b                	jbe    801048e0 <argptr+0x50>
801048c5:	01 c3                	add    %eax,%ebx
801048c7:	39 da                	cmp    %ebx,%edx
801048c9:	72 15                	jb     801048e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801048cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801048ce:	89 02                	mov    %eax,(%edx)
  return 0;
801048d0:	31 c0                	xor    %eax,%eax
}
801048d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d5:	5b                   	pop    %ebx
801048d6:	5e                   	pop    %esi
801048d7:	5d                   	pop    %ebp
801048d8:	c3                   	ret    
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e5:	eb eb                	jmp    801048d2 <argptr+0x42>
801048e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801048f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048f9:	50                   	push   %eax
801048fa:	ff 75 08             	pushl  0x8(%ebp)
801048fd:	e8 3e ff ff ff       	call   80104840 <argint>
80104902:	83 c4 10             	add    $0x10,%esp
80104905:	85 c0                	test   %eax,%eax
80104907:	78 17                	js     80104920 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104909:	83 ec 08             	sub    $0x8,%esp
8010490c:	ff 75 0c             	pushl  0xc(%ebp)
8010490f:	ff 75 f4             	pushl  -0xc(%ebp)
80104912:	e8 c9 fe ff ff       	call   801047e0 <fetchstr>
80104917:	83 c4 10             	add    $0x10,%esp
}
8010491a:	c9                   	leave  
8010491b:	c3                   	ret    
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104920:	c9                   	leave  
    return -1;
80104921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104926:	c3                   	ret    
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax

80104930 <syscall>:
[SYS_shutdown2] sys_shutdown2
};

void
syscall(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104937:	e8 a4 ef ff ff       	call   801038e0 <myproc>
8010493c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010493e:	8b 40 18             	mov    0x18(%eax),%eax
80104941:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104944:	8d 50 ff             	lea    -0x1(%eax),%edx
80104947:	83 fa 16             	cmp    $0x16,%edx
8010494a:	77 1c                	ja     80104968 <syscall+0x38>
8010494c:	8b 14 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%edx
80104953:	85 d2                	test   %edx,%edx
80104955:	74 11                	je     80104968 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104957:	ff d2                	call   *%edx
80104959:	8b 53 18             	mov    0x18(%ebx),%edx
8010495c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010495f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104962:	c9                   	leave  
80104963:	c3                   	ret    
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104968:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104969:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010496c:	50                   	push   %eax
8010496d:	ff 73 10             	pushl  0x10(%ebx)
80104970:	68 71 76 10 80       	push   $0x80107671
80104975:	e8 36 bd ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
8010497a:	8b 43 18             	mov    0x18(%ebx),%eax
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	66 90                	xchg   %ax,%ax
8010498e:	66 90                	xchg   %ax,%ax

80104990 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104996:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104999:	83 ec 44             	sub    $0x44,%esp
8010499c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010499f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801049a2:	53                   	push   %ebx
801049a3:	50                   	push   %eax
{
801049a4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801049a7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801049aa:	e8 31 d6 ff ff       	call   80101fe0 <nameiparent>
801049af:	83 c4 10             	add    $0x10,%esp
801049b2:	85 c0                	test   %eax,%eax
801049b4:	0f 84 46 01 00 00    	je     80104b00 <create+0x170>
    return 0;
  ilock(dp);
801049ba:	83 ec 0c             	sub    $0xc,%esp
801049bd:	89 c6                	mov    %eax,%esi
801049bf:	50                   	push   %eax
801049c0:	e8 5b cd ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801049c5:	83 c4 0c             	add    $0xc,%esp
801049c8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801049cb:	50                   	push   %eax
801049cc:	53                   	push   %ebx
801049cd:	56                   	push   %esi
801049ce:	e8 7d d2 ff ff       	call   80101c50 <dirlookup>
801049d3:	83 c4 10             	add    $0x10,%esp
801049d6:	89 c7                	mov    %eax,%edi
801049d8:	85 c0                	test   %eax,%eax
801049da:	74 54                	je     80104a30 <create+0xa0>
    iunlockput(dp);
801049dc:	83 ec 0c             	sub    $0xc,%esp
801049df:	56                   	push   %esi
801049e0:	e8 cb cf ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
801049e5:	89 3c 24             	mov    %edi,(%esp)
801049e8:	e8 33 cd ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801049f5:	75 19                	jne    80104a10 <create+0x80>
801049f7:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801049fc:	75 12                	jne    80104a10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a01:	89 f8                	mov    %edi,%eax
80104a03:	5b                   	pop    %ebx
80104a04:	5e                   	pop    %esi
80104a05:	5f                   	pop    %edi
80104a06:	5d                   	pop    %ebp
80104a07:	c3                   	ret    
80104a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop
    iunlockput(ip);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	57                   	push   %edi
    return 0;
80104a14:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104a16:	e8 95 cf ff ff       	call   801019b0 <iunlockput>
    return 0;
80104a1b:	83 c4 10             	add    $0x10,%esp
}
80104a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a21:	89 f8                	mov    %edi,%eax
80104a23:	5b                   	pop    %ebx
80104a24:	5e                   	pop    %esi
80104a25:	5f                   	pop    %edi
80104a26:	5d                   	pop    %ebp
80104a27:	c3                   	ret    
80104a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104a30:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104a34:	83 ec 08             	sub    $0x8,%esp
80104a37:	50                   	push   %eax
80104a38:	ff 36                	pushl  (%esi)
80104a3a:	e8 71 cb ff ff       	call   801015b0 <ialloc>
80104a3f:	83 c4 10             	add    $0x10,%esp
80104a42:	89 c7                	mov    %eax,%edi
80104a44:	85 c0                	test   %eax,%eax
80104a46:	0f 84 cd 00 00 00    	je     80104b19 <create+0x189>
  ilock(ip);
80104a4c:	83 ec 0c             	sub    $0xc,%esp
80104a4f:	50                   	push   %eax
80104a50:	e8 cb cc ff ff       	call   80101720 <ilock>
  ip->major = major;
80104a55:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104a59:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104a5d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a61:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104a65:	b8 01 00 00 00       	mov    $0x1,%eax
80104a6a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104a6e:	89 3c 24             	mov    %edi,(%esp)
80104a71:	e8 fa cb ff ff       	call   80101670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104a76:	83 c4 10             	add    $0x10,%esp
80104a79:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a7e:	74 30                	je     80104ab0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104a80:	83 ec 04             	sub    $0x4,%esp
80104a83:	ff 77 04             	pushl  0x4(%edi)
80104a86:	53                   	push   %ebx
80104a87:	56                   	push   %esi
80104a88:	e8 73 d4 ff ff       	call   80101f00 <dirlink>
80104a8d:	83 c4 10             	add    $0x10,%esp
80104a90:	85 c0                	test   %eax,%eax
80104a92:	78 78                	js     80104b0c <create+0x17c>
  iunlockput(dp);
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	56                   	push   %esi
80104a98:	e8 13 cf ff ff       	call   801019b0 <iunlockput>
  return ip;
80104a9d:	83 c4 10             	add    $0x10,%esp
}
80104aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa3:	89 f8                	mov    %edi,%eax
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5f                   	pop    %edi
80104aa8:	5d                   	pop    %ebp
80104aa9:	c3                   	ret    
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ab0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ab3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104ab8:	56                   	push   %esi
80104ab9:	e8 b2 cb ff ff       	call   80101670 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104abe:	83 c4 0c             	add    $0xc,%esp
80104ac1:	ff 77 04             	pushl  0x4(%edi)
80104ac4:	68 1c 77 10 80       	push   $0x8010771c
80104ac9:	57                   	push   %edi
80104aca:	e8 31 d4 ff ff       	call   80101f00 <dirlink>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	78 18                	js     80104aee <create+0x15e>
80104ad6:	83 ec 04             	sub    $0x4,%esp
80104ad9:	ff 76 04             	pushl  0x4(%esi)
80104adc:	68 1b 77 10 80       	push   $0x8010771b
80104ae1:	57                   	push   %edi
80104ae2:	e8 19 d4 ff ff       	call   80101f00 <dirlink>
80104ae7:	83 c4 10             	add    $0x10,%esp
80104aea:	85 c0                	test   %eax,%eax
80104aec:	79 92                	jns    80104a80 <create+0xf0>
      panic("create dots");
80104aee:	83 ec 0c             	sub    $0xc,%esp
80104af1:	68 0f 77 10 80       	push   $0x8010770f
80104af6:	e8 95 b8 ff ff       	call   80100390 <panic>
80104afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop
}
80104b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104b03:	31 ff                	xor    %edi,%edi
}
80104b05:	5b                   	pop    %ebx
80104b06:	89 f8                	mov    %edi,%eax
80104b08:	5e                   	pop    %esi
80104b09:	5f                   	pop    %edi
80104b0a:	5d                   	pop    %ebp
80104b0b:	c3                   	ret    
    panic("create: dirlink");
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	68 1e 77 10 80       	push   $0x8010771e
80104b14:	e8 77 b8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104b19:	83 ec 0c             	sub    $0xc,%esp
80104b1c:	68 00 77 10 80       	push   $0x80107700
80104b21:	e8 6a b8 ff ff       	call   80100390 <panic>
80104b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi

80104b30 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	89 d6                	mov    %edx,%esi
80104b36:	53                   	push   %ebx
80104b37:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104b39:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104b3c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b3f:	50                   	push   %eax
80104b40:	6a 00                	push   $0x0
80104b42:	e8 f9 fc ff ff       	call   80104840 <argint>
80104b47:	83 c4 10             	add    $0x10,%esp
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	78 2a                	js     80104b78 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b52:	77 24                	ja     80104b78 <argfd.constprop.0+0x48>
80104b54:	e8 87 ed ff ff       	call   801038e0 <myproc>
80104b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b5c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104b60:	85 c0                	test   %eax,%eax
80104b62:	74 14                	je     80104b78 <argfd.constprop.0+0x48>
  if(pfd)
80104b64:	85 db                	test   %ebx,%ebx
80104b66:	74 02                	je     80104b6a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104b68:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104b6a:	89 06                	mov    %eax,(%esi)
  return 0;
80104b6c:	31 c0                	xor    %eax,%eax
}
80104b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5d                   	pop    %ebp
80104b74:	c3                   	ret    
80104b75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b7d:	eb ef                	jmp    80104b6e <argfd.constprop.0+0x3e>
80104b7f:	90                   	nop

80104b80 <sys_dup>:
{
80104b80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104b81:	31 c0                	xor    %eax,%eax
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	56                   	push   %esi
80104b86:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104b87:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104b8a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104b8d:	e8 9e ff ff ff       	call   80104b30 <argfd.constprop.0>
80104b92:	85 c0                	test   %eax,%eax
80104b94:	78 1a                	js     80104bb0 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104b96:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104b99:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104b9b:	e8 40 ed ff ff       	call   801038e0 <myproc>
    if(curproc->ofile[fd] == 0){
80104ba0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ba4:	85 d2                	test   %edx,%edx
80104ba6:	74 18                	je     80104bc0 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104ba8:	83 c3 01             	add    $0x1,%ebx
80104bab:	83 fb 10             	cmp    $0x10,%ebx
80104bae:	75 f0                	jne    80104ba0 <sys_dup+0x20>
}
80104bb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104bb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104bb8:	89 d8                	mov    %ebx,%eax
80104bba:	5b                   	pop    %ebx
80104bbb:	5e                   	pop    %esi
80104bbc:	5d                   	pop    %ebp
80104bbd:	c3                   	ret    
80104bbe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104bc0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bca:	e8 a1 c2 ff ff       	call   80100e70 <filedup>
  return fd;
80104bcf:	83 c4 10             	add    $0x10,%esp
}
80104bd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd5:	89 d8                	mov    %ebx,%eax
80104bd7:	5b                   	pop    %ebx
80104bd8:	5e                   	pop    %esi
80104bd9:	5d                   	pop    %ebp
80104bda:	c3                   	ret    
80104bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop

80104be0 <sys_read>:
{
80104be0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be1:	31 c0                	xor    %eax,%eax
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 40 ff ff ff       	call   80104b30 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 4c                	js     80104c40 <sys_read+0x60>
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bfa:	50                   	push   %eax
80104bfb:	6a 02                	push   $0x2
80104bfd:	e8 3e fc ff ff       	call   80104840 <argint>
80104c02:	83 c4 10             	add    $0x10,%esp
80104c05:	85 c0                	test   %eax,%eax
80104c07:	78 37                	js     80104c40 <sys_read+0x60>
80104c09:	83 ec 04             	sub    $0x4,%esp
80104c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c12:	50                   	push   %eax
80104c13:	6a 01                	push   $0x1
80104c15:	e8 76 fc ff ff       	call   80104890 <argptr>
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	78 1f                	js     80104c40 <sys_read+0x60>
  return fileread(f, p, n);
80104c21:	83 ec 04             	sub    $0x4,%esp
80104c24:	ff 75 f0             	pushl  -0x10(%ebp)
80104c27:	ff 75 f4             	pushl  -0xc(%ebp)
80104c2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c2d:	e8 be c3 ff ff       	call   80100ff0 <fileread>
80104c32:	83 c4 10             	add    $0x10,%esp
}
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax
80104c40:	c9                   	leave  
    return -1;
80104c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c46:	c3                   	ret    
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax

80104c50 <sys_write>:
{
80104c50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c51:	31 c0                	xor    %eax,%eax
{
80104c53:	89 e5                	mov    %esp,%ebp
80104c55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c5b:	e8 d0 fe ff ff       	call   80104b30 <argfd.constprop.0>
80104c60:	85 c0                	test   %eax,%eax
80104c62:	78 4c                	js     80104cb0 <sys_write+0x60>
80104c64:	83 ec 08             	sub    $0x8,%esp
80104c67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c6a:	50                   	push   %eax
80104c6b:	6a 02                	push   $0x2
80104c6d:	e8 ce fb ff ff       	call   80104840 <argint>
80104c72:	83 c4 10             	add    $0x10,%esp
80104c75:	85 c0                	test   %eax,%eax
80104c77:	78 37                	js     80104cb0 <sys_write+0x60>
80104c79:	83 ec 04             	sub    $0x4,%esp
80104c7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c82:	50                   	push   %eax
80104c83:	6a 01                	push   $0x1
80104c85:	e8 06 fc ff ff       	call   80104890 <argptr>
80104c8a:	83 c4 10             	add    $0x10,%esp
80104c8d:	85 c0                	test   %eax,%eax
80104c8f:	78 1f                	js     80104cb0 <sys_write+0x60>
  return filewrite(f, p, n);
80104c91:	83 ec 04             	sub    $0x4,%esp
80104c94:	ff 75 f0             	pushl  -0x10(%ebp)
80104c97:	ff 75 f4             	pushl  -0xc(%ebp)
80104c9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c9d:	e8 de c3 ff ff       	call   80101080 <filewrite>
80104ca2:	83 c4 10             	add    $0x10,%esp
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cae:	66 90                	xchg   %ax,%ax
80104cb0:	c9                   	leave  
    return -1;
80104cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cb6:	c3                   	ret    
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <sys_close>:
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104cc6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104cc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ccc:	e8 5f fe ff ff       	call   80104b30 <argfd.constprop.0>
80104cd1:	85 c0                	test   %eax,%eax
80104cd3:	78 2b                	js     80104d00 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104cd5:	e8 06 ec ff ff       	call   801038e0 <myproc>
80104cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104cdd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ce0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ce7:	00 
  fileclose(f);
80104ce8:	ff 75 f4             	pushl  -0xc(%ebp)
80104ceb:	e8 d0 c1 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104cf0:	83 c4 10             	add    $0x10,%esp
80104cf3:	31 c0                	xor    %eax,%eax
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	c9                   	leave  
    return -1;
80104d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d06:	c3                   	ret    
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <sys_fstat>:
{
80104d10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d11:	31 c0                	xor    %eax,%eax
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d1b:	e8 10 fe ff ff       	call   80104b30 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 2c                	js     80104d50 <sys_fstat+0x40>
80104d24:	83 ec 04             	sub    $0x4,%esp
80104d27:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d2a:	6a 14                	push   $0x14
80104d2c:	50                   	push   %eax
80104d2d:	6a 01                	push   $0x1
80104d2f:	e8 5c fb ff ff       	call   80104890 <argptr>
80104d34:	83 c4 10             	add    $0x10,%esp
80104d37:	85 c0                	test   %eax,%eax
80104d39:	78 15                	js     80104d50 <sys_fstat+0x40>
  return filestat(f, st);
80104d3b:	83 ec 08             	sub    $0x8,%esp
80104d3e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d41:	ff 75 f0             	pushl  -0x10(%ebp)
80104d44:	e8 57 c2 ff ff       	call   80100fa0 <filestat>
80104d49:	83 c4 10             	add    $0x10,%esp
}
80104d4c:	c9                   	leave  
80104d4d:	c3                   	ret    
80104d4e:	66 90                	xchg   %ax,%ax
80104d50:	c9                   	leave  
    return -1;
80104d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d56:	c3                   	ret    
80104d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <sys_link>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d65:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104d68:	53                   	push   %ebx
80104d69:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d6c:	50                   	push   %eax
80104d6d:	6a 00                	push   $0x0
80104d6f:	e8 7c fb ff ff       	call   801048f0 <argstr>
80104d74:	83 c4 10             	add    $0x10,%esp
80104d77:	85 c0                	test   %eax,%eax
80104d79:	0f 88 fb 00 00 00    	js     80104e7a <sys_link+0x11a>
80104d7f:	83 ec 08             	sub    $0x8,%esp
80104d82:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d85:	50                   	push   %eax
80104d86:	6a 01                	push   $0x1
80104d88:	e8 63 fb ff ff       	call   801048f0 <argstr>
80104d8d:	83 c4 10             	add    $0x10,%esp
80104d90:	85 c0                	test   %eax,%eax
80104d92:	0f 88 e2 00 00 00    	js     80104e7a <sys_link+0x11a>
  begin_op();
80104d98:	e8 03 df ff ff       	call   80102ca0 <begin_op>
  if((ip = namei(old)) == 0){
80104d9d:	83 ec 0c             	sub    $0xc,%esp
80104da0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104da3:	e8 18 d2 ff ff       	call   80101fc0 <namei>
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	89 c3                	mov    %eax,%ebx
80104dad:	85 c0                	test   %eax,%eax
80104daf:	0f 84 e4 00 00 00    	je     80104e99 <sys_link+0x139>
  ilock(ip);
80104db5:	83 ec 0c             	sub    $0xc,%esp
80104db8:	50                   	push   %eax
80104db9:	e8 62 c9 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104dbe:	83 c4 10             	add    $0x10,%esp
80104dc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dc6:	0f 84 b5 00 00 00    	je     80104e81 <sys_link+0x121>
  iupdate(ip);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104dcf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104dd4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104dd7:	53                   	push   %ebx
80104dd8:	e8 93 c8 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
80104ddd:	89 1c 24             	mov    %ebx,(%esp)
80104de0:	e8 1b ca ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104de5:	58                   	pop    %eax
80104de6:	5a                   	pop    %edx
80104de7:	57                   	push   %edi
80104de8:	ff 75 d0             	pushl  -0x30(%ebp)
80104deb:	e8 f0 d1 ff ff       	call   80101fe0 <nameiparent>
80104df0:	83 c4 10             	add    $0x10,%esp
80104df3:	89 c6                	mov    %eax,%esi
80104df5:	85 c0                	test   %eax,%eax
80104df7:	74 5b                	je     80104e54 <sys_link+0xf4>
  ilock(dp);
80104df9:	83 ec 0c             	sub    $0xc,%esp
80104dfc:	50                   	push   %eax
80104dfd:	e8 1e c9 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	8b 03                	mov    (%ebx),%eax
80104e07:	39 06                	cmp    %eax,(%esi)
80104e09:	75 3d                	jne    80104e48 <sys_link+0xe8>
80104e0b:	83 ec 04             	sub    $0x4,%esp
80104e0e:	ff 73 04             	pushl  0x4(%ebx)
80104e11:	57                   	push   %edi
80104e12:	56                   	push   %esi
80104e13:	e8 e8 d0 ff ff       	call   80101f00 <dirlink>
80104e18:	83 c4 10             	add    $0x10,%esp
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	78 29                	js     80104e48 <sys_link+0xe8>
  iunlockput(dp);
80104e1f:	83 ec 0c             	sub    $0xc,%esp
80104e22:	56                   	push   %esi
80104e23:	e8 88 cb ff ff       	call   801019b0 <iunlockput>
  iput(ip);
80104e28:	89 1c 24             	mov    %ebx,(%esp)
80104e2b:	e8 20 ca ff ff       	call   80101850 <iput>
  end_op();
80104e30:	e8 db de ff ff       	call   80102d10 <end_op>
  return 0;
80104e35:	83 c4 10             	add    $0x10,%esp
80104e38:	31 c0                	xor    %eax,%eax
}
80104e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3d:	5b                   	pop    %ebx
80104e3e:	5e                   	pop    %esi
80104e3f:	5f                   	pop    %edi
80104e40:	5d                   	pop    %ebp
80104e41:	c3                   	ret    
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	56                   	push   %esi
80104e4c:	e8 5f cb ff ff       	call   801019b0 <iunlockput>
    goto bad;
80104e51:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104e54:	83 ec 0c             	sub    $0xc,%esp
80104e57:	53                   	push   %ebx
80104e58:	e8 c3 c8 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104e5d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e62:	89 1c 24             	mov    %ebx,(%esp)
80104e65:	e8 06 c8 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80104e6a:	89 1c 24             	mov    %ebx,(%esp)
80104e6d:	e8 3e cb ff ff       	call   801019b0 <iunlockput>
  end_op();
80104e72:	e8 99 de ff ff       	call   80102d10 <end_op>
  return -1;
80104e77:	83 c4 10             	add    $0x10,%esp
80104e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7f:	eb b9                	jmp    80104e3a <sys_link+0xda>
    iunlockput(ip);
80104e81:	83 ec 0c             	sub    $0xc,%esp
80104e84:	53                   	push   %ebx
80104e85:	e8 26 cb ff ff       	call   801019b0 <iunlockput>
    end_op();
80104e8a:	e8 81 de ff ff       	call   80102d10 <end_op>
    return -1;
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e97:	eb a1                	jmp    80104e3a <sys_link+0xda>
    end_op();
80104e99:	e8 72 de ff ff       	call   80102d10 <end_op>
    return -1;
80104e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea3:	eb 95                	jmp    80104e3a <sys_link+0xda>
80104ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <sys_unlink>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104eb5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104eb8:	53                   	push   %ebx
80104eb9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104ebc:	50                   	push   %eax
80104ebd:	6a 00                	push   $0x0
80104ebf:	e8 2c fa ff ff       	call   801048f0 <argstr>
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	85 c0                	test   %eax,%eax
80104ec9:	0f 88 91 01 00 00    	js     80105060 <sys_unlink+0x1b0>
  begin_op();
80104ecf:	e8 cc dd ff ff       	call   80102ca0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ed4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104ed7:	83 ec 08             	sub    $0x8,%esp
80104eda:	53                   	push   %ebx
80104edb:	ff 75 c0             	pushl  -0x40(%ebp)
80104ede:	e8 fd d0 ff ff       	call   80101fe0 <nameiparent>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	89 c6                	mov    %eax,%esi
80104ee8:	85 c0                	test   %eax,%eax
80104eea:	0f 84 7a 01 00 00    	je     8010506a <sys_unlink+0x1ba>
  ilock(dp);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	50                   	push   %eax
80104ef4:	e8 27 c8 ff ff       	call   80101720 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ef9:	58                   	pop    %eax
80104efa:	5a                   	pop    %edx
80104efb:	68 1c 77 10 80       	push   $0x8010771c
80104f00:	53                   	push   %ebx
80104f01:	e8 2a cd ff ff       	call   80101c30 <namecmp>
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	0f 84 0f 01 00 00    	je     80105020 <sys_unlink+0x170>
80104f11:	83 ec 08             	sub    $0x8,%esp
80104f14:	68 1b 77 10 80       	push   $0x8010771b
80104f19:	53                   	push   %ebx
80104f1a:	e8 11 cd ff ff       	call   80101c30 <namecmp>
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	85 c0                	test   %eax,%eax
80104f24:	0f 84 f6 00 00 00    	je     80105020 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f30:	50                   	push   %eax
80104f31:	53                   	push   %ebx
80104f32:	56                   	push   %esi
80104f33:	e8 18 cd ff ff       	call   80101c50 <dirlookup>
80104f38:	83 c4 10             	add    $0x10,%esp
80104f3b:	89 c3                	mov    %eax,%ebx
80104f3d:	85 c0                	test   %eax,%eax
80104f3f:	0f 84 db 00 00 00    	je     80105020 <sys_unlink+0x170>
  ilock(ip);
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	50                   	push   %eax
80104f49:	e8 d2 c7 ff ff       	call   80101720 <ilock>
  if(ip->nlink < 1)
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f56:	0f 8e 37 01 00 00    	jle    80105093 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f61:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104f64:	74 6a                	je     80104fd0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104f66:	83 ec 04             	sub    $0x4,%esp
80104f69:	6a 10                	push   $0x10
80104f6b:	6a 00                	push   $0x0
80104f6d:	57                   	push   %edi
80104f6e:	e8 ed f5 ff ff       	call   80104560 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f73:	6a 10                	push   $0x10
80104f75:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f78:	57                   	push   %edi
80104f79:	56                   	push   %esi
80104f7a:	e8 81 cb ff ff       	call   80101b00 <writei>
80104f7f:	83 c4 20             	add    $0x20,%esp
80104f82:	83 f8 10             	cmp    $0x10,%eax
80104f85:	0f 85 fb 00 00 00    	jne    80105086 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
80104f8b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f90:	0f 84 aa 00 00 00    	je     80105040 <sys_unlink+0x190>
  iunlockput(dp);
80104f96:	83 ec 0c             	sub    $0xc,%esp
80104f99:	56                   	push   %esi
80104f9a:	e8 11 ca ff ff       	call   801019b0 <iunlockput>
  ip->nlink--;
80104f9f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fa4:	89 1c 24             	mov    %ebx,(%esp)
80104fa7:	e8 c4 c6 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
80104fac:	89 1c 24             	mov    %ebx,(%esp)
80104faf:	e8 fc c9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80104fb4:	e8 57 dd ff ff       	call   80102d10 <end_op>
  return 0;
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	31 c0                	xor    %eax,%eax
}
80104fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fc1:	5b                   	pop    %ebx
80104fc2:	5e                   	pop    %esi
80104fc3:	5f                   	pop    %edi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fd0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104fd4:	76 90                	jbe    80104f66 <sys_unlink+0xb6>
80104fd6:	ba 20 00 00 00       	mov    $0x20,%edx
80104fdb:	eb 0f                	jmp    80104fec <sys_unlink+0x13c>
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
80104fe0:	83 c2 10             	add    $0x10,%edx
80104fe3:	39 53 58             	cmp    %edx,0x58(%ebx)
80104fe6:	0f 86 7a ff ff ff    	jbe    80104f66 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fec:	6a 10                	push   $0x10
80104fee:	52                   	push   %edx
80104fef:	57                   	push   %edi
80104ff0:	53                   	push   %ebx
80104ff1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104ff4:	e8 07 ca ff ff       	call   80101a00 <readi>
80104ff9:	83 c4 10             	add    $0x10,%esp
80104ffc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80104fff:	83 f8 10             	cmp    $0x10,%eax
80105002:	75 75                	jne    80105079 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105004:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105009:	74 d5                	je     80104fe0 <sys_unlink+0x130>
    iunlockput(ip);
8010500b:	83 ec 0c             	sub    $0xc,%esp
8010500e:	53                   	push   %ebx
8010500f:	e8 9c c9 ff ff       	call   801019b0 <iunlockput>
    goto bad;
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	56                   	push   %esi
80105024:	e8 87 c9 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105029:	e8 e2 dc ff ff       	call   80102d10 <end_op>
  return -1;
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105036:	eb 86                	jmp    80104fbe <sys_unlink+0x10e>
80105038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503f:	90                   	nop
    iupdate(dp);
80105040:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105043:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105048:	56                   	push   %esi
80105049:	e8 22 c6 ff ff       	call   80101670 <iupdate>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	e9 40 ff ff ff       	jmp    80104f96 <sys_unlink+0xe6>
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	e9 54 ff ff ff       	jmp    80104fbe <sys_unlink+0x10e>
    end_op();
8010506a:	e8 a1 dc ff ff       	call   80102d10 <end_op>
    return -1;
8010506f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105074:	e9 45 ff ff ff       	jmp    80104fbe <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105079:	83 ec 0c             	sub    $0xc,%esp
8010507c:	68 40 77 10 80       	push   $0x80107740
80105081:	e8 0a b3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105086:	83 ec 0c             	sub    $0xc,%esp
80105089:	68 52 77 10 80       	push   $0x80107752
8010508e:	e8 fd b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105093:	83 ec 0c             	sub    $0xc,%esp
80105096:	68 2e 77 10 80       	push   $0x8010772e
8010509b:	e8 f0 b2 ff ff       	call   80100390 <panic>

801050a0 <sys_open>:

int
sys_open(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801050a8:	53                   	push   %ebx
801050a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 3c f8 ff ff       	call   801048f0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 8e 00 00 00    	js     8010514d <sys_open+0xad>
801050bf:	83 ec 08             	sub    $0x8,%esp
801050c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050c5:	50                   	push   %eax
801050c6:	6a 01                	push   $0x1
801050c8:	e8 73 f7 ff ff       	call   80104840 <argint>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 79                	js     8010514d <sys_open+0xad>
    return -1;

  begin_op();
801050d4:	e8 c7 db ff ff       	call   80102ca0 <begin_op>

  if(omode & O_CREATE){
801050d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050dd:	75 79                	jne    80105158 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050df:	83 ec 0c             	sub    $0xc,%esp
801050e2:	ff 75 e0             	pushl  -0x20(%ebp)
801050e5:	e8 d6 ce ff ff       	call   80101fc0 <namei>
801050ea:	83 c4 10             	add    $0x10,%esp
801050ed:	89 c6                	mov    %eax,%esi
801050ef:	85 c0                	test   %eax,%eax
801050f1:	0f 84 7e 00 00 00    	je     80105175 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	50                   	push   %eax
801050fb:	e8 20 c6 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105108:	0f 84 c2 00 00 00    	je     801051d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010510e:	e8 ed bc ff ff       	call   80100e00 <filealloc>
80105113:	89 c7                	mov    %eax,%edi
80105115:	85 c0                	test   %eax,%eax
80105117:	74 23                	je     8010513c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105119:	e8 c2 e7 ff ff       	call   801038e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010511e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105120:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105124:	85 d2                	test   %edx,%edx
80105126:	74 60                	je     80105188 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105128:	83 c3 01             	add    $0x1,%ebx
8010512b:	83 fb 10             	cmp    $0x10,%ebx
8010512e:	75 f0                	jne    80105120 <sys_open+0x80>
    if(f)
      fileclose(f);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	57                   	push   %edi
80105134:	e8 87 bd ff ff       	call   80100ec0 <fileclose>
80105139:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	56                   	push   %esi
80105140:	e8 6b c8 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105145:	e8 c6 db ff ff       	call   80102d10 <end_op>
    return -1;
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105152:	eb 6d                	jmp    801051c1 <sys_open+0x121>
80105154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010515e:	31 c9                	xor    %ecx,%ecx
80105160:	ba 02 00 00 00       	mov    $0x2,%edx
80105165:	6a 00                	push   $0x0
80105167:	e8 24 f8 ff ff       	call   80104990 <create>
    if(ip == 0){
8010516c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010516f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105171:	85 c0                	test   %eax,%eax
80105173:	75 99                	jne    8010510e <sys_open+0x6e>
      end_op();
80105175:	e8 96 db ff ff       	call   80102d10 <end_op>
      return -1;
8010517a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010517f:	eb 40                	jmp    801051c1 <sys_open+0x121>
80105181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105188:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010518b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010518f:	56                   	push   %esi
80105190:	e8 6b c6 ff ff       	call   80101800 <iunlock>
  end_op();
80105195:	e8 76 db ff ff       	call   80102d10 <end_op>

  f->type = FD_INODE;
8010519a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801051a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801051a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801051ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801051b2:	f7 d0                	not    %eax
801051b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801051ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801051c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c4:	89 d8                	mov    %ebx,%eax
801051c6:	5b                   	pop    %ebx
801051c7:	5e                   	pop    %esi
801051c8:	5f                   	pop    %edi
801051c9:	5d                   	pop    %ebp
801051ca:	c3                   	ret    
801051cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801051d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051d3:	85 c9                	test   %ecx,%ecx
801051d5:	0f 84 33 ff ff ff    	je     8010510e <sys_open+0x6e>
801051db:	e9 5c ff ff ff       	jmp    8010513c <sys_open+0x9c>

801051e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051e6:	e8 b5 da ff ff       	call   80102ca0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051eb:	83 ec 08             	sub    $0x8,%esp
801051ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f1:	50                   	push   %eax
801051f2:	6a 00                	push   $0x0
801051f4:	e8 f7 f6 ff ff       	call   801048f0 <argstr>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	85 c0                	test   %eax,%eax
801051fe:	78 30                	js     80105230 <sys_mkdir+0x50>
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105206:	31 c9                	xor    %ecx,%ecx
80105208:	ba 01 00 00 00       	mov    $0x1,%edx
8010520d:	6a 00                	push   $0x0
8010520f:	e8 7c f7 ff ff       	call   80104990 <create>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	74 15                	je     80105230 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010521b:	83 ec 0c             	sub    $0xc,%esp
8010521e:	50                   	push   %eax
8010521f:	e8 8c c7 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105224:	e8 e7 da ff ff       	call   80102d10 <end_op>
  return 0;
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	31 c0                	xor    %eax,%eax
}
8010522e:	c9                   	leave  
8010522f:	c3                   	ret    
    end_op();
80105230:	e8 db da ff ff       	call   80102d10 <end_op>
    return -1;
80105235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010523a:	c9                   	leave  
8010523b:	c3                   	ret    
8010523c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105240 <sys_mknod>:

int
sys_mknod(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105246:	e8 55 da ff ff       	call   80102ca0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010524b:	83 ec 08             	sub    $0x8,%esp
8010524e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105251:	50                   	push   %eax
80105252:	6a 00                	push   $0x0
80105254:	e8 97 f6 ff ff       	call   801048f0 <argstr>
80105259:	83 c4 10             	add    $0x10,%esp
8010525c:	85 c0                	test   %eax,%eax
8010525e:	78 60                	js     801052c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105260:	83 ec 08             	sub    $0x8,%esp
80105263:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105266:	50                   	push   %eax
80105267:	6a 01                	push   $0x1
80105269:	e8 d2 f5 ff ff       	call   80104840 <argint>
  if((argstr(0, &path)) < 0 ||
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	85 c0                	test   %eax,%eax
80105273:	78 4b                	js     801052c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105275:	83 ec 08             	sub    $0x8,%esp
80105278:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010527b:	50                   	push   %eax
8010527c:	6a 02                	push   $0x2
8010527e:	e8 bd f5 ff ff       	call   80104840 <argint>
     argint(1, &major) < 0 ||
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	78 36                	js     801052c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010528a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105295:	ba 03 00 00 00       	mov    $0x3,%edx
8010529a:	50                   	push   %eax
8010529b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010529e:	e8 ed f6 ff ff       	call   80104990 <create>
     argint(2, &minor) < 0 ||
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	74 16                	je     801052c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052aa:	83 ec 0c             	sub    $0xc,%esp
801052ad:	50                   	push   %eax
801052ae:	e8 fd c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
801052b3:	e8 58 da ff ff       	call   80102d10 <end_op>
  return 0;
801052b8:	83 c4 10             	add    $0x10,%esp
801052bb:	31 c0                	xor    %eax,%eax
}
801052bd:	c9                   	leave  
801052be:	c3                   	ret    
801052bf:	90                   	nop
    end_op();
801052c0:	e8 4b da ff ff       	call   80102d10 <end_op>
    return -1;
801052c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ca:	c9                   	leave  
801052cb:	c3                   	ret    
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_chdir>:

int
sys_chdir(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052d8:	e8 03 e6 ff ff       	call   801038e0 <myproc>
801052dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052df:	e8 bc d9 ff ff       	call   80102ca0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052e4:	83 ec 08             	sub    $0x8,%esp
801052e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ea:	50                   	push   %eax
801052eb:	6a 00                	push   $0x0
801052ed:	e8 fe f5 ff ff       	call   801048f0 <argstr>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	85 c0                	test   %eax,%eax
801052f7:	78 77                	js     80105370 <sys_chdir+0xa0>
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	ff 75 f4             	pushl  -0xc(%ebp)
801052ff:	e8 bc cc ff ff       	call   80101fc0 <namei>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	89 c3                	mov    %eax,%ebx
80105309:	85 c0                	test   %eax,%eax
8010530b:	74 63                	je     80105370 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	50                   	push   %eax
80105311:	e8 0a c4 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010531e:	75 30                	jne    80105350 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	53                   	push   %ebx
80105324:	e8 d7 c4 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
80105329:	58                   	pop    %eax
8010532a:	ff 76 68             	pushl  0x68(%esi)
8010532d:	e8 1e c5 ff ff       	call   80101850 <iput>
  end_op();
80105332:	e8 d9 d9 ff ff       	call   80102d10 <end_op>
  curproc->cwd = ip;
80105337:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	31 c0                	xor    %eax,%eax
}
8010533f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105342:	5b                   	pop    %ebx
80105343:	5e                   	pop    %esi
80105344:	5d                   	pop    %ebp
80105345:	c3                   	ret    
80105346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	53                   	push   %ebx
80105354:	e8 57 c6 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105359:	e8 b2 d9 ff ff       	call   80102d10 <end_op>
    return -1;
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105366:	eb d7                	jmp    8010533f <sys_chdir+0x6f>
80105368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536f:	90                   	nop
    end_op();
80105370:	e8 9b d9 ff ff       	call   80102d10 <end_op>
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537a:	eb c3                	jmp    8010533f <sys_chdir+0x6f>
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_exec>:

int
sys_exec(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105385:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010538b:	53                   	push   %ebx
8010538c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105392:	50                   	push   %eax
80105393:	6a 00                	push   $0x0
80105395:	e8 56 f5 ff ff       	call   801048f0 <argstr>
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	85 c0                	test   %eax,%eax
8010539f:	0f 88 87 00 00 00    	js     8010542c <sys_exec+0xac>
801053a5:	83 ec 08             	sub    $0x8,%esp
801053a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053ae:	50                   	push   %eax
801053af:	6a 01                	push   $0x1
801053b1:	e8 8a f4 ff ff       	call   80104840 <argint>
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	85 c0                	test   %eax,%eax
801053bb:	78 6f                	js     8010542c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053bd:	83 ec 04             	sub    $0x4,%esp
801053c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801053c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801053c8:	68 80 00 00 00       	push   $0x80
801053cd:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053d3:	6a 00                	push   $0x0
801053d5:	50                   	push   %eax
801053d6:	e8 85 f1 ff ff       	call   80104560 <memset>
801053db:	83 c4 10             	add    $0x10,%esp
801053de:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053e0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053e6:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801053ed:	83 ec 08             	sub    $0x8,%esp
801053f0:	57                   	push   %edi
801053f1:	01 f0                	add    %esi,%eax
801053f3:	50                   	push   %eax
801053f4:	e8 a7 f3 ff ff       	call   801047a0 <fetchint>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	85 c0                	test   %eax,%eax
801053fe:	78 2c                	js     8010542c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105400:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105406:	85 c0                	test   %eax,%eax
80105408:	74 36                	je     80105440 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010540a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105416:	52                   	push   %edx
80105417:	50                   	push   %eax
80105418:	e8 c3 f3 ff ff       	call   801047e0 <fetchstr>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 08                	js     8010542c <sys_exec+0xac>
  for(i=0;; i++){
80105424:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105427:	83 fb 20             	cmp    $0x20,%ebx
8010542a:	75 b4                	jne    801053e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010542c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010542f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105434:	5b                   	pop    %ebx
80105435:	5e                   	pop    %esi
80105436:	5f                   	pop    %edi
80105437:	5d                   	pop    %ebp
80105438:	c3                   	ret    
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105449:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105450:	00 00 00 00 
  return exec(path, argv);
80105454:	50                   	push   %eax
80105455:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010545b:	e8 20 b6 ff ff       	call   80100a80 <exec>
80105460:	83 c4 10             	add    $0x10,%esp
}
80105463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105466:	5b                   	pop    %ebx
80105467:	5e                   	pop    %esi
80105468:	5f                   	pop    %edi
80105469:	5d                   	pop    %ebp
8010546a:	c3                   	ret    
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <sys_pipe>:

int
sys_pipe(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105475:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105478:	53                   	push   %ebx
80105479:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010547c:	6a 08                	push   $0x8
8010547e:	50                   	push   %eax
8010547f:	6a 00                	push   $0x0
80105481:	e8 0a f4 ff ff       	call   80104890 <argptr>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 4a                	js     801054d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010548d:	83 ec 08             	sub    $0x8,%esp
80105490:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105493:	50                   	push   %eax
80105494:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105497:	50                   	push   %eax
80105498:	e8 b3 de ff ff       	call   80103350 <pipealloc>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 33                	js     801054d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801054a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054a9:	e8 32 e4 ff ff       	call   801038e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801054b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801054b4:	85 f6                	test   %esi,%esi
801054b6:	74 28                	je     801054e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801054b8:	83 c3 01             	add    $0x1,%ebx
801054bb:	83 fb 10             	cmp    $0x10,%ebx
801054be:	75 f0                	jne    801054b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	ff 75 e0             	pushl  -0x20(%ebp)
801054c6:	e8 f5 b9 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801054cb:	58                   	pop    %eax
801054cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801054cf:	e8 ec b9 ff ff       	call   80100ec0 <fileclose>
    return -1;
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dc:	eb 53                	jmp    80105531 <sys_pipe+0xc1>
801054de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801054e0:	8d 73 08             	lea    0x8(%ebx),%esi
801054e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801054ea:	e8 f1 e3 ff ff       	call   801038e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ef:	31 d2                	xor    %edx,%edx
801054f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801054fc:	85 c9                	test   %ecx,%ecx
801054fe:	74 20                	je     80105520 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105500:	83 c2 01             	add    $0x1,%edx
80105503:	83 fa 10             	cmp    $0x10,%edx
80105506:	75 f0                	jne    801054f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105508:	e8 d3 e3 ff ff       	call   801038e0 <myproc>
8010550d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105514:	00 
80105515:	eb a9                	jmp    801054c0 <sys_pipe+0x50>
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105520:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105524:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105527:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105529:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010552c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010552f:	31 c0                	xor    %eax,%eax
}
80105531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105534:	5b                   	pop    %ebx
80105535:	5e                   	pop    %esi
80105536:	5f                   	pop    %edi
80105537:	5d                   	pop    %ebp
80105538:	c3                   	ret    
80105539:	66 90                	xchg   %ax,%ax
8010553b:	66 90                	xchg   %ax,%ax
8010553d:	66 90                	xchg   %ax,%ax
8010553f:	90                   	nop

80105540 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105540:	e9 3b e5 ff ff       	jmp    80103a80 <fork>
80105545:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_exit>:
}

int
sys_exit(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 08             	sub    $0x8,%esp
  exit();
80105556:	e8 b5 e7 ff ff       	call   80103d10 <exit>
  return 0;  // not reached
}
8010555b:	31 c0                	xor    %eax,%eax
8010555d:	c9                   	leave  
8010555e:	c3                   	ret    
8010555f:	90                   	nop

80105560 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105560:	e9 eb e9 ff ff       	jmp    80103f50 <wait>
80105565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105570 <sys_kill>:
}

int
sys_kill(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105576:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105579:	50                   	push   %eax
8010557a:	6a 00                	push   $0x0
8010557c:	e8 bf f2 ff ff       	call   80104840 <argint>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	85 c0                	test   %eax,%eax
80105586:	78 18                	js     801055a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105588:	83 ec 0c             	sub    $0xc,%esp
8010558b:	ff 75 f4             	pushl  -0xc(%ebp)
8010558e:	e8 0d eb ff ff       	call   801040a0 <kill>
80105593:	83 c4 10             	add    $0x10,%esp
}
80105596:	c9                   	leave  
80105597:	c3                   	ret    
80105598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
801055a0:	c9                   	leave  
    return -1;
801055a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a6:	c3                   	ret    
801055a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ae:	66 90                	xchg   %ax,%ax

801055b0 <sys_getpid>:

int
sys_getpid(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801055b6:	e8 25 e3 ff ff       	call   801038e0 <myproc>
801055bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801055be:	c9                   	leave  
801055bf:	c3                   	ret    

801055c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801055ca:	50                   	push   %eax
801055cb:	6a 00                	push   $0x0
801055cd:	e8 6e f2 ff ff       	call   80104840 <argint>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	78 27                	js     80105600 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801055d9:	e8 02 e3 ff ff       	call   801038e0 <myproc>
  if(growproc(n) < 0)
801055de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801055e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801055e3:	ff 75 f4             	pushl  -0xc(%ebp)
801055e6:	e8 15 e4 ff ff       	call   80103a00 <growproc>
801055eb:	83 c4 10             	add    $0x10,%esp
801055ee:	85 c0                	test   %eax,%eax
801055f0:	78 0e                	js     80105600 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801055f2:	89 d8                	mov    %ebx,%eax
801055f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055f7:	c9                   	leave  
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105600:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105605:	eb eb                	jmp    801055f2 <sys_sbrk+0x32>
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax

80105610 <sys_sleep>:

int
sys_sleep(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105614:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105617:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010561a:	50                   	push   %eax
8010561b:	6a 00                	push   $0x0
8010561d:	e8 1e f2 ff ff       	call   80104840 <argint>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	0f 88 8a 00 00 00    	js     801056b7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010562d:	83 ec 0c             	sub    $0xc,%esp
80105630:	68 60 4c 11 80       	push   $0x80114c60
80105635:	e8 b6 ed ff ff       	call   801043f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010563a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010563d:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 d2                	test   %edx,%edx
80105648:	75 27                	jne    80105671 <sys_sleep+0x61>
8010564a:	eb 54                	jmp    801056a0 <sys_sleep+0x90>
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105650:	83 ec 08             	sub    $0x8,%esp
80105653:	68 60 4c 11 80       	push   $0x80114c60
80105658:	68 a0 54 11 80       	push   $0x801154a0
8010565d:	e8 2e e8 ff ff       	call   80103e90 <sleep>
  while(ticks - ticks0 < n){
80105662:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105667:	83 c4 10             	add    $0x10,%esp
8010566a:	29 d8                	sub    %ebx,%eax
8010566c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010566f:	73 2f                	jae    801056a0 <sys_sleep+0x90>
    if(myproc()->killed){
80105671:	e8 6a e2 ff ff       	call   801038e0 <myproc>
80105676:	8b 40 24             	mov    0x24(%eax),%eax
80105679:	85 c0                	test   %eax,%eax
8010567b:	74 d3                	je     80105650 <sys_sleep+0x40>
      release(&tickslock);
8010567d:	83 ec 0c             	sub    $0xc,%esp
80105680:	68 60 4c 11 80       	push   $0x80114c60
80105685:	e8 86 ee ff ff       	call   80104510 <release>
      return -1;
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105695:	c9                   	leave  
80105696:	c3                   	ret    
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	68 60 4c 11 80       	push   $0x80114c60
801056a8:	e8 63 ee ff ff       	call   80104510 <release>
  return 0;
801056ad:	83 c4 10             	add    $0x10,%esp
801056b0:	31 c0                	xor    %eax,%eax
}
801056b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
    return -1;
801056b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bc:	eb f4                	jmp    801056b2 <sys_sleep+0xa2>
801056be:	66 90                	xchg   %ax,%ax

801056c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	53                   	push   %ebx
801056c4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056c7:	68 60 4c 11 80       	push   $0x80114c60
801056cc:	e8 1f ed ff ff       	call   801043f0 <acquire>
  xticks = ticks;
801056d1:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
801056d7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801056de:	e8 2d ee ff ff       	call   80104510 <release>
  return xticks;
}
801056e3:	89 d8                	mov    %ebx,%eax
801056e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e8:	c9                   	leave  
801056e9:	c3                   	ret    
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056f0 <sys_shutdown>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801056f0:	b8 00 20 00 00       	mov    $0x2000,%eax
801056f5:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
801056fa:	66 ef                	out    %ax,(%dx)
801056fc:	ba 04 06 00 00       	mov    $0x604,%edx
80105701:	66 ef                	out    %ax,(%dx)

int sys_shutdown(void){
	outw(0xB004, 0x0|0x2000);
	outw(0x604, 0x0|0x2000);
	return 0;
}
80105703:	31 c0                	xor    %eax,%eax
80105705:	c3                   	ret    
80105706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570d:	8d 76 00             	lea    0x0(%esi),%esi

80105710 <sys_shutdown2>:

int sys_shutdown2(char* msg){
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 10             	sub    $0x10,%esp
	argstr(0, &msg);
80105716:	8d 45 08             	lea    0x8(%ebp),%eax
80105719:	50                   	push   %eax
8010571a:	6a 00                	push   $0x0
8010571c:	e8 cf f1 ff ff       	call   801048f0 <argstr>
	cprintf(msg);
80105721:	58                   	pop    %eax
80105722:	ff 75 08             	pushl  0x8(%ebp)
80105725:	e8 86 af ff ff       	call   801006b0 <cprintf>
8010572a:	b8 00 20 00 00       	mov    $0x2000,%eax
8010572f:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105734:	66 ef                	out    %ax,(%dx)
80105736:	ba 04 06 00 00       	mov    $0x604,%edx
8010573b:	66 ef                	out    %ax,(%dx)
	outw(0xB004, 0x0|0x2000);
	outw(0x604, 0x0|0x2000);
	return 0;

}
8010573d:	c9                   	leave  
8010573e:	31 c0                	xor    %eax,%eax
80105740:	c3                   	ret    

80105741 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105741:	1e                   	push   %ds
  pushl %es
80105742:	06                   	push   %es
  pushl %fs
80105743:	0f a0                	push   %fs
  pushl %gs
80105745:	0f a8                	push   %gs
  pushal
80105747:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105748:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010574c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010574e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105750:	54                   	push   %esp
  call trap
80105751:	e8 ca 00 00 00       	call   80105820 <trap>
  addl $4, %esp
80105756:	83 c4 04             	add    $0x4,%esp

80105759 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105759:	61                   	popa   
  popl %gs
8010575a:	0f a9                	pop    %gs
  popl %fs
8010575c:	0f a1                	pop    %fs
  popl %es
8010575e:	07                   	pop    %es
  popl %ds
8010575f:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105760:	83 c4 08             	add    $0x8,%esp
  iret
80105763:	cf                   	iret   
80105764:	66 90                	xchg   %ax,%ax
80105766:	66 90                	xchg   %ax,%ax
80105768:	66 90                	xchg   %ax,%ax
8010576a:	66 90                	xchg   %ax,%ax
8010576c:	66 90                	xchg   %ax,%ax
8010576e:	66 90                	xchg   %ax,%ax

80105770 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105770:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105771:	31 c0                	xor    %eax,%eax
{
80105773:	89 e5                	mov    %esp,%ebp
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105780:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105787:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010578e:	08 00 00 8e 
80105792:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105799:	80 
8010579a:	c1 ea 10             	shr    $0x10,%edx
8010579d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801057a4:	80 
  for(i = 0; i < 256; i++)
801057a5:	83 c0 01             	add    $0x1,%eax
801057a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801057ad:	75 d1                	jne    80105780 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801057af:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057b2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801057b7:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
801057be:	00 00 ef 
  initlock(&tickslock, "time");
801057c1:	68 61 77 10 80       	push   $0x80107761
801057c6:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057cb:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801057d1:	c1 e8 10             	shr    $0x10,%eax
801057d4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801057da:	e8 11 eb ff ff       	call   801042f0 <initlock>
}
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	c9                   	leave  
801057e3:	c3                   	ret    
801057e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ef:	90                   	nop

801057f0 <idtinit>:

void
idtinit(void)
{
801057f0:	55                   	push   %ebp
  pd[0] = size-1;
801057f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057f6:	89 e5                	mov    %esp,%ebp
801057f8:	83 ec 10             	sub    $0x10,%esp
801057fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057ff:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105804:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105808:	c1 e8 10             	shr    $0x10,%eax
8010580b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010580f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105812:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105815:	c9                   	leave  
80105816:	c3                   	ret    
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
80105825:	53                   	push   %ebx
80105826:	83 ec 1c             	sub    $0x1c,%esp
80105829:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010582c:	8b 47 30             	mov    0x30(%edi),%eax
8010582f:	83 f8 40             	cmp    $0x40,%eax
80105832:	0f 84 b8 01 00 00    	je     801059f0 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105838:	83 e8 20             	sub    $0x20,%eax
8010583b:	83 f8 1f             	cmp    $0x1f,%eax
8010583e:	77 10                	ja     80105850 <trap+0x30>
80105840:	ff 24 85 08 78 10 80 	jmp    *-0x7fef87f8(,%eax,4)
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105850:	e8 8b e0 ff ff       	call   801038e0 <myproc>
80105855:	8b 5f 38             	mov    0x38(%edi),%ebx
80105858:	85 c0                	test   %eax,%eax
8010585a:	0f 84 17 02 00 00    	je     80105a77 <trap+0x257>
80105860:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105864:	0f 84 0d 02 00 00    	je     80105a77 <trap+0x257>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010586a:	0f 20 d1             	mov    %cr2,%ecx
8010586d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105870:	e8 4b e0 ff ff       	call   801038c0 <cpuid>
80105875:	8b 77 30             	mov    0x30(%edi),%esi
80105878:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010587b:	8b 47 34             	mov    0x34(%edi),%eax
8010587e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105881:	e8 5a e0 ff ff       	call   801038e0 <myproc>
80105886:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105889:	e8 52 e0 ff ff       	call   801038e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010588e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105891:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105894:	51                   	push   %ecx
80105895:	53                   	push   %ebx
80105896:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105897:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010589a:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010589d:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058a0:	56                   	push   %esi
801058a1:	52                   	push   %edx
801058a2:	ff 70 10             	pushl  0x10(%eax)
801058a5:	68 c4 77 10 80       	push   $0x801077c4
801058aa:	e8 01 ae ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801058af:	83 c4 20             	add    $0x20,%esp
801058b2:	e8 29 e0 ff ff       	call   801038e0 <myproc>
801058b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058be:	e8 1d e0 ff ff       	call   801038e0 <myproc>
801058c3:	85 c0                	test   %eax,%eax
801058c5:	74 1d                	je     801058e4 <trap+0xc4>
801058c7:	e8 14 e0 ff ff       	call   801038e0 <myproc>
801058cc:	8b 50 24             	mov    0x24(%eax),%edx
801058cf:	85 d2                	test   %edx,%edx
801058d1:	74 11                	je     801058e4 <trap+0xc4>
801058d3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058d7:	83 e0 03             	and    $0x3,%eax
801058da:	66 83 f8 03          	cmp    $0x3,%ax
801058de:	0f 84 44 01 00 00    	je     80105a28 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058e4:	e8 f7 df ff ff       	call   801038e0 <myproc>
801058e9:	85 c0                	test   %eax,%eax
801058eb:	74 0b                	je     801058f8 <trap+0xd8>
801058ed:	e8 ee df ff ff       	call   801038e0 <myproc>
801058f2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058f6:	74 38                	je     80105930 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058f8:	e8 e3 df ff ff       	call   801038e0 <myproc>
801058fd:	85 c0                	test   %eax,%eax
801058ff:	74 1d                	je     8010591e <trap+0xfe>
80105901:	e8 da df ff ff       	call   801038e0 <myproc>
80105906:	8b 40 24             	mov    0x24(%eax),%eax
80105909:	85 c0                	test   %eax,%eax
8010590b:	74 11                	je     8010591e <trap+0xfe>
8010590d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105911:	83 e0 03             	and    $0x3,%eax
80105914:	66 83 f8 03          	cmp    $0x3,%ax
80105918:	0f 84 fb 00 00 00    	je     80105a19 <trap+0x1f9>
    exit();
}
8010591e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105921:	5b                   	pop    %ebx
80105922:	5e                   	pop    %esi
80105923:	5f                   	pop    %edi
80105924:	5d                   	pop    %ebp
80105925:	c3                   	ret    
80105926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105930:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105934:	75 c2                	jne    801058f8 <trap+0xd8>
    yield();
80105936:	e8 05 e5 ff ff       	call   80103e40 <yield>
8010593b:	eb bb                	jmp    801058f8 <trap+0xd8>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105940:	e8 7b df ff ff       	call   801038c0 <cpuid>
80105945:	85 c0                	test   %eax,%eax
80105947:	0f 84 eb 00 00 00    	je     80105a38 <trap+0x218>
    lapiceoi();
8010594d:	e8 fe ce ff ff       	call   80102850 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105952:	e8 89 df ff ff       	call   801038e0 <myproc>
80105957:	85 c0                	test   %eax,%eax
80105959:	0f 85 68 ff ff ff    	jne    801058c7 <trap+0xa7>
8010595f:	eb 83                	jmp    801058e4 <trap+0xc4>
80105961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105968:	e8 a3 cd ff ff       	call   80102710 <kbdintr>
    lapiceoi();
8010596d:	e8 de ce ff ff       	call   80102850 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105972:	e8 69 df ff ff       	call   801038e0 <myproc>
80105977:	85 c0                	test   %eax,%eax
80105979:	0f 85 48 ff ff ff    	jne    801058c7 <trap+0xa7>
8010597f:	e9 60 ff ff ff       	jmp    801058e4 <trap+0xc4>
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105988:	e8 83 02 00 00       	call   80105c10 <uartintr>
    lapiceoi();
8010598d:	e8 be ce ff ff       	call   80102850 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105992:	e8 49 df ff ff       	call   801038e0 <myproc>
80105997:	85 c0                	test   %eax,%eax
80105999:	0f 85 28 ff ff ff    	jne    801058c7 <trap+0xa7>
8010599f:	e9 40 ff ff ff       	jmp    801058e4 <trap+0xc4>
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059a8:	8b 77 38             	mov    0x38(%edi),%esi
801059ab:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059af:	e8 0c df ff ff       	call   801038c0 <cpuid>
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
801059b6:	50                   	push   %eax
801059b7:	68 6c 77 10 80       	push   $0x8010776c
801059bc:	e8 ef ac ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801059c1:	e8 8a ce ff ff       	call   80102850 <lapiceoi>
    break;
801059c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059c9:	e8 12 df ff ff       	call   801038e0 <myproc>
801059ce:	85 c0                	test   %eax,%eax
801059d0:	0f 85 f1 fe ff ff    	jne    801058c7 <trap+0xa7>
801059d6:	e9 09 ff ff ff       	jmp    801058e4 <trap+0xc4>
801059db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059df:	90                   	nop
    ideintr();
801059e0:	e8 7b c7 ff ff       	call   80102160 <ideintr>
801059e5:	e9 63 ff ff ff       	jmp    8010594d <trap+0x12d>
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801059f0:	e8 eb de ff ff       	call   801038e0 <myproc>
801059f5:	8b 58 24             	mov    0x24(%eax),%ebx
801059f8:	85 db                	test   %ebx,%ebx
801059fa:	75 74                	jne    80105a70 <trap+0x250>
    myproc()->tf = tf;
801059fc:	e8 df de ff ff       	call   801038e0 <myproc>
80105a01:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105a04:	e8 27 ef ff ff       	call   80104930 <syscall>
    if(myproc()->killed)
80105a09:	e8 d2 de ff ff       	call   801038e0 <myproc>
80105a0e:	8b 48 24             	mov    0x24(%eax),%ecx
80105a11:	85 c9                	test   %ecx,%ecx
80105a13:	0f 84 05 ff ff ff    	je     8010591e <trap+0xfe>
}
80105a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a1c:	5b                   	pop    %ebx
80105a1d:	5e                   	pop    %esi
80105a1e:	5f                   	pop    %edi
80105a1f:	5d                   	pop    %ebp
      exit();
80105a20:	e9 eb e2 ff ff       	jmp    80103d10 <exit>
80105a25:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a28:	e8 e3 e2 ff ff       	call   80103d10 <exit>
80105a2d:	e9 b2 fe ff ff       	jmp    801058e4 <trap+0xc4>
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	68 60 4c 11 80       	push   $0x80114c60
80105a40:	e8 ab e9 ff ff       	call   801043f0 <acquire>
      wakeup(&ticks);
80105a45:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105a4c:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105a53:	e8 e8 e5 ff ff       	call   80104040 <wakeup>
      release(&tickslock);
80105a58:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a5f:	e8 ac ea ff ff       	call   80104510 <release>
80105a64:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105a67:	e9 e1 fe ff ff       	jmp    8010594d <trap+0x12d>
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105a70:	e8 9b e2 ff ff       	call   80103d10 <exit>
80105a75:	eb 85                	jmp    801059fc <trap+0x1dc>
80105a77:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a7a:	e8 41 de ff ff       	call   801038c0 <cpuid>
80105a7f:	83 ec 0c             	sub    $0xc,%esp
80105a82:	56                   	push   %esi
80105a83:	53                   	push   %ebx
80105a84:	50                   	push   %eax
80105a85:	ff 77 30             	pushl  0x30(%edi)
80105a88:	68 90 77 10 80       	push   $0x80107790
80105a8d:	e8 1e ac ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105a92:	83 c4 14             	add    $0x14,%esp
80105a95:	68 66 77 10 80       	push   $0x80107766
80105a9a:	e8 f1 a8 ff ff       	call   80100390 <panic>
80105a9f:	90                   	nop

80105aa0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105aa0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	74 17                	je     80105ac0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105aa9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105aae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105aaf:	a8 01                	test   $0x1,%al
80105ab1:	74 0d                	je     80105ac0 <uartgetc+0x20>
80105ab3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ab8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ab9:	0f b6 c0             	movzbl %al,%eax
80105abc:	c3                   	ret    
80105abd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac5:	c3                   	ret    
80105ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105acd:	8d 76 00             	lea    0x0(%esi),%esi

80105ad0 <uartputc.part.0>:
uartputc(int c)
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	89 c7                	mov    %eax,%edi
80105ad6:	56                   	push   %esi
80105ad7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105adc:	53                   	push   %ebx
80105add:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	eb 1b                	jmp    80105b02 <uartputc.part.0+0x32>
80105ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aee:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	6a 0a                	push   $0xa
80105af5:	e8 76 cd ff ff       	call   80102870 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	83 eb 01             	sub    $0x1,%ebx
80105b00:	74 07                	je     80105b09 <uartputc.part.0+0x39>
80105b02:	89 f2                	mov    %esi,%edx
80105b04:	ec                   	in     (%dx),%al
80105b05:	a8 20                	test   $0x20,%al
80105b07:	74 e7                	je     80105af0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b09:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b0e:	89 f8                	mov    %edi,%eax
80105b10:	ee                   	out    %al,(%dx)
}
80105b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b14:	5b                   	pop    %ebx
80105b15:	5e                   	pop    %esi
80105b16:	5f                   	pop    %edi
80105b17:	5d                   	pop    %ebp
80105b18:	c3                   	ret    
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b20 <uartinit>:
{
80105b20:	55                   	push   %ebp
80105b21:	31 c9                	xor    %ecx,%ecx
80105b23:	89 c8                	mov    %ecx,%eax
80105b25:	89 e5                	mov    %esp,%ebp
80105b27:	57                   	push   %edi
80105b28:	56                   	push   %esi
80105b29:	53                   	push   %ebx
80105b2a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b2f:	89 da                	mov    %ebx,%edx
80105b31:	83 ec 0c             	sub    $0xc,%esp
80105b34:	ee                   	out    %al,(%dx)
80105b35:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b3f:	89 fa                	mov    %edi,%edx
80105b41:	ee                   	out    %al,(%dx)
80105b42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4c:	ee                   	out    %al,(%dx)
80105b4d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b52:	89 c8                	mov    %ecx,%eax
80105b54:	89 f2                	mov    %esi,%edx
80105b56:	ee                   	out    %al,(%dx)
80105b57:	b8 03 00 00 00       	mov    $0x3,%eax
80105b5c:	89 fa                	mov    %edi,%edx
80105b5e:	ee                   	out    %al,(%dx)
80105b5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b64:	89 c8                	mov    %ecx,%eax
80105b66:	ee                   	out    %al,(%dx)
80105b67:	b8 01 00 00 00       	mov    $0x1,%eax
80105b6c:	89 f2                	mov    %esi,%edx
80105b6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105b75:	3c ff                	cmp    $0xff,%al
80105b77:	74 56                	je     80105bcf <uartinit+0xaf>
  uart = 1;
80105b79:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b80:	00 00 00 
80105b83:	89 da                	mov    %ebx,%edx
80105b85:	ec                   	in     (%dx),%al
80105b86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b8b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105b8c:	83 ec 08             	sub    $0x8,%esp
80105b8f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105b94:	bb 88 78 10 80       	mov    $0x80107888,%ebx
  ioapicenable(IRQ_COM1, 0);
80105b99:	6a 00                	push   $0x0
80105b9b:	6a 04                	push   $0x4
80105b9d:	e8 0e c8 ff ff       	call   801023b0 <ioapicenable>
80105ba2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ba5:	b8 78 00 00 00       	mov    $0x78,%eax
80105baa:	eb 08                	jmp    80105bb4 <uartinit+0x94>
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bb0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105bb4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105bba:	85 d2                	test   %edx,%edx
80105bbc:	74 08                	je     80105bc6 <uartinit+0xa6>
    uartputc(*p);
80105bbe:	0f be c0             	movsbl %al,%eax
80105bc1:	e8 0a ff ff ff       	call   80105ad0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105bc6:	89 f0                	mov    %esi,%eax
80105bc8:	83 c3 01             	add    $0x1,%ebx
80105bcb:	84 c0                	test   %al,%al
80105bcd:	75 e1                	jne    80105bb0 <uartinit+0x90>
}
80105bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bd2:	5b                   	pop    %ebx
80105bd3:	5e                   	pop    %esi
80105bd4:	5f                   	pop    %edi
80105bd5:	5d                   	pop    %ebp
80105bd6:	c3                   	ret    
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <uartputc>:
{
80105be0:	55                   	push   %ebp
  if(!uart)
80105be1:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105be7:	89 e5                	mov    %esp,%ebp
80105be9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105bec:	85 d2                	test   %edx,%edx
80105bee:	74 10                	je     80105c00 <uartputc+0x20>
}
80105bf0:	5d                   	pop    %ebp
80105bf1:	e9 da fe ff ff       	jmp    80105ad0 <uartputc.part.0>
80105bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
80105c00:	5d                   	pop    %ebp
80105c01:	c3                   	ret    
80105c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c10 <uartintr>:

void
uartintr(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c16:	68 a0 5a 10 80       	push   $0x80105aa0
80105c1b:	e8 40 ac ff ff       	call   80100860 <consoleintr>
}
80105c20:	83 c4 10             	add    $0x10,%esp
80105c23:	c9                   	leave  
80105c24:	c3                   	ret    

80105c25 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c25:	6a 00                	push   $0x0
  pushl $0
80105c27:	6a 00                	push   $0x0
  jmp alltraps
80105c29:	e9 13 fb ff ff       	jmp    80105741 <alltraps>

80105c2e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $1
80105c30:	6a 01                	push   $0x1
  jmp alltraps
80105c32:	e9 0a fb ff ff       	jmp    80105741 <alltraps>

80105c37 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c37:	6a 00                	push   $0x0
  pushl $2
80105c39:	6a 02                	push   $0x2
  jmp alltraps
80105c3b:	e9 01 fb ff ff       	jmp    80105741 <alltraps>

80105c40 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $3
80105c42:	6a 03                	push   $0x3
  jmp alltraps
80105c44:	e9 f8 fa ff ff       	jmp    80105741 <alltraps>

80105c49 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $4
80105c4b:	6a 04                	push   $0x4
  jmp alltraps
80105c4d:	e9 ef fa ff ff       	jmp    80105741 <alltraps>

80105c52 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $5
80105c54:	6a 05                	push   $0x5
  jmp alltraps
80105c56:	e9 e6 fa ff ff       	jmp    80105741 <alltraps>

80105c5b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $6
80105c5d:	6a 06                	push   $0x6
  jmp alltraps
80105c5f:	e9 dd fa ff ff       	jmp    80105741 <alltraps>

80105c64 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $7
80105c66:	6a 07                	push   $0x7
  jmp alltraps
80105c68:	e9 d4 fa ff ff       	jmp    80105741 <alltraps>

80105c6d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c6d:	6a 08                	push   $0x8
  jmp alltraps
80105c6f:	e9 cd fa ff ff       	jmp    80105741 <alltraps>

80105c74 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $9
80105c76:	6a 09                	push   $0x9
  jmp alltraps
80105c78:	e9 c4 fa ff ff       	jmp    80105741 <alltraps>

80105c7d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c7d:	6a 0a                	push   $0xa
  jmp alltraps
80105c7f:	e9 bd fa ff ff       	jmp    80105741 <alltraps>

80105c84 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c84:	6a 0b                	push   $0xb
  jmp alltraps
80105c86:	e9 b6 fa ff ff       	jmp    80105741 <alltraps>

80105c8b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c8b:	6a 0c                	push   $0xc
  jmp alltraps
80105c8d:	e9 af fa ff ff       	jmp    80105741 <alltraps>

80105c92 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c92:	6a 0d                	push   $0xd
  jmp alltraps
80105c94:	e9 a8 fa ff ff       	jmp    80105741 <alltraps>

80105c99 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c99:	6a 0e                	push   $0xe
  jmp alltraps
80105c9b:	e9 a1 fa ff ff       	jmp    80105741 <alltraps>

80105ca0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $15
80105ca2:	6a 0f                	push   $0xf
  jmp alltraps
80105ca4:	e9 98 fa ff ff       	jmp    80105741 <alltraps>

80105ca9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $16
80105cab:	6a 10                	push   $0x10
  jmp alltraps
80105cad:	e9 8f fa ff ff       	jmp    80105741 <alltraps>

80105cb2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cb2:	6a 11                	push   $0x11
  jmp alltraps
80105cb4:	e9 88 fa ff ff       	jmp    80105741 <alltraps>

80105cb9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $18
80105cbb:	6a 12                	push   $0x12
  jmp alltraps
80105cbd:	e9 7f fa ff ff       	jmp    80105741 <alltraps>

80105cc2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $19
80105cc4:	6a 13                	push   $0x13
  jmp alltraps
80105cc6:	e9 76 fa ff ff       	jmp    80105741 <alltraps>

80105ccb <vector20>:
.globl vector20
vector20:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $20
80105ccd:	6a 14                	push   $0x14
  jmp alltraps
80105ccf:	e9 6d fa ff ff       	jmp    80105741 <alltraps>

80105cd4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $21
80105cd6:	6a 15                	push   $0x15
  jmp alltraps
80105cd8:	e9 64 fa ff ff       	jmp    80105741 <alltraps>

80105cdd <vector22>:
.globl vector22
vector22:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $22
80105cdf:	6a 16                	push   $0x16
  jmp alltraps
80105ce1:	e9 5b fa ff ff       	jmp    80105741 <alltraps>

80105ce6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $23
80105ce8:	6a 17                	push   $0x17
  jmp alltraps
80105cea:	e9 52 fa ff ff       	jmp    80105741 <alltraps>

80105cef <vector24>:
.globl vector24
vector24:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $24
80105cf1:	6a 18                	push   $0x18
  jmp alltraps
80105cf3:	e9 49 fa ff ff       	jmp    80105741 <alltraps>

80105cf8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $25
80105cfa:	6a 19                	push   $0x19
  jmp alltraps
80105cfc:	e9 40 fa ff ff       	jmp    80105741 <alltraps>

80105d01 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $26
80105d03:	6a 1a                	push   $0x1a
  jmp alltraps
80105d05:	e9 37 fa ff ff       	jmp    80105741 <alltraps>

80105d0a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $27
80105d0c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d0e:	e9 2e fa ff ff       	jmp    80105741 <alltraps>

80105d13 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $28
80105d15:	6a 1c                	push   $0x1c
  jmp alltraps
80105d17:	e9 25 fa ff ff       	jmp    80105741 <alltraps>

80105d1c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $29
80105d1e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d20:	e9 1c fa ff ff       	jmp    80105741 <alltraps>

80105d25 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $30
80105d27:	6a 1e                	push   $0x1e
  jmp alltraps
80105d29:	e9 13 fa ff ff       	jmp    80105741 <alltraps>

80105d2e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $31
80105d30:	6a 1f                	push   $0x1f
  jmp alltraps
80105d32:	e9 0a fa ff ff       	jmp    80105741 <alltraps>

80105d37 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $32
80105d39:	6a 20                	push   $0x20
  jmp alltraps
80105d3b:	e9 01 fa ff ff       	jmp    80105741 <alltraps>

80105d40 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $33
80105d42:	6a 21                	push   $0x21
  jmp alltraps
80105d44:	e9 f8 f9 ff ff       	jmp    80105741 <alltraps>

80105d49 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $34
80105d4b:	6a 22                	push   $0x22
  jmp alltraps
80105d4d:	e9 ef f9 ff ff       	jmp    80105741 <alltraps>

80105d52 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $35
80105d54:	6a 23                	push   $0x23
  jmp alltraps
80105d56:	e9 e6 f9 ff ff       	jmp    80105741 <alltraps>

80105d5b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $36
80105d5d:	6a 24                	push   $0x24
  jmp alltraps
80105d5f:	e9 dd f9 ff ff       	jmp    80105741 <alltraps>

80105d64 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $37
80105d66:	6a 25                	push   $0x25
  jmp alltraps
80105d68:	e9 d4 f9 ff ff       	jmp    80105741 <alltraps>

80105d6d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $38
80105d6f:	6a 26                	push   $0x26
  jmp alltraps
80105d71:	e9 cb f9 ff ff       	jmp    80105741 <alltraps>

80105d76 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $39
80105d78:	6a 27                	push   $0x27
  jmp alltraps
80105d7a:	e9 c2 f9 ff ff       	jmp    80105741 <alltraps>

80105d7f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $40
80105d81:	6a 28                	push   $0x28
  jmp alltraps
80105d83:	e9 b9 f9 ff ff       	jmp    80105741 <alltraps>

80105d88 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $41
80105d8a:	6a 29                	push   $0x29
  jmp alltraps
80105d8c:	e9 b0 f9 ff ff       	jmp    80105741 <alltraps>

80105d91 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $42
80105d93:	6a 2a                	push   $0x2a
  jmp alltraps
80105d95:	e9 a7 f9 ff ff       	jmp    80105741 <alltraps>

80105d9a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $43
80105d9c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d9e:	e9 9e f9 ff ff       	jmp    80105741 <alltraps>

80105da3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $44
80105da5:	6a 2c                	push   $0x2c
  jmp alltraps
80105da7:	e9 95 f9 ff ff       	jmp    80105741 <alltraps>

80105dac <vector45>:
.globl vector45
vector45:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $45
80105dae:	6a 2d                	push   $0x2d
  jmp alltraps
80105db0:	e9 8c f9 ff ff       	jmp    80105741 <alltraps>

80105db5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $46
80105db7:	6a 2e                	push   $0x2e
  jmp alltraps
80105db9:	e9 83 f9 ff ff       	jmp    80105741 <alltraps>

80105dbe <vector47>:
.globl vector47
vector47:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $47
80105dc0:	6a 2f                	push   $0x2f
  jmp alltraps
80105dc2:	e9 7a f9 ff ff       	jmp    80105741 <alltraps>

80105dc7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $48
80105dc9:	6a 30                	push   $0x30
  jmp alltraps
80105dcb:	e9 71 f9 ff ff       	jmp    80105741 <alltraps>

80105dd0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $49
80105dd2:	6a 31                	push   $0x31
  jmp alltraps
80105dd4:	e9 68 f9 ff ff       	jmp    80105741 <alltraps>

80105dd9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $50
80105ddb:	6a 32                	push   $0x32
  jmp alltraps
80105ddd:	e9 5f f9 ff ff       	jmp    80105741 <alltraps>

80105de2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $51
80105de4:	6a 33                	push   $0x33
  jmp alltraps
80105de6:	e9 56 f9 ff ff       	jmp    80105741 <alltraps>

80105deb <vector52>:
.globl vector52
vector52:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $52
80105ded:	6a 34                	push   $0x34
  jmp alltraps
80105def:	e9 4d f9 ff ff       	jmp    80105741 <alltraps>

80105df4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $53
80105df6:	6a 35                	push   $0x35
  jmp alltraps
80105df8:	e9 44 f9 ff ff       	jmp    80105741 <alltraps>

80105dfd <vector54>:
.globl vector54
vector54:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $54
80105dff:	6a 36                	push   $0x36
  jmp alltraps
80105e01:	e9 3b f9 ff ff       	jmp    80105741 <alltraps>

80105e06 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $55
80105e08:	6a 37                	push   $0x37
  jmp alltraps
80105e0a:	e9 32 f9 ff ff       	jmp    80105741 <alltraps>

80105e0f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $56
80105e11:	6a 38                	push   $0x38
  jmp alltraps
80105e13:	e9 29 f9 ff ff       	jmp    80105741 <alltraps>

80105e18 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $57
80105e1a:	6a 39                	push   $0x39
  jmp alltraps
80105e1c:	e9 20 f9 ff ff       	jmp    80105741 <alltraps>

80105e21 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $58
80105e23:	6a 3a                	push   $0x3a
  jmp alltraps
80105e25:	e9 17 f9 ff ff       	jmp    80105741 <alltraps>

80105e2a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $59
80105e2c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e2e:	e9 0e f9 ff ff       	jmp    80105741 <alltraps>

80105e33 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $60
80105e35:	6a 3c                	push   $0x3c
  jmp alltraps
80105e37:	e9 05 f9 ff ff       	jmp    80105741 <alltraps>

80105e3c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $61
80105e3e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e40:	e9 fc f8 ff ff       	jmp    80105741 <alltraps>

80105e45 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $62
80105e47:	6a 3e                	push   $0x3e
  jmp alltraps
80105e49:	e9 f3 f8 ff ff       	jmp    80105741 <alltraps>

80105e4e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $63
80105e50:	6a 3f                	push   $0x3f
  jmp alltraps
80105e52:	e9 ea f8 ff ff       	jmp    80105741 <alltraps>

80105e57 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $64
80105e59:	6a 40                	push   $0x40
  jmp alltraps
80105e5b:	e9 e1 f8 ff ff       	jmp    80105741 <alltraps>

80105e60 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $65
80105e62:	6a 41                	push   $0x41
  jmp alltraps
80105e64:	e9 d8 f8 ff ff       	jmp    80105741 <alltraps>

80105e69 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $66
80105e6b:	6a 42                	push   $0x42
  jmp alltraps
80105e6d:	e9 cf f8 ff ff       	jmp    80105741 <alltraps>

80105e72 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $67
80105e74:	6a 43                	push   $0x43
  jmp alltraps
80105e76:	e9 c6 f8 ff ff       	jmp    80105741 <alltraps>

80105e7b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $68
80105e7d:	6a 44                	push   $0x44
  jmp alltraps
80105e7f:	e9 bd f8 ff ff       	jmp    80105741 <alltraps>

80105e84 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $69
80105e86:	6a 45                	push   $0x45
  jmp alltraps
80105e88:	e9 b4 f8 ff ff       	jmp    80105741 <alltraps>

80105e8d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $70
80105e8f:	6a 46                	push   $0x46
  jmp alltraps
80105e91:	e9 ab f8 ff ff       	jmp    80105741 <alltraps>

80105e96 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $71
80105e98:	6a 47                	push   $0x47
  jmp alltraps
80105e9a:	e9 a2 f8 ff ff       	jmp    80105741 <alltraps>

80105e9f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $72
80105ea1:	6a 48                	push   $0x48
  jmp alltraps
80105ea3:	e9 99 f8 ff ff       	jmp    80105741 <alltraps>

80105ea8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $73
80105eaa:	6a 49                	push   $0x49
  jmp alltraps
80105eac:	e9 90 f8 ff ff       	jmp    80105741 <alltraps>

80105eb1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $74
80105eb3:	6a 4a                	push   $0x4a
  jmp alltraps
80105eb5:	e9 87 f8 ff ff       	jmp    80105741 <alltraps>

80105eba <vector75>:
.globl vector75
vector75:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $75
80105ebc:	6a 4b                	push   $0x4b
  jmp alltraps
80105ebe:	e9 7e f8 ff ff       	jmp    80105741 <alltraps>

80105ec3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $76
80105ec5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ec7:	e9 75 f8 ff ff       	jmp    80105741 <alltraps>

80105ecc <vector77>:
.globl vector77
vector77:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $77
80105ece:	6a 4d                	push   $0x4d
  jmp alltraps
80105ed0:	e9 6c f8 ff ff       	jmp    80105741 <alltraps>

80105ed5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $78
80105ed7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ed9:	e9 63 f8 ff ff       	jmp    80105741 <alltraps>

80105ede <vector79>:
.globl vector79
vector79:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $79
80105ee0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ee2:	e9 5a f8 ff ff       	jmp    80105741 <alltraps>

80105ee7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $80
80105ee9:	6a 50                	push   $0x50
  jmp alltraps
80105eeb:	e9 51 f8 ff ff       	jmp    80105741 <alltraps>

80105ef0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $81
80105ef2:	6a 51                	push   $0x51
  jmp alltraps
80105ef4:	e9 48 f8 ff ff       	jmp    80105741 <alltraps>

80105ef9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $82
80105efb:	6a 52                	push   $0x52
  jmp alltraps
80105efd:	e9 3f f8 ff ff       	jmp    80105741 <alltraps>

80105f02 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $83
80105f04:	6a 53                	push   $0x53
  jmp alltraps
80105f06:	e9 36 f8 ff ff       	jmp    80105741 <alltraps>

80105f0b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $84
80105f0d:	6a 54                	push   $0x54
  jmp alltraps
80105f0f:	e9 2d f8 ff ff       	jmp    80105741 <alltraps>

80105f14 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $85
80105f16:	6a 55                	push   $0x55
  jmp alltraps
80105f18:	e9 24 f8 ff ff       	jmp    80105741 <alltraps>

80105f1d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $86
80105f1f:	6a 56                	push   $0x56
  jmp alltraps
80105f21:	e9 1b f8 ff ff       	jmp    80105741 <alltraps>

80105f26 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $87
80105f28:	6a 57                	push   $0x57
  jmp alltraps
80105f2a:	e9 12 f8 ff ff       	jmp    80105741 <alltraps>

80105f2f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $88
80105f31:	6a 58                	push   $0x58
  jmp alltraps
80105f33:	e9 09 f8 ff ff       	jmp    80105741 <alltraps>

80105f38 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $89
80105f3a:	6a 59                	push   $0x59
  jmp alltraps
80105f3c:	e9 00 f8 ff ff       	jmp    80105741 <alltraps>

80105f41 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $90
80105f43:	6a 5a                	push   $0x5a
  jmp alltraps
80105f45:	e9 f7 f7 ff ff       	jmp    80105741 <alltraps>

80105f4a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $91
80105f4c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f4e:	e9 ee f7 ff ff       	jmp    80105741 <alltraps>

80105f53 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $92
80105f55:	6a 5c                	push   $0x5c
  jmp alltraps
80105f57:	e9 e5 f7 ff ff       	jmp    80105741 <alltraps>

80105f5c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $93
80105f5e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f60:	e9 dc f7 ff ff       	jmp    80105741 <alltraps>

80105f65 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $94
80105f67:	6a 5e                	push   $0x5e
  jmp alltraps
80105f69:	e9 d3 f7 ff ff       	jmp    80105741 <alltraps>

80105f6e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $95
80105f70:	6a 5f                	push   $0x5f
  jmp alltraps
80105f72:	e9 ca f7 ff ff       	jmp    80105741 <alltraps>

80105f77 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $96
80105f79:	6a 60                	push   $0x60
  jmp alltraps
80105f7b:	e9 c1 f7 ff ff       	jmp    80105741 <alltraps>

80105f80 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $97
80105f82:	6a 61                	push   $0x61
  jmp alltraps
80105f84:	e9 b8 f7 ff ff       	jmp    80105741 <alltraps>

80105f89 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $98
80105f8b:	6a 62                	push   $0x62
  jmp alltraps
80105f8d:	e9 af f7 ff ff       	jmp    80105741 <alltraps>

80105f92 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $99
80105f94:	6a 63                	push   $0x63
  jmp alltraps
80105f96:	e9 a6 f7 ff ff       	jmp    80105741 <alltraps>

80105f9b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $100
80105f9d:	6a 64                	push   $0x64
  jmp alltraps
80105f9f:	e9 9d f7 ff ff       	jmp    80105741 <alltraps>

80105fa4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $101
80105fa6:	6a 65                	push   $0x65
  jmp alltraps
80105fa8:	e9 94 f7 ff ff       	jmp    80105741 <alltraps>

80105fad <vector102>:
.globl vector102
vector102:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $102
80105faf:	6a 66                	push   $0x66
  jmp alltraps
80105fb1:	e9 8b f7 ff ff       	jmp    80105741 <alltraps>

80105fb6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $103
80105fb8:	6a 67                	push   $0x67
  jmp alltraps
80105fba:	e9 82 f7 ff ff       	jmp    80105741 <alltraps>

80105fbf <vector104>:
.globl vector104
vector104:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $104
80105fc1:	6a 68                	push   $0x68
  jmp alltraps
80105fc3:	e9 79 f7 ff ff       	jmp    80105741 <alltraps>

80105fc8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $105
80105fca:	6a 69                	push   $0x69
  jmp alltraps
80105fcc:	e9 70 f7 ff ff       	jmp    80105741 <alltraps>

80105fd1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $106
80105fd3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fd5:	e9 67 f7 ff ff       	jmp    80105741 <alltraps>

80105fda <vector107>:
.globl vector107
vector107:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $107
80105fdc:	6a 6b                	push   $0x6b
  jmp alltraps
80105fde:	e9 5e f7 ff ff       	jmp    80105741 <alltraps>

80105fe3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $108
80105fe5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fe7:	e9 55 f7 ff ff       	jmp    80105741 <alltraps>

80105fec <vector109>:
.globl vector109
vector109:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $109
80105fee:	6a 6d                	push   $0x6d
  jmp alltraps
80105ff0:	e9 4c f7 ff ff       	jmp    80105741 <alltraps>

80105ff5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $110
80105ff7:	6a 6e                	push   $0x6e
  jmp alltraps
80105ff9:	e9 43 f7 ff ff       	jmp    80105741 <alltraps>

80105ffe <vector111>:
.globl vector111
vector111:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $111
80106000:	6a 6f                	push   $0x6f
  jmp alltraps
80106002:	e9 3a f7 ff ff       	jmp    80105741 <alltraps>

80106007 <vector112>:
.globl vector112
vector112:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $112
80106009:	6a 70                	push   $0x70
  jmp alltraps
8010600b:	e9 31 f7 ff ff       	jmp    80105741 <alltraps>

80106010 <vector113>:
.globl vector113
vector113:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $113
80106012:	6a 71                	push   $0x71
  jmp alltraps
80106014:	e9 28 f7 ff ff       	jmp    80105741 <alltraps>

80106019 <vector114>:
.globl vector114
vector114:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $114
8010601b:	6a 72                	push   $0x72
  jmp alltraps
8010601d:	e9 1f f7 ff ff       	jmp    80105741 <alltraps>

80106022 <vector115>:
.globl vector115
vector115:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $115
80106024:	6a 73                	push   $0x73
  jmp alltraps
80106026:	e9 16 f7 ff ff       	jmp    80105741 <alltraps>

8010602b <vector116>:
.globl vector116
vector116:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $116
8010602d:	6a 74                	push   $0x74
  jmp alltraps
8010602f:	e9 0d f7 ff ff       	jmp    80105741 <alltraps>

80106034 <vector117>:
.globl vector117
vector117:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $117
80106036:	6a 75                	push   $0x75
  jmp alltraps
80106038:	e9 04 f7 ff ff       	jmp    80105741 <alltraps>

8010603d <vector118>:
.globl vector118
vector118:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $118
8010603f:	6a 76                	push   $0x76
  jmp alltraps
80106041:	e9 fb f6 ff ff       	jmp    80105741 <alltraps>

80106046 <vector119>:
.globl vector119
vector119:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $119
80106048:	6a 77                	push   $0x77
  jmp alltraps
8010604a:	e9 f2 f6 ff ff       	jmp    80105741 <alltraps>

8010604f <vector120>:
.globl vector120
vector120:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $120
80106051:	6a 78                	push   $0x78
  jmp alltraps
80106053:	e9 e9 f6 ff ff       	jmp    80105741 <alltraps>

80106058 <vector121>:
.globl vector121
vector121:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $121
8010605a:	6a 79                	push   $0x79
  jmp alltraps
8010605c:	e9 e0 f6 ff ff       	jmp    80105741 <alltraps>

80106061 <vector122>:
.globl vector122
vector122:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $122
80106063:	6a 7a                	push   $0x7a
  jmp alltraps
80106065:	e9 d7 f6 ff ff       	jmp    80105741 <alltraps>

8010606a <vector123>:
.globl vector123
vector123:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $123
8010606c:	6a 7b                	push   $0x7b
  jmp alltraps
8010606e:	e9 ce f6 ff ff       	jmp    80105741 <alltraps>

80106073 <vector124>:
.globl vector124
vector124:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $124
80106075:	6a 7c                	push   $0x7c
  jmp alltraps
80106077:	e9 c5 f6 ff ff       	jmp    80105741 <alltraps>

8010607c <vector125>:
.globl vector125
vector125:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $125
8010607e:	6a 7d                	push   $0x7d
  jmp alltraps
80106080:	e9 bc f6 ff ff       	jmp    80105741 <alltraps>

80106085 <vector126>:
.globl vector126
vector126:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $126
80106087:	6a 7e                	push   $0x7e
  jmp alltraps
80106089:	e9 b3 f6 ff ff       	jmp    80105741 <alltraps>

8010608e <vector127>:
.globl vector127
vector127:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $127
80106090:	6a 7f                	push   $0x7f
  jmp alltraps
80106092:	e9 aa f6 ff ff       	jmp    80105741 <alltraps>

80106097 <vector128>:
.globl vector128
vector128:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $128
80106099:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010609e:	e9 9e f6 ff ff       	jmp    80105741 <alltraps>

801060a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $129
801060a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060aa:	e9 92 f6 ff ff       	jmp    80105741 <alltraps>

801060af <vector130>:
.globl vector130
vector130:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $130
801060b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060b6:	e9 86 f6 ff ff       	jmp    80105741 <alltraps>

801060bb <vector131>:
.globl vector131
vector131:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $131
801060bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060c2:	e9 7a f6 ff ff       	jmp    80105741 <alltraps>

801060c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $132
801060c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060ce:	e9 6e f6 ff ff       	jmp    80105741 <alltraps>

801060d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $133
801060d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060da:	e9 62 f6 ff ff       	jmp    80105741 <alltraps>

801060df <vector134>:
.globl vector134
vector134:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $134
801060e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060e6:	e9 56 f6 ff ff       	jmp    80105741 <alltraps>

801060eb <vector135>:
.globl vector135
vector135:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $135
801060ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060f2:	e9 4a f6 ff ff       	jmp    80105741 <alltraps>

801060f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $136
801060f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060fe:	e9 3e f6 ff ff       	jmp    80105741 <alltraps>

80106103 <vector137>:
.globl vector137
vector137:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $137
80106105:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010610a:	e9 32 f6 ff ff       	jmp    80105741 <alltraps>

8010610f <vector138>:
.globl vector138
vector138:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $138
80106111:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106116:	e9 26 f6 ff ff       	jmp    80105741 <alltraps>

8010611b <vector139>:
.globl vector139
vector139:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $139
8010611d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106122:	e9 1a f6 ff ff       	jmp    80105741 <alltraps>

80106127 <vector140>:
.globl vector140
vector140:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $140
80106129:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010612e:	e9 0e f6 ff ff       	jmp    80105741 <alltraps>

80106133 <vector141>:
.globl vector141
vector141:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $141
80106135:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010613a:	e9 02 f6 ff ff       	jmp    80105741 <alltraps>

8010613f <vector142>:
.globl vector142
vector142:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $142
80106141:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106146:	e9 f6 f5 ff ff       	jmp    80105741 <alltraps>

8010614b <vector143>:
.globl vector143
vector143:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $143
8010614d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106152:	e9 ea f5 ff ff       	jmp    80105741 <alltraps>

80106157 <vector144>:
.globl vector144
vector144:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $144
80106159:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010615e:	e9 de f5 ff ff       	jmp    80105741 <alltraps>

80106163 <vector145>:
.globl vector145
vector145:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $145
80106165:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010616a:	e9 d2 f5 ff ff       	jmp    80105741 <alltraps>

8010616f <vector146>:
.globl vector146
vector146:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $146
80106171:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106176:	e9 c6 f5 ff ff       	jmp    80105741 <alltraps>

8010617b <vector147>:
.globl vector147
vector147:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $147
8010617d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106182:	e9 ba f5 ff ff       	jmp    80105741 <alltraps>

80106187 <vector148>:
.globl vector148
vector148:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $148
80106189:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010618e:	e9 ae f5 ff ff       	jmp    80105741 <alltraps>

80106193 <vector149>:
.globl vector149
vector149:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $149
80106195:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010619a:	e9 a2 f5 ff ff       	jmp    80105741 <alltraps>

8010619f <vector150>:
.globl vector150
vector150:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $150
801061a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061a6:	e9 96 f5 ff ff       	jmp    80105741 <alltraps>

801061ab <vector151>:
.globl vector151
vector151:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $151
801061ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061b2:	e9 8a f5 ff ff       	jmp    80105741 <alltraps>

801061b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $152
801061b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061be:	e9 7e f5 ff ff       	jmp    80105741 <alltraps>

801061c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $153
801061c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061ca:	e9 72 f5 ff ff       	jmp    80105741 <alltraps>

801061cf <vector154>:
.globl vector154
vector154:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $154
801061d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061d6:	e9 66 f5 ff ff       	jmp    80105741 <alltraps>

801061db <vector155>:
.globl vector155
vector155:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $155
801061dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061e2:	e9 5a f5 ff ff       	jmp    80105741 <alltraps>

801061e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $156
801061e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061ee:	e9 4e f5 ff ff       	jmp    80105741 <alltraps>

801061f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $157
801061f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061fa:	e9 42 f5 ff ff       	jmp    80105741 <alltraps>

801061ff <vector158>:
.globl vector158
vector158:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $158
80106201:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106206:	e9 36 f5 ff ff       	jmp    80105741 <alltraps>

8010620b <vector159>:
.globl vector159
vector159:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $159
8010620d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106212:	e9 2a f5 ff ff       	jmp    80105741 <alltraps>

80106217 <vector160>:
.globl vector160
vector160:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $160
80106219:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010621e:	e9 1e f5 ff ff       	jmp    80105741 <alltraps>

80106223 <vector161>:
.globl vector161
vector161:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $161
80106225:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010622a:	e9 12 f5 ff ff       	jmp    80105741 <alltraps>

8010622f <vector162>:
.globl vector162
vector162:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $162
80106231:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106236:	e9 06 f5 ff ff       	jmp    80105741 <alltraps>

8010623b <vector163>:
.globl vector163
vector163:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $163
8010623d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106242:	e9 fa f4 ff ff       	jmp    80105741 <alltraps>

80106247 <vector164>:
.globl vector164
vector164:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $164
80106249:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010624e:	e9 ee f4 ff ff       	jmp    80105741 <alltraps>

80106253 <vector165>:
.globl vector165
vector165:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $165
80106255:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010625a:	e9 e2 f4 ff ff       	jmp    80105741 <alltraps>

8010625f <vector166>:
.globl vector166
vector166:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $166
80106261:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106266:	e9 d6 f4 ff ff       	jmp    80105741 <alltraps>

8010626b <vector167>:
.globl vector167
vector167:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $167
8010626d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106272:	e9 ca f4 ff ff       	jmp    80105741 <alltraps>

80106277 <vector168>:
.globl vector168
vector168:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $168
80106279:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010627e:	e9 be f4 ff ff       	jmp    80105741 <alltraps>

80106283 <vector169>:
.globl vector169
vector169:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $169
80106285:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010628a:	e9 b2 f4 ff ff       	jmp    80105741 <alltraps>

8010628f <vector170>:
.globl vector170
vector170:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $170
80106291:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106296:	e9 a6 f4 ff ff       	jmp    80105741 <alltraps>

8010629b <vector171>:
.globl vector171
vector171:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $171
8010629d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062a2:	e9 9a f4 ff ff       	jmp    80105741 <alltraps>

801062a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $172
801062a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062ae:	e9 8e f4 ff ff       	jmp    80105741 <alltraps>

801062b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $173
801062b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062ba:	e9 82 f4 ff ff       	jmp    80105741 <alltraps>

801062bf <vector174>:
.globl vector174
vector174:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $174
801062c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062c6:	e9 76 f4 ff ff       	jmp    80105741 <alltraps>

801062cb <vector175>:
.globl vector175
vector175:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $175
801062cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062d2:	e9 6a f4 ff ff       	jmp    80105741 <alltraps>

801062d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $176
801062d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062de:	e9 5e f4 ff ff       	jmp    80105741 <alltraps>

801062e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $177
801062e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062ea:	e9 52 f4 ff ff       	jmp    80105741 <alltraps>

801062ef <vector178>:
.globl vector178
vector178:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $178
801062f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062f6:	e9 46 f4 ff ff       	jmp    80105741 <alltraps>

801062fb <vector179>:
.globl vector179
vector179:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $179
801062fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106302:	e9 3a f4 ff ff       	jmp    80105741 <alltraps>

80106307 <vector180>:
.globl vector180
vector180:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $180
80106309:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010630e:	e9 2e f4 ff ff       	jmp    80105741 <alltraps>

80106313 <vector181>:
.globl vector181
vector181:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $181
80106315:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010631a:	e9 22 f4 ff ff       	jmp    80105741 <alltraps>

8010631f <vector182>:
.globl vector182
vector182:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $182
80106321:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106326:	e9 16 f4 ff ff       	jmp    80105741 <alltraps>

8010632b <vector183>:
.globl vector183
vector183:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $183
8010632d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106332:	e9 0a f4 ff ff       	jmp    80105741 <alltraps>

80106337 <vector184>:
.globl vector184
vector184:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $184
80106339:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010633e:	e9 fe f3 ff ff       	jmp    80105741 <alltraps>

80106343 <vector185>:
.globl vector185
vector185:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $185
80106345:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010634a:	e9 f2 f3 ff ff       	jmp    80105741 <alltraps>

8010634f <vector186>:
.globl vector186
vector186:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $186
80106351:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106356:	e9 e6 f3 ff ff       	jmp    80105741 <alltraps>

8010635b <vector187>:
.globl vector187
vector187:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $187
8010635d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106362:	e9 da f3 ff ff       	jmp    80105741 <alltraps>

80106367 <vector188>:
.globl vector188
vector188:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $188
80106369:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010636e:	e9 ce f3 ff ff       	jmp    80105741 <alltraps>

80106373 <vector189>:
.globl vector189
vector189:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $189
80106375:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010637a:	e9 c2 f3 ff ff       	jmp    80105741 <alltraps>

8010637f <vector190>:
.globl vector190
vector190:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $190
80106381:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106386:	e9 b6 f3 ff ff       	jmp    80105741 <alltraps>

8010638b <vector191>:
.globl vector191
vector191:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $191
8010638d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106392:	e9 aa f3 ff ff       	jmp    80105741 <alltraps>

80106397 <vector192>:
.globl vector192
vector192:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $192
80106399:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010639e:	e9 9e f3 ff ff       	jmp    80105741 <alltraps>

801063a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $193
801063a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063aa:	e9 92 f3 ff ff       	jmp    80105741 <alltraps>

801063af <vector194>:
.globl vector194
vector194:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $194
801063b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063b6:	e9 86 f3 ff ff       	jmp    80105741 <alltraps>

801063bb <vector195>:
.globl vector195
vector195:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $195
801063bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063c2:	e9 7a f3 ff ff       	jmp    80105741 <alltraps>

801063c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $196
801063c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063ce:	e9 6e f3 ff ff       	jmp    80105741 <alltraps>

801063d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $197
801063d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063da:	e9 62 f3 ff ff       	jmp    80105741 <alltraps>

801063df <vector198>:
.globl vector198
vector198:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $198
801063e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063e6:	e9 56 f3 ff ff       	jmp    80105741 <alltraps>

801063eb <vector199>:
.globl vector199
vector199:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $199
801063ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063f2:	e9 4a f3 ff ff       	jmp    80105741 <alltraps>

801063f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $200
801063f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063fe:	e9 3e f3 ff ff       	jmp    80105741 <alltraps>

80106403 <vector201>:
.globl vector201
vector201:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $201
80106405:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010640a:	e9 32 f3 ff ff       	jmp    80105741 <alltraps>

8010640f <vector202>:
.globl vector202
vector202:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $202
80106411:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106416:	e9 26 f3 ff ff       	jmp    80105741 <alltraps>

8010641b <vector203>:
.globl vector203
vector203:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $203
8010641d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106422:	e9 1a f3 ff ff       	jmp    80105741 <alltraps>

80106427 <vector204>:
.globl vector204
vector204:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $204
80106429:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010642e:	e9 0e f3 ff ff       	jmp    80105741 <alltraps>

80106433 <vector205>:
.globl vector205
vector205:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $205
80106435:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010643a:	e9 02 f3 ff ff       	jmp    80105741 <alltraps>

8010643f <vector206>:
.globl vector206
vector206:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $206
80106441:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106446:	e9 f6 f2 ff ff       	jmp    80105741 <alltraps>

8010644b <vector207>:
.globl vector207
vector207:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $207
8010644d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106452:	e9 ea f2 ff ff       	jmp    80105741 <alltraps>

80106457 <vector208>:
.globl vector208
vector208:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $208
80106459:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010645e:	e9 de f2 ff ff       	jmp    80105741 <alltraps>

80106463 <vector209>:
.globl vector209
vector209:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $209
80106465:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010646a:	e9 d2 f2 ff ff       	jmp    80105741 <alltraps>

8010646f <vector210>:
.globl vector210
vector210:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $210
80106471:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106476:	e9 c6 f2 ff ff       	jmp    80105741 <alltraps>

8010647b <vector211>:
.globl vector211
vector211:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $211
8010647d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106482:	e9 ba f2 ff ff       	jmp    80105741 <alltraps>

80106487 <vector212>:
.globl vector212
vector212:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $212
80106489:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010648e:	e9 ae f2 ff ff       	jmp    80105741 <alltraps>

80106493 <vector213>:
.globl vector213
vector213:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $213
80106495:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010649a:	e9 a2 f2 ff ff       	jmp    80105741 <alltraps>

8010649f <vector214>:
.globl vector214
vector214:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $214
801064a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064a6:	e9 96 f2 ff ff       	jmp    80105741 <alltraps>

801064ab <vector215>:
.globl vector215
vector215:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $215
801064ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064b2:	e9 8a f2 ff ff       	jmp    80105741 <alltraps>

801064b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $216
801064b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064be:	e9 7e f2 ff ff       	jmp    80105741 <alltraps>

801064c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $217
801064c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064ca:	e9 72 f2 ff ff       	jmp    80105741 <alltraps>

801064cf <vector218>:
.globl vector218
vector218:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $218
801064d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064d6:	e9 66 f2 ff ff       	jmp    80105741 <alltraps>

801064db <vector219>:
.globl vector219
vector219:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $219
801064dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064e2:	e9 5a f2 ff ff       	jmp    80105741 <alltraps>

801064e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $220
801064e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064ee:	e9 4e f2 ff ff       	jmp    80105741 <alltraps>

801064f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $221
801064f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064fa:	e9 42 f2 ff ff       	jmp    80105741 <alltraps>

801064ff <vector222>:
.globl vector222
vector222:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $222
80106501:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106506:	e9 36 f2 ff ff       	jmp    80105741 <alltraps>

8010650b <vector223>:
.globl vector223
vector223:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $223
8010650d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106512:	e9 2a f2 ff ff       	jmp    80105741 <alltraps>

80106517 <vector224>:
.globl vector224
vector224:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $224
80106519:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010651e:	e9 1e f2 ff ff       	jmp    80105741 <alltraps>

80106523 <vector225>:
.globl vector225
vector225:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $225
80106525:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010652a:	e9 12 f2 ff ff       	jmp    80105741 <alltraps>

8010652f <vector226>:
.globl vector226
vector226:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $226
80106531:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106536:	e9 06 f2 ff ff       	jmp    80105741 <alltraps>

8010653b <vector227>:
.globl vector227
vector227:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $227
8010653d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106542:	e9 fa f1 ff ff       	jmp    80105741 <alltraps>

80106547 <vector228>:
.globl vector228
vector228:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $228
80106549:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010654e:	e9 ee f1 ff ff       	jmp    80105741 <alltraps>

80106553 <vector229>:
.globl vector229
vector229:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $229
80106555:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010655a:	e9 e2 f1 ff ff       	jmp    80105741 <alltraps>

8010655f <vector230>:
.globl vector230
vector230:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $230
80106561:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106566:	e9 d6 f1 ff ff       	jmp    80105741 <alltraps>

8010656b <vector231>:
.globl vector231
vector231:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $231
8010656d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106572:	e9 ca f1 ff ff       	jmp    80105741 <alltraps>

80106577 <vector232>:
.globl vector232
vector232:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $232
80106579:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010657e:	e9 be f1 ff ff       	jmp    80105741 <alltraps>

80106583 <vector233>:
.globl vector233
vector233:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $233
80106585:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010658a:	e9 b2 f1 ff ff       	jmp    80105741 <alltraps>

8010658f <vector234>:
.globl vector234
vector234:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $234
80106591:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106596:	e9 a6 f1 ff ff       	jmp    80105741 <alltraps>

8010659b <vector235>:
.globl vector235
vector235:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $235
8010659d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065a2:	e9 9a f1 ff ff       	jmp    80105741 <alltraps>

801065a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $236
801065a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065ae:	e9 8e f1 ff ff       	jmp    80105741 <alltraps>

801065b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $237
801065b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065ba:	e9 82 f1 ff ff       	jmp    80105741 <alltraps>

801065bf <vector238>:
.globl vector238
vector238:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $238
801065c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065c6:	e9 76 f1 ff ff       	jmp    80105741 <alltraps>

801065cb <vector239>:
.globl vector239
vector239:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $239
801065cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065d2:	e9 6a f1 ff ff       	jmp    80105741 <alltraps>

801065d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $240
801065d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065de:	e9 5e f1 ff ff       	jmp    80105741 <alltraps>

801065e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $241
801065e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065ea:	e9 52 f1 ff ff       	jmp    80105741 <alltraps>

801065ef <vector242>:
.globl vector242
vector242:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $242
801065f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065f6:	e9 46 f1 ff ff       	jmp    80105741 <alltraps>

801065fb <vector243>:
.globl vector243
vector243:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $243
801065fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106602:	e9 3a f1 ff ff       	jmp    80105741 <alltraps>

80106607 <vector244>:
.globl vector244
vector244:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $244
80106609:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010660e:	e9 2e f1 ff ff       	jmp    80105741 <alltraps>

80106613 <vector245>:
.globl vector245
vector245:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $245
80106615:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010661a:	e9 22 f1 ff ff       	jmp    80105741 <alltraps>

8010661f <vector246>:
.globl vector246
vector246:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $246
80106621:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106626:	e9 16 f1 ff ff       	jmp    80105741 <alltraps>

8010662b <vector247>:
.globl vector247
vector247:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $247
8010662d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106632:	e9 0a f1 ff ff       	jmp    80105741 <alltraps>

80106637 <vector248>:
.globl vector248
vector248:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $248
80106639:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010663e:	e9 fe f0 ff ff       	jmp    80105741 <alltraps>

80106643 <vector249>:
.globl vector249
vector249:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $249
80106645:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010664a:	e9 f2 f0 ff ff       	jmp    80105741 <alltraps>

8010664f <vector250>:
.globl vector250
vector250:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $250
80106651:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106656:	e9 e6 f0 ff ff       	jmp    80105741 <alltraps>

8010665b <vector251>:
.globl vector251
vector251:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $251
8010665d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106662:	e9 da f0 ff ff       	jmp    80105741 <alltraps>

80106667 <vector252>:
.globl vector252
vector252:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $252
80106669:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010666e:	e9 ce f0 ff ff       	jmp    80105741 <alltraps>

80106673 <vector253>:
.globl vector253
vector253:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $253
80106675:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010667a:	e9 c2 f0 ff ff       	jmp    80105741 <alltraps>

8010667f <vector254>:
.globl vector254
vector254:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $254
80106681:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106686:	e9 b6 f0 ff ff       	jmp    80105741 <alltraps>

8010668b <vector255>:
.globl vector255
vector255:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $255
8010668d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106692:	e9 aa f0 ff ff       	jmp    80105741 <alltraps>
80106697:	66 90                	xchg   %ax,%ax
80106699:	66 90                	xchg   %ax,%ax
8010669b:	66 90                	xchg   %ax,%ax
8010669d:	66 90                	xchg   %ax,%ax
8010669f:	90                   	nop

801066a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	57                   	push   %edi
801066a4:	56                   	push   %esi
801066a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066a7:	c1 ea 16             	shr    $0x16,%edx
{
801066aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801066ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801066ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801066b1:	8b 07                	mov    (%edi),%eax
801066b3:	a8 01                	test   $0x1,%al
801066b5:	74 29                	je     801066e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066bc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066c2:	c1 ee 0a             	shr    $0xa,%esi
}
801066c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801066c8:	89 f2                	mov    %esi,%edx
801066ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066d0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801066d3:	5b                   	pop    %ebx
801066d4:	5e                   	pop    %esi
801066d5:	5f                   	pop    %edi
801066d6:	5d                   	pop    %ebp
801066d7:	c3                   	ret    
801066d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066df:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066e0:	85 c9                	test   %ecx,%ecx
801066e2:	74 2c                	je     80106710 <walkpgdir+0x70>
801066e4:	e8 c7 be ff ff       	call   801025b0 <kalloc>
801066e9:	89 c3                	mov    %eax,%ebx
801066eb:	85 c0                	test   %eax,%eax
801066ed:	74 21                	je     80106710 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801066ef:	83 ec 04             	sub    $0x4,%esp
801066f2:	68 00 10 00 00       	push   $0x1000
801066f7:	6a 00                	push   $0x0
801066f9:	50                   	push   %eax
801066fa:	e8 61 de ff ff       	call   80104560 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106705:	83 c4 10             	add    $0x10,%esp
80106708:	83 c8 07             	or     $0x7,%eax
8010670b:	89 07                	mov    %eax,(%edi)
8010670d:	eb b3                	jmp    801066c2 <walkpgdir+0x22>
8010670f:	90                   	nop
}
80106710:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106713:	31 c0                	xor    %eax,%eax
}
80106715:	5b                   	pop    %ebx
80106716:	5e                   	pop    %esi
80106717:	5f                   	pop    %edi
80106718:	5d                   	pop    %ebp
80106719:	c3                   	ret    
8010671a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106720 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106725:	89 d6                	mov    %edx,%esi
{
80106727:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106728:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010672e:	83 ec 1c             	sub    $0x1c,%esp
80106731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106734:	8b 7d 08             	mov    0x8(%ebp),%edi
80106737:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010673b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106740:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106743:	29 f7                	sub    %esi,%edi
80106745:	eb 21                	jmp    80106768 <mappages+0x48>
80106747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106750:	f6 00 01             	testb  $0x1,(%eax)
80106753:	75 45                	jne    8010679a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106755:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106758:	83 cb 01             	or     $0x1,%ebx
8010675b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010675d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106760:	74 2e                	je     80106790 <mappages+0x70>
      break;
    a += PGSIZE;
80106762:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010676b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106770:	89 f2                	mov    %esi,%edx
80106772:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106775:	e8 26 ff ff ff       	call   801066a0 <walkpgdir>
8010677a:	85 c0                	test   %eax,%eax
8010677c:	75 d2                	jne    80106750 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010677e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106786:	5b                   	pop    %ebx
80106787:	5e                   	pop    %esi
80106788:	5f                   	pop    %edi
80106789:	5d                   	pop    %ebp
8010678a:	c3                   	ret    
8010678b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010678f:	90                   	nop
80106790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106793:	31 c0                	xor    %eax,%eax
}
80106795:	5b                   	pop    %ebx
80106796:	5e                   	pop    %esi
80106797:	5f                   	pop    %edi
80106798:	5d                   	pop    %ebp
80106799:	c3                   	ret    
      panic("remap");
8010679a:	83 ec 0c             	sub    $0xc,%esp
8010679d:	68 90 78 10 80       	push   $0x80107890
801067a2:	e8 e9 9b ff ff       	call   80100390 <panic>
801067a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ae:	66 90                	xchg   %ax,%ax

801067b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	89 c7                	mov    %eax,%edi
801067b6:	56                   	push   %esi
801067b7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067b8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067c4:	83 ec 1c             	sub    $0x1c,%esp
801067c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801067ca:	39 d3                	cmp    %edx,%ebx
801067cc:	73 5a                	jae    80106828 <deallocuvm.part.0+0x78>
801067ce:	89 d6                	mov    %edx,%esi
801067d0:	eb 10                	jmp    801067e2 <deallocuvm.part.0+0x32>
801067d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067de:	39 de                	cmp    %ebx,%esi
801067e0:	76 46                	jbe    80106828 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067e2:	31 c9                	xor    %ecx,%ecx
801067e4:	89 da                	mov    %ebx,%edx
801067e6:	89 f8                	mov    %edi,%eax
801067e8:	e8 b3 fe ff ff       	call   801066a0 <walkpgdir>
    if(!pte)
801067ed:	85 c0                	test   %eax,%eax
801067ef:	74 47                	je     80106838 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801067f1:	8b 10                	mov    (%eax),%edx
801067f3:	f6 c2 01             	test   $0x1,%dl
801067f6:	74 e0                	je     801067d8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801067f8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067fe:	74 46                	je     80106846 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106800:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106803:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010680c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106812:	52                   	push   %edx
80106813:	e8 d8 bb ff ff       	call   801023f0 <kfree>
      *pte = 0;
80106818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010681b:	83 c4 10             	add    $0x10,%esp
8010681e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106824:	39 de                	cmp    %ebx,%esi
80106826:	77 ba                	ja     801067e2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010682b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010682e:	5b                   	pop    %ebx
8010682f:	5e                   	pop    %esi
80106830:	5f                   	pop    %edi
80106831:	5d                   	pop    %ebp
80106832:	c3                   	ret    
80106833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106837:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106838:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010683e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106844:	eb 98                	jmp    801067de <deallocuvm.part.0+0x2e>
        panic("kfree");
80106846:	83 ec 0c             	sub    $0xc,%esp
80106849:	68 26 72 10 80       	push   $0x80107226
8010684e:	e8 3d 9b ff ff       	call   80100390 <panic>
80106853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106860 <seginit>:
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106866:	e8 55 d0 ff ff       	call   801038c0 <cpuid>
  pd[0] = size-1;
8010686b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106870:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106876:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010687a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106881:	ff 00 00 
80106884:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010688b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010688e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106895:	ff 00 00 
80106898:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
8010689f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068a2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801068a9:	ff 00 00 
801068ac:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801068b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068b6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801068bd:	ff 00 00 
801068c0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801068c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801068ca:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
801068cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068d3:	c1 e8 10             	shr    $0x10,%eax
801068d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801068da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068dd:	0f 01 10             	lgdtl  (%eax)
}
801068e0:	c9                   	leave  
801068e1:	c3                   	ret    
801068e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068f0:	a1 a4 54 11 80       	mov    0x801154a4,%eax
801068f5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068fa:	0f 22 d8             	mov    %eax,%cr3
}
801068fd:	c3                   	ret    
801068fe:	66 90                	xchg   %ax,%ax

80106900 <switchuvm>:
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 1c             	sub    $0x1c,%esp
80106909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010690c:	85 db                	test   %ebx,%ebx
8010690e:	0f 84 cb 00 00 00    	je     801069df <switchuvm+0xdf>
  if(p->kstack == 0)
80106914:	8b 43 08             	mov    0x8(%ebx),%eax
80106917:	85 c0                	test   %eax,%eax
80106919:	0f 84 da 00 00 00    	je     801069f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010691f:	8b 43 04             	mov    0x4(%ebx),%eax
80106922:	85 c0                	test   %eax,%eax
80106924:	0f 84 c2 00 00 00    	je     801069ec <switchuvm+0xec>
  pushcli();
8010692a:	e8 71 da ff ff       	call   801043a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010692f:	e8 0c cf ff ff       	call   80103840 <mycpu>
80106934:	89 c6                	mov    %eax,%esi
80106936:	e8 05 cf ff ff       	call   80103840 <mycpu>
8010693b:	89 c7                	mov    %eax,%edi
8010693d:	e8 fe ce ff ff       	call   80103840 <mycpu>
80106942:	83 c7 08             	add    $0x8,%edi
80106945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106948:	e8 f3 ce ff ff       	call   80103840 <mycpu>
8010694d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106950:	ba 67 00 00 00       	mov    $0x67,%edx
80106955:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010695c:	83 c0 08             	add    $0x8,%eax
8010695f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106966:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010696b:	83 c1 08             	add    $0x8,%ecx
8010696e:	c1 e8 18             	shr    $0x18,%eax
80106971:	c1 e9 10             	shr    $0x10,%ecx
80106974:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
8010697a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106980:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106985:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010698c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106991:	e8 aa ce ff ff       	call   80103840 <mycpu>
80106996:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010699d:	e8 9e ce ff ff       	call   80103840 <mycpu>
801069a2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069a6:	8b 73 08             	mov    0x8(%ebx),%esi
801069a9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069af:	e8 8c ce ff ff       	call   80103840 <mycpu>
801069b4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069b7:	e8 84 ce ff ff       	call   80103840 <mycpu>
801069bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801069c0:	b8 28 00 00 00       	mov    $0x28,%eax
801069c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801069c8:	8b 43 04             	mov    0x4(%ebx),%eax
801069cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069d0:	0f 22 d8             	mov    %eax,%cr3
}
801069d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069d6:	5b                   	pop    %ebx
801069d7:	5e                   	pop    %esi
801069d8:	5f                   	pop    %edi
801069d9:	5d                   	pop    %ebp
  popcli();
801069da:	e9 d1 da ff ff       	jmp    801044b0 <popcli>
    panic("switchuvm: no process");
801069df:	83 ec 0c             	sub    $0xc,%esp
801069e2:	68 96 78 10 80       	push   $0x80107896
801069e7:	e8 a4 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801069ec:	83 ec 0c             	sub    $0xc,%esp
801069ef:	68 c1 78 10 80       	push   $0x801078c1
801069f4:	e8 97 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801069f9:	83 ec 0c             	sub    $0xc,%esp
801069fc:	68 ac 78 10 80       	push   $0x801078ac
80106a01:	e8 8a 99 ff ff       	call   80100390 <panic>
80106a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a0d:	8d 76 00             	lea    0x0(%esi),%esi

80106a10 <inituvm>:
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	57                   	push   %edi
80106a14:	56                   	push   %esi
80106a15:	53                   	push   %ebx
80106a16:	83 ec 1c             	sub    $0x1c,%esp
80106a19:	8b 45 08             	mov    0x8(%ebp),%eax
80106a1c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a25:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a2b:	77 49                	ja     80106a76 <inituvm+0x66>
  mem = kalloc();
80106a2d:	e8 7e bb ff ff       	call   801025b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a32:	83 ec 04             	sub    $0x4,%esp
80106a35:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106a3a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a3c:	6a 00                	push   $0x0
80106a3e:	50                   	push   %eax
80106a3f:	e8 1c db ff ff       	call   80104560 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a44:	58                   	pop    %eax
80106a45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a4b:	5a                   	pop    %edx
80106a4c:	6a 06                	push   $0x6
80106a4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a53:	31 d2                	xor    %edx,%edx
80106a55:	50                   	push   %eax
80106a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a59:	e8 c2 fc ff ff       	call   80106720 <mappages>
  memmove(mem, init, sz);
80106a5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a61:	83 c4 10             	add    $0x10,%esp
80106a64:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a6d:	5b                   	pop    %ebx
80106a6e:	5e                   	pop    %esi
80106a6f:	5f                   	pop    %edi
80106a70:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a71:	e9 8a db ff ff       	jmp    80104600 <memmove>
    panic("inituvm: more than a page");
80106a76:	83 ec 0c             	sub    $0xc,%esp
80106a79:	68 d5 78 10 80       	push   $0x801078d5
80106a7e:	e8 0d 99 ff ff       	call   80100390 <panic>
80106a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a90 <loaduvm>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 1c             	sub    $0x1c,%esp
80106a99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a9c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106a9f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106aa4:	0f 85 8d 00 00 00    	jne    80106b37 <loaduvm+0xa7>
80106aaa:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106aac:	89 f3                	mov    %esi,%ebx
80106aae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ab1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ab4:	01 f0                	add    %esi,%eax
80106ab6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ab9:	85 f6                	test   %esi,%esi
80106abb:	75 11                	jne    80106ace <loaduvm+0x3e>
80106abd:	eb 61                	jmp    80106b20 <loaduvm+0x90>
80106abf:	90                   	nop
80106ac0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ac6:	89 f0                	mov    %esi,%eax
80106ac8:	29 d8                	sub    %ebx,%eax
80106aca:	39 c6                	cmp    %eax,%esi
80106acc:	76 52                	jbe    80106b20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad4:	31 c9                	xor    %ecx,%ecx
80106ad6:	29 da                	sub    %ebx,%edx
80106ad8:	e8 c3 fb ff ff       	call   801066a0 <walkpgdir>
80106add:	85 c0                	test   %eax,%eax
80106adf:	74 49                	je     80106b2a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ae1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ae3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ae6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106af0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106af6:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af9:	29 d9                	sub    %ebx,%ecx
80106afb:	05 00 00 00 80       	add    $0x80000000,%eax
80106b00:	57                   	push   %edi
80106b01:	51                   	push   %ecx
80106b02:	50                   	push   %eax
80106b03:	ff 75 10             	pushl  0x10(%ebp)
80106b06:	e8 f5 ae ff ff       	call   80101a00 <readi>
80106b0b:	83 c4 10             	add    $0x10,%esp
80106b0e:	39 f8                	cmp    %edi,%eax
80106b10:	74 ae                	je     80106ac0 <loaduvm+0x30>
}
80106b12:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b1a:	5b                   	pop    %ebx
80106b1b:	5e                   	pop    %esi
80106b1c:	5f                   	pop    %edi
80106b1d:	5d                   	pop    %ebp
80106b1e:	c3                   	ret    
80106b1f:	90                   	nop
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b23:	31 c0                	xor    %eax,%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b2a:	83 ec 0c             	sub    $0xc,%esp
80106b2d:	68 ef 78 10 80       	push   $0x801078ef
80106b32:	e8 59 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106b37:	83 ec 0c             	sub    $0xc,%esp
80106b3a:	68 90 79 10 80       	push   $0x80107990
80106b3f:	e8 4c 98 ff ff       	call   80100390 <panic>
80106b44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b4f:	90                   	nop

80106b50 <allocuvm>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b59:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b5c:	85 ff                	test   %edi,%edi
80106b5e:	0f 88 bc 00 00 00    	js     80106c20 <allocuvm+0xd0>
  if(newsz < oldsz)
80106b64:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b67:	0f 82 a3 00 00 00    	jb     80106c10 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b70:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b7c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b7f:	0f 86 8e 00 00 00    	jbe    80106c13 <allocuvm+0xc3>
80106b85:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b8b:	eb 42                	jmp    80106bcf <allocuvm+0x7f>
80106b8d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106b90:	83 ec 04             	sub    $0x4,%esp
80106b93:	68 00 10 00 00       	push   $0x1000
80106b98:	6a 00                	push   $0x0
80106b9a:	50                   	push   %eax
80106b9b:	e8 c0 d9 ff ff       	call   80104560 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ba0:	58                   	pop    %eax
80106ba1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ba7:	5a                   	pop    %edx
80106ba8:	6a 06                	push   $0x6
80106baa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106baf:	89 da                	mov    %ebx,%edx
80106bb1:	50                   	push   %eax
80106bb2:	89 f8                	mov    %edi,%eax
80106bb4:	e8 67 fb ff ff       	call   80106720 <mappages>
80106bb9:	83 c4 10             	add    $0x10,%esp
80106bbc:	85 c0                	test   %eax,%eax
80106bbe:	78 70                	js     80106c30 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106bc0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bc6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106bc9:	0f 86 a1 00 00 00    	jbe    80106c70 <allocuvm+0x120>
    mem = kalloc();
80106bcf:	e8 dc b9 ff ff       	call   801025b0 <kalloc>
80106bd4:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106bd6:	85 c0                	test   %eax,%eax
80106bd8:	75 b6                	jne    80106b90 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106bda:	83 ec 0c             	sub    $0xc,%esp
80106bdd:	68 0d 79 10 80       	push   $0x8010790d
80106be2:	e8 c9 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106be7:	83 c4 10             	add    $0x10,%esp
80106bea:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bed:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bf0:	74 2e                	je     80106c20 <allocuvm+0xd0>
80106bf2:	89 c1                	mov    %eax,%ecx
80106bf4:	8b 55 10             	mov    0x10(%ebp),%edx
80106bf7:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106bfa:	31 ff                	xor    %edi,%edi
80106bfc:	e8 af fb ff ff       	call   801067b0 <deallocuvm.part.0>
}
80106c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c04:	89 f8                	mov    %edi,%eax
80106c06:	5b                   	pop    %ebx
80106c07:	5e                   	pop    %esi
80106c08:	5f                   	pop    %edi
80106c09:	5d                   	pop    %ebp
80106c0a:	c3                   	ret    
80106c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c0f:	90                   	nop
    return oldsz;
80106c10:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c16:	89 f8                	mov    %edi,%eax
80106c18:	5b                   	pop    %ebx
80106c19:	5e                   	pop    %esi
80106c1a:	5f                   	pop    %edi
80106c1b:	5d                   	pop    %ebp
80106c1c:	c3                   	ret    
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
80106c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c23:	31 ff                	xor    %edi,%edi
}
80106c25:	5b                   	pop    %ebx
80106c26:	89 f8                	mov    %edi,%eax
80106c28:	5e                   	pop    %esi
80106c29:	5f                   	pop    %edi
80106c2a:	5d                   	pop    %ebp
80106c2b:	c3                   	ret    
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	68 25 79 10 80       	push   $0x80107925
80106c38:	e8 73 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106c3d:	83 c4 10             	add    $0x10,%esp
80106c40:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c43:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c46:	74 0d                	je     80106c55 <allocuvm+0x105>
80106c48:	89 c1                	mov    %eax,%ecx
80106c4a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c50:	e8 5b fb ff ff       	call   801067b0 <deallocuvm.part.0>
      kfree(mem);
80106c55:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c58:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c5a:	56                   	push   %esi
80106c5b:	e8 90 b7 ff ff       	call   801023f0 <kfree>
      return 0;
80106c60:	83 c4 10             	add    $0x10,%esp
}
80106c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c66:	89 f8                	mov    %edi,%eax
80106c68:	5b                   	pop    %ebx
80106c69:	5e                   	pop    %esi
80106c6a:	5f                   	pop    %edi
80106c6b:	5d                   	pop    %ebp
80106c6c:	c3                   	ret    
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi
80106c70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c76:	5b                   	pop    %ebx
80106c77:	5e                   	pop    %esi
80106c78:	89 f8                	mov    %edi,%eax
80106c7a:	5f                   	pop    %edi
80106c7b:	5d                   	pop    %ebp
80106c7c:	c3                   	ret    
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi

80106c80 <deallocuvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c86:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c89:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c8c:	39 d1                	cmp    %edx,%ecx
80106c8e:	73 10                	jae    80106ca0 <deallocuvm+0x20>
}
80106c90:	5d                   	pop    %ebp
80106c91:	e9 1a fb ff ff       	jmp    801067b0 <deallocuvm.part.0>
80106c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ca0:	89 d0                	mov    %edx,%eax
80106ca2:	5d                   	pop    %ebp
80106ca3:	c3                   	ret    
80106ca4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106caf:	90                   	nop

80106cb0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
80106cb6:	83 ec 0c             	sub    $0xc,%esp
80106cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106cbc:	85 f6                	test   %esi,%esi
80106cbe:	74 59                	je     80106d19 <freevm+0x69>
  if(newsz >= oldsz)
80106cc0:	31 c9                	xor    %ecx,%ecx
80106cc2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106cc7:	89 f0                	mov    %esi,%eax
80106cc9:	89 f3                	mov    %esi,%ebx
80106ccb:	e8 e0 fa ff ff       	call   801067b0 <deallocuvm.part.0>
freevm(pde_t *pgdir)
80106cd0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106cd6:	eb 0f                	jmp    80106ce7 <freevm+0x37>
80106cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cdf:	90                   	nop
80106ce0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ce3:	39 df                	cmp    %ebx,%edi
80106ce5:	74 23                	je     80106d0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ce7:	8b 03                	mov    (%ebx),%eax
80106ce9:	a8 01                	test   $0x1,%al
80106ceb:	74 f3                	je     80106ce0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ced:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106cf2:	83 ec 0c             	sub    $0xc,%esp
80106cf5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cf8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106cfd:	50                   	push   %eax
80106cfe:	e8 ed b6 ff ff       	call   801023f0 <kfree>
80106d03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d06:	39 df                	cmp    %ebx,%edi
80106d08:	75 dd                	jne    80106ce7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d10:	5b                   	pop    %ebx
80106d11:	5e                   	pop    %esi
80106d12:	5f                   	pop    %edi
80106d13:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d14:	e9 d7 b6 ff ff       	jmp    801023f0 <kfree>
    panic("freevm: no pgdir");
80106d19:	83 ec 0c             	sub    $0xc,%esp
80106d1c:	68 41 79 10 80       	push   $0x80107941
80106d21:	e8 6a 96 ff ff       	call   80100390 <panic>
80106d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2d:	8d 76 00             	lea    0x0(%esi),%esi

80106d30 <setupkvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	56                   	push   %esi
80106d34:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d35:	e8 76 b8 ff ff       	call   801025b0 <kalloc>
80106d3a:	89 c6                	mov    %eax,%esi
80106d3c:	85 c0                	test   %eax,%eax
80106d3e:	74 42                	je     80106d82 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d40:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d43:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d48:	68 00 10 00 00       	push   $0x1000
80106d4d:	6a 00                	push   $0x0
80106d4f:	50                   	push   %eax
80106d50:	e8 0b d8 ff ff       	call   80104560 <memset>
80106d55:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d58:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d5b:	83 ec 08             	sub    $0x8,%esp
80106d5e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d61:	ff 73 0c             	pushl  0xc(%ebx)
80106d64:	8b 13                	mov    (%ebx),%edx
80106d66:	50                   	push   %eax
80106d67:	29 c1                	sub    %eax,%ecx
80106d69:	89 f0                	mov    %esi,%eax
80106d6b:	e8 b0 f9 ff ff       	call   80106720 <mappages>
80106d70:	83 c4 10             	add    $0x10,%esp
80106d73:	85 c0                	test   %eax,%eax
80106d75:	78 19                	js     80106d90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d77:	83 c3 10             	add    $0x10,%ebx
80106d7a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d80:	75 d6                	jne    80106d58 <setupkvm+0x28>
}
80106d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d85:	89 f0                	mov    %esi,%eax
80106d87:	5b                   	pop    %ebx
80106d88:	5e                   	pop    %esi
80106d89:	5d                   	pop    %ebp
80106d8a:	c3                   	ret    
80106d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d8f:	90                   	nop
      freevm(pgdir);
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	56                   	push   %esi
      return 0;
80106d94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106d96:	e8 15 ff ff ff       	call   80106cb0 <freevm>
      return 0;
80106d9b:	83 c4 10             	add    $0x10,%esp
}
80106d9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106da1:	89 f0                	mov    %esi,%eax
80106da3:	5b                   	pop    %ebx
80106da4:	5e                   	pop    %esi
80106da5:	5d                   	pop    %ebp
80106da6:	c3                   	ret    
80106da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dae:	66 90                	xchg   %ax,%ax

80106db0 <kvmalloc>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106db6:	e8 75 ff ff ff       	call   80106d30 <setupkvm>
80106dbb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dc0:	05 00 00 00 80       	add    $0x80000000,%eax
80106dc5:	0f 22 d8             	mov    %eax,%cr3
}
80106dc8:	c9                   	leave  
80106dc9:	c3                   	ret    
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106dd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106dd1:	31 c9                	xor    %ecx,%ecx
{
80106dd3:	89 e5                	mov    %esp,%ebp
80106dd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dde:	e8 bd f8 ff ff       	call   801066a0 <walkpgdir>
  if(pte == 0)
80106de3:	85 c0                	test   %eax,%eax
80106de5:	74 05                	je     80106dec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106de7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dea:	c9                   	leave  
80106deb:	c3                   	ret    
    panic("clearpteu");
80106dec:	83 ec 0c             	sub    $0xc,%esp
80106def:	68 52 79 10 80       	push   $0x80107952
80106df4:	e8 97 95 ff ff       	call   80100390 <panic>
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e09:	e8 22 ff ff ff       	call   80106d30 <setupkvm>
80106e0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e11:	85 c0                	test   %eax,%eax
80106e13:	0f 84 a0 00 00 00    	je     80106eb9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e1c:	85 c9                	test   %ecx,%ecx
80106e1e:	0f 84 95 00 00 00    	je     80106eb9 <copyuvm+0xb9>
80106e24:	31 f6                	xor    %esi,%esi
80106e26:	eb 4e                	jmp    80106e76 <copyuvm+0x76>
80106e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e30:	83 ec 04             	sub    $0x4,%esp
80106e33:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e3c:	68 00 10 00 00       	push   $0x1000
80106e41:	57                   	push   %edi
80106e42:	50                   	push   %eax
80106e43:	e8 b8 d7 ff ff       	call   80104600 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e48:	58                   	pop    %eax
80106e49:	5a                   	pop    %edx
80106e4a:	53                   	push   %ebx
80106e4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e51:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e56:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e5c:	52                   	push   %edx
80106e5d:	89 f2                	mov    %esi,%edx
80106e5f:	e8 bc f8 ff ff       	call   80106720 <mappages>
80106e64:	83 c4 10             	add    $0x10,%esp
80106e67:	85 c0                	test   %eax,%eax
80106e69:	78 39                	js     80106ea4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106e6b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e71:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106e74:	76 43                	jbe    80106eb9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e76:	8b 45 08             	mov    0x8(%ebp),%eax
80106e79:	31 c9                	xor    %ecx,%ecx
80106e7b:	89 f2                	mov    %esi,%edx
80106e7d:	e8 1e f8 ff ff       	call   801066a0 <walkpgdir>
80106e82:	85 c0                	test   %eax,%eax
80106e84:	74 3e                	je     80106ec4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106e86:	8b 18                	mov    (%eax),%ebx
80106e88:	f6 c3 01             	test   $0x1,%bl
80106e8b:	74 44                	je     80106ed1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106e8d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e8f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106e95:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106e9b:	e8 10 b7 ff ff       	call   801025b0 <kalloc>
80106ea0:	85 c0                	test   %eax,%eax
80106ea2:	75 8c                	jne    80106e30 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106ea4:	83 ec 0c             	sub    $0xc,%esp
80106ea7:	ff 75 e0             	pushl  -0x20(%ebp)
80106eaa:	e8 01 fe ff ff       	call   80106cb0 <freevm>
  return 0;
80106eaf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106eb6:	83 c4 10             	add    $0x10,%esp
}
80106eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ebf:	5b                   	pop    %ebx
80106ec0:	5e                   	pop    %esi
80106ec1:	5f                   	pop    %edi
80106ec2:	5d                   	pop    %ebp
80106ec3:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106ec4:	83 ec 0c             	sub    $0xc,%esp
80106ec7:	68 5c 79 10 80       	push   $0x8010795c
80106ecc:	e8 bf 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80106ed1:	83 ec 0c             	sub    $0xc,%esp
80106ed4:	68 76 79 10 80       	push   $0x80107976
80106ed9:	e8 b2 94 ff ff       	call   80100390 <panic>
80106ede:	66 90                	xchg   %ax,%ax

80106ee0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ee0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ee1:	31 c9                	xor    %ecx,%ecx
{
80106ee3:	89 e5                	mov    %esp,%ebp
80106ee5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80106eee:	e8 ad f7 ff ff       	call   801066a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ef3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ef5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106ef6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106ef8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106efd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f00:	05 00 00 00 80       	add    $0x80000000,%eax
80106f05:	83 fa 05             	cmp    $0x5,%edx
80106f08:	ba 00 00 00 00       	mov    $0x0,%edx
80106f0d:	0f 45 c2             	cmovne %edx,%eax
}
80106f10:	c3                   	ret    
80106f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop

80106f20 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 0c             	sub    $0xc,%esp
80106f29:	8b 75 14             	mov    0x14(%ebp),%esi
80106f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f2f:	85 f6                	test   %esi,%esi
80106f31:	75 38                	jne    80106f6b <copyout+0x4b>
80106f33:	eb 6b                	jmp    80106fa0 <copyout+0x80>
80106f35:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f38:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f3b:	89 fb                	mov    %edi,%ebx
80106f3d:	29 d3                	sub    %edx,%ebx
80106f3f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106f45:	39 f3                	cmp    %esi,%ebx
80106f47:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f4a:	29 fa                	sub    %edi,%edx
80106f4c:	83 ec 04             	sub    $0x4,%esp
80106f4f:	01 c2                	add    %eax,%edx
80106f51:	53                   	push   %ebx
80106f52:	ff 75 10             	pushl  0x10(%ebp)
80106f55:	52                   	push   %edx
80106f56:	e8 a5 d6 ff ff       	call   80104600 <memmove>
    len -= n;
    buf += n;
80106f5b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106f5e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106f64:	83 c4 10             	add    $0x10,%esp
80106f67:	29 de                	sub    %ebx,%esi
80106f69:	74 35                	je     80106fa0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106f6b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f6d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106f70:	89 55 0c             	mov    %edx,0xc(%ebp)
80106f73:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f79:	57                   	push   %edi
80106f7a:	ff 75 08             	pushl  0x8(%ebp)
80106f7d:	e8 5e ff ff ff       	call   80106ee0 <uva2ka>
    if(pa0 == 0)
80106f82:	83 c4 10             	add    $0x10,%esp
80106f85:	85 c0                	test   %eax,%eax
80106f87:	75 af                	jne    80106f38 <copyout+0x18>
  }
  return 0;
}
80106f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f91:	5b                   	pop    %ebx
80106f92:	5e                   	pop    %esi
80106f93:	5f                   	pop    %edi
80106f94:	5d                   	pop    %ebp
80106f95:	c3                   	ret    
80106f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9d:	8d 76 00             	lea    0x0(%esi),%esi
80106fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fa3:	31 c0                	xor    %eax,%eax
}
80106fa5:	5b                   	pop    %ebx
80106fa6:	5e                   	pop    %esi
80106fa7:	5f                   	pop    %edi
80106fa8:	5d                   	pop    %ebp
80106fa9:	c3                   	ret    
