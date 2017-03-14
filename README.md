# tiny-encrypted-udp-tunnel
tiny singlefile encrypted udp tunnel/forwarder

# keywords
encrypted,udp port forwarder,udp tunnel,openvpn being blocked,hide openvpn traffic

# background 
this program is originally designed for tunneling udp mode openvpn.(though it can be used for forwarding/tunneling any udp based protocol)

as we know,openvpn uses encryption for authentication and it encrypts the data it carrys.

however,it doesnt encrypt the handshake and control flow.in other words,it doenst aim at prevent itself from being detected by firewalls.

while openssh provided an easy-to-use tunnel feature,it doesnt support tunneling udp.ssh aslo doesnt prevent itself from being detected by firewalls.

this program allow you to do encrypted tunneling so that firewalls wont be able to know the existence of a openvpn connection.

has been stablely running for years on my server and router. 

linux x64 and mips_ar71xx binaries have already been built.

# usage
this program is essentially a port forwarder which allows you to use a key for encryption/decryption at either side.if you use a pair of them,one at local host,the other at remote host,they form a tunnel together

forward -l [adressA:]portA -r [adressB:]portB  [-a passwdA] [-b passwdB]

after being started,this program will forward all packet received from adressA:portA to adressB:portB. and all packet received back from adressB:portB will be forward back to adressA:portA. it can handle multiple udp connection.

basic option:

-l -r option are required. -l indicates the local adress&port, -r indicates the remote adress&port.

adressA and adressB are optional,if adressA or adressB are ommited,127.0.0.1 will be used by default.only ipv4 adress has been tested.


encryption option:

-a and -b are optional.

if -a is used ,all packet goes into adressA:portA will be decrypted by passwdA,and all packet goes out from adressA:portA will be encrypted by passwdA.if -a is omited,data goes into/out adressA:portA will not be encrypted/decrypted.

if -b is used ,all packet goes into adressB:portB will be decrypted by passwdB,and all packet goes out from adressB:portB will be encrypted by passwdB.if -b is omited,data goes into/out adressB:portB will not be encrypted/decrypted.




# example
assume an udp mode openvpn server is running at 44.55.66.77:9000

run this at sever side at 44.55.66.77:
./forward -l0.0.0.0:9001 -r127.0.0.1:9000 -a'abcd' > /dev/null &

run this at client side:
./forward -l 127.0.0.1:9002 -r 44.55.66.77:9001 -b 'abcd' >/dev/null&

now,configure you openvpn client to connect to 127.0.0.1:9002

dataflow:


                  client computer                                                           server computer (44.55.66.77)
    +---------------------------------------------+                           +------------------------------------------------+
    |   openvpn                                   |                           |                              openvpn server    |
    |   client                      forwarder     |                           |    forwarder                    daemon         |
    | +-----------+               +------------+  |                           |   +-----------+                +------------+  |
    | |           |r              |            |r |                           |   |           |r               |            |  |
    | |           |a             9|            |a |                           |  9|           |a              9|            |  |
    | |           |n             0|            |n |                           |  0|           |n              0|            |  |
    | |           |d <-------->  0|            |d<-----------------------------> 0|           |d  <-------->  0|            |  |
    | |           |o(unencrypted)2|            |o |    (encrypted channel     |  1|           |o (unencrypted)0|            |  |
    | |           |m              |            |m |      by key 'abcd')       |   |           |m               |            |  |
    | +-----------+               +------------+  |                           |   +-----------+                +------------+  |
    |                                             |                           |                                                |
    +---------------------------------------------+                           +------------------------------------------------+



# method of encryption
currently this program only use XOR for encrypting.mainly bc i use a mips_ar71xx router as client.router's cpu is slow,i personally need fast processing speed.and XOR is enough for fooling the firewall i have encountered.

nevertheless,you can easily integrate your own encrytion algotirhm into this program if you need stronger encryption.all you need to do is to rewrite 'void encrypt(char * input,int len,char *key)' and 'void decrypt(char * input,int len,char *key)'.

(a good way to implemnet AES encrytion might be using the lib in this repo https://github.com/kokke/tiny-AES128-C )
