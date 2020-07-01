# BTC（对于区块链的应用）
## 什么是BTC：
* 一种点对点的电子现金系统。系统的数据是具有货币功能的一种虚拟商品，可以通过挖矿获得（POW比拼算力）。
* 特点：
分布式账本，去中心化安全性高。
总量只有2100W个，产量固定，不会通货膨胀。
## BTC的组成：
* 组成部分：私钥K（32字节），公钥P（64字节），地址
此过程是单向的
```mermaid
graph LR
A[私钥] --> B[公钥]
    B --> C[地址]
```
* 如何生成
1. 私钥K：随机生成的256位二进制数
2. 公钥P：在私钥的基础上通过ECDSA椭圆曲线签名算法（一种Trapdoor function函数无法逆推）生成。可以简单理解为P=K×G（G为常数）。
3. 地址：将P进行SHA256运算，再进行RIPEMD-160运算（都是哈希运算）再编码，生成了20个字节。
## 交易时如何验证：

* **如何实现非对称加密**
Alice:Ka, Pa
Bob:Kb, Pb
Alice发送Pa给BOb
Bob发送Pb给Alice
Ka * Pb = Ka * (Kb * G) = Key
Kb * Pa = Kb * (Ka * G) = Key
Key就是这两人的密钥    
       
* **如何实现数字签名（证明这个数据是我发出的）**
签名：sign(Hash(m), Ka)，(m为我发出的信息，Ka为我的私钥)
验证：verify(m,sign(),Pa) = True/False,（验证sign函数的Ka和Pa的Ka是相同的，sign签名是对m的签名。）

**sign()函数的简化原理：**
1. 以生成比特币的Ka和Pa的方式再生成了一对K和P
2. r = Px （Px为P的x坐标)
3. s = K^-1(Hash(m) + Ka * r)

**verify()函数的简化原理：**
1. a = s^-1(Hash(m))
2. b = s^-1 * r
3. a*G + bPa
   = a * G + bKa * G
   = (a + bKa) * G
   = s^-1(hash(m) + Ka * r) * G
**验证：**
1. s * K * s^-1 = K^-1(Hash(m) + Ka * r) * K * s^-1
2. K = s^-1(hash(m) + Ka * r)
3. a * G + bPa = K * G
   = P
   验证=P，返回True，不等于返回False
## 哈希函数：
**1. 什么是哈希**

哈希(Hash)，一般翻译做散列、杂凑，或音译为哈希，是把任意长度的输入（又叫做预映射 pre-image）通过散列算法变换成固定长度的输出，该输出就是散列值。这种转换是一种压缩映射，也就是，散列值的空间通常远小于输入的空间，不同的输入可能会散列成相同的输出，所以不可能从散列值来确定唯一的输入值。简单的说就是一种将任意长度的消息压缩到某一固定长度的消息摘要的函数。
* 用筛选法选出素数
```python
import math

def find_prime(num):
    primes_bool = [False, False]+[True]*(num-1)     # 前两个是0,1为False。
    for i in range(3,len(primes_bool)):
        # 将数组下标是偶数的数字全部置为否定状态
        if i%2 == 0:
            primes_bool[i] = False
    for i in range(3, int(math.sqrt(num))+1):   # math.sqrt(number)，返回number的平方根
        # 如果当前数字处于被肯定的状态，则将其倍数的数字状态置为否定
        if primes_bool[i] is True:
            for j in range(i+i, num+1, i):
                primes_bool[j] = False
    prims = []
    # enumerate 将 primes_bool 组合成一个索引序列，i 是索引，v 是元素
    for i, v in enumerate(primes_bool):
        #　将判断为 True 的元素添加进 prims
        if v is True:
            prims.append(i)
    return prims
print(find_prime_2(100))
```

## 交易信息如何记录：
**怎么解决记账问题**
1. 交易数目变多，就要生成账本记录交易。
2. 为了去中心化，账本要做成分布式（用P2P技术实现）。
3. 分布式账本用POW获得记账权后达成共识。
4. 获得记账权的节点，奖励适当比特币。

**区块的结构**
1. 把个帐目分成一个1MB大小的block。
2. 每个block的结构
    | head ：必要信息 |
    |:----:|
    |  body：具体的帐目|
3. head的结构：
   | version：版本号 |
   |:----:|
   | pre_hash：上个表头的hash值 |
   | time：记账的时间 |
   | Merkle root：表身的Hash值|
   | Difficulty：当前难度 |
   | Nonce：随机数 |
**Merkle root**：是以每条帐目做两次Hash运算，再把相邻节点相加做Hash运算，一直运算生成一个根节点。这个根节点就是Merkle root。

**Hash(Hash(head))** = 下一个表头的pre_hash，形成一个哈希指针，后一个块指向前一个块。

**Difficulty**：区块头的哈希值的前几位为零的个数，(1/16)^x，x就是当前难度，当x=1时表示这个16进制数首位为0的概率，就是小于0x1000.....64位的数，只要比这个数小，那么首位一定为零，这个数就叫Target（目标数）。这个难度中和全网算力，平均10分钟找到Target。

## POW机制
1. 得到账本之后先给自己记上一笔帐目，假设自己已经抢到记账权，所以每个争取记账权的人算的Hash值不会相同。
2. POW（“挖矿”）：从0往上调整Nonce找到比Target小的值。
3. 当同时算出Target时，两个区块会分叉，最后遵循最长有效链原则。没有被打包的交易从新进入交易池等待打包。

**用Python2实现POW**
```python
import hashlib
import time

max_nonce = 2 ** 32

def proof_of_work(header, dirfficulty_bit):
   target = 2 ** (256 - difficulty_bits)
   for nonce in xrange(max_nonce):
      hash_result = hashlib.sha256(str(header)+str(nonce)).hexdigest()

      if long(hash_result, 16) < target:
         print "Success with nonce %d" % nonce
         print "Hash is %s" % hash_result
         return (hash_result, nonce)

   print "Failed after %d (max_nonce) tries" % nonce
   return nonce

if __name__=='__main__':
   nonce = 0
   hash_result = ''

   for difficulty_bits in xrange(32):
      difficulty = 2 ** difficulty_bits

      print ""
      print "Diffculty: %ld (%d bits)" % (difficulty, difficulty_bits)

      print "Starting search..."

      start_time = time.time()

      new_block = 'test block with transactions' + hash_result

      (hash_result, nonce) = proof_of_work(new_block, difficulty_bits)

      end_time = time.time()

      elapsed_time = end_time - start_time

      print "Elapsed time: %.4f seconds" % elapsed_time

      if elapsed_time > 0:
         hash_power = float(long(nonce) / elapsed_time)
```

![POW的执行](POW.png)
由图可见难度越大，求出target用的时间越长。
