//+------------------------------------------------------------------+
//|                                                        SocketLib |
//|                       programming & development - Alexey Sergeev |
//+------------------------------------------------------------------+
#property copyright "© 2006-2016 Alexey Sergeev"
#property link      "profy.mql@gmail.com"
#property version   "1.00"
#property library

#define BYTE						uchar
#define WORD						ushort
#define DWORD						int
#define DWORD_PTR32				uint
#define DWORD_PTR64				ulong
#define SOCKET32					uint
#define SOCKET64					ulong

#define MAKEWORD(a, b)      ((WORD)(((BYTE)(((DWORD_PTR64)(a)) & 0xff)) | ((WORD)((BYTE)(((DWORD_PTR64)(b)) & 0xff))) << 8))

#define WSADESCRIPTION_LEN      256
#define WSASYS_STATUS_LEN       128

#define INVALID_SOCKET64  (SOCKET64)(~0)
#define INVALID_SOCKET32  (SOCKET32)(~0)
#define SOCKET_ERROR            (-1)
#define NO_ERROR 								0
#define SOMAXCONN								128

#define AF_INET         2 // internetwork: UDP, TCP, etc.
#define SOCK_STREAM     1               /* stream socket */
#define SOCK_DGRAM      2               /* datagram socket */
#define IPPROTO_TCP     6
#define IPPROTO_UDP     17

#define SD_RECEIVE      0x00
#define SD_SEND         0x01
#define SD_BOTH         0x02

#define IOCPARM_MASK    0x7f            /* parameters must be < 128 bytes */
#define IOC_IN          0x80000000      /* copy in parameters */
#define _IOW(x,y,t)     (IOC_IN|(((int)sizeof(t)&IOCPARM_MASK)<<16)|((x)<<8)|(y))
#define FIONBIO     _IOW('f', 126, int) /* set/clear non-blocking i/o */
//------------------------------------------------------------------	struct WSAData
struct WSAData
  {
   WORD              wVersion;
   WORD              wHighVersion;
   char              szDescription[WSADESCRIPTION_LEN+1];
   char              szSystemStatus[WSASYS_STATUS_LEN+1];
   ushort            iMaxSockets;
   ushort            iMaxUdpDg;
   char              lpVendorInfo[];
  };

#define LPWSADATA		char&
//------------------------------------------------------------------	struct sockaddr_in
//------------------------------------------------------------------	struct sockaddr_in
struct S_un_b { uchar s_b1,s_b2,s_b3,s_b4; };
struct S_un_w { ushort s_w1, s_w2; };
union S_un
{
	S_un_b b;
	S_un_w w;
	uint S_addr;
};
struct in_addr { S_un u; };
struct sockaddr_in
  {
   ushort            sin_family;
   ushort            sin_port;
   in_addr           sin_addr; // struct in_addr { uint s_addr; };
   char              sin_zero[8];
  };

union ref_sockaddr_in { char ref[2+2+4+1]; sockaddr_in in; };
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct sockaddr
  {
   ushort            sa_family; // Address family
   char              sa_data[14]; // Up to 14 bytes of direct address
  };
#define LPSOCKADDR	char&

union ref_sockaddr { char ref[2+14]; sockaddr_in in; };

//------------------------------------------------------------------	import Ws2_32.dll
#import "Ws2_32.dll"
int WSAStartup(WORD wVersionRequested,LPWSADATA lpWSAData[]);
int WSACleanup();
int WSAGetLastError();

ushort htons(ushort hostshort);
uint inet_addr(char &cp[]);
string inet_ntop(int Family, char &pAddr[],char &pStringBuf[],uint StringBufSize);
ushort ntohs(ushort netshort);

SOCKET64 socket(int af,int type,int protocol);
int ioctlsocket(SOCKET64 s,int cmd,int &argp);
int shutdown(SOCKET64 s,int how);
int closesocket(SOCKET64 s);

// TCP server functions
int bind(SOCKET64 s,LPSOCKADDR name[],int namelen);
int listen(SOCKET64 s,int backlog);
SOCKET64 accept(SOCKET64 s, LPSOCKADDR addr[],int &addrlen);

// TCP client functions
int connect(SOCKET64 s,LPSOCKADDR name[],int namelen);
int send(SOCKET64 s,char &buf[],int len,int flags);
int recv(SOCKET64 s,char &buf[],int len,int flags);

// UDP functions
int recvfrom(SOCKET64 s,char &buf[],int len,int flags,LPSOCKADDR from[],int &fromlen);
int sendto(SOCKET64 s,const char &buf[],int len,int flags,LPSOCKADDR to[],int tolen);
#import


//------------------------------------------------------------------	socket error code

#define WSA_INVALID_HANDLE			6	// Specified event object handle is invalid.
// An application attempts to use an event object, but the specified handle is not valid. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.

#define WSA_NOT_ENOUGH_MEMORY		8 // Insufficient memory available.
// An application used a Windows Sockets function that directly maps to a Windows function. The Windows function is indicating a lack of required memory resources. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.

#define WSA_INVALID_PARAMETER		87 // One or more parameters are invalid.
// An application used a Windows Sockets function which directly maps to a Windows function. The Windows function is indicating a problem with one or more parameters. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.

#define WSA_OPERATION_ABORTED		995 // Overlapped operation aborted.
// An overlapped operation was canceled due to the closure of the socket, or the execution of the SIO_FLUSH command in WSAIoctl. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.

#define WSA_IO_INCOMPLETE	996 // Overlapped I/O event object not in signaled state.
// The application has tried to determine the status of an overlapped operation which is not yet completed. Applications that use WSAGetOverlappedResult (with the fWait flag set to FALSE) in a polling mode to determine when an overlapped operation has completed, get this error code until the operation is complete. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.

#define WSA_IO_PENDING	997 // Overlapped operations will complete later.
// The application has initiated an overlapped operation that cannot be completed immediately. A completion indication will be given later when the operation has been completed. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.

#define WSAEINTR		10004 // Interrupted function call.
// A blocking operation was interrupted by a call to WSACancelBlockingCall.

#define WSAEBADF	10009 // File handle is not valid.
// The file handle supplied is not valid.

#define WSAEACCES	10013 // Permission denied.
// An attempt was made to access a socket in a way forbidden by its access permissions. An example is using a broadcast address for sendto without broadcast permission being set using setsockopt(SO_BROADCAST).
// Another possible reason for the WSAEACCES error is that when the bind function is called (on Windows NT 4.0 with SP4 and later), another application, service, or kernel mode driver is bound to the same address with exclusive access. Such exclusive access is a new feature of Windows NT 4.0 with SP4 and later, and is implemented by using the SO_EXCLUSIVEADDRUSE option.

#define WSAEFAULT	10014 // Bad address.
// The system detected an invalid pointer address in attempting to use a pointer argument of a call. This error occurs if an application passes an invalid pointer value, or if the length of the buffer is too small. For instance, if the length of an argument, which is a sockaddr structure, is smaller than the sizeof(sockaddr).

#define WSAEINVAL	10022 //Invalid argument.
//Some invalid argument was supplied (for example, specifying an invalid level to the setsockopt function). In some instances, it also refers to the current state of the socket—for instance, calling accept on a socket that is not listening.

#define WSAEMFILE	10024 //Too many open files.
//Too many open sockets. Each implementation may have a maximum number of socket handles available, either globally, per process, or per thread.

#define WSAEWOULDBLOCK	10035 //Resource temporarily unavailable.
//This error is returned from operations on nonblocking sockets that cannot be completed immediately, for example recv when no data is queued to be read from the socket. It is a nonfatal error, and the operation should be retried later. It is normal for WSAEWOULDBLOCK to be reported as the result from calling connect on a nonblocking SOCK_STREAM socket, since some time must elapse for the connection to be established.

#define WSAEINPROGRESS	10036 //Operation now in progress.
//A blocking operation is currently executing. Windows Sockets only allows a single blocking operation—per- task or thread—to be outstanding, and if any other function call is made (whether or not it references that or any other socket) the function fails with the WSAEINPROGRESS error.

#define WSAEALREADY	10037 //Operation already in progress.
//An operation was attempted on a nonblocking socket with an operation already in progress—that is, calling connect a second time on a nonblocking socket that is already connecting, or canceling an asynchronous request (WSAAsyncGetXbyY) that has already been canceled or completed.

#define WSAENOTSOCK	10038 //Socket operation on nonsocket.
//An operation was attempted on something that is not a socket. Either the socket handle parameter did not reference a valid socket, or for select, a member of an fd_set was not valid.

#define WSAEDESTADDRREQ	10039 //Destination address required.
//A required address was omitted from an operation on a socket. For example, this error is returned if sendto is called with the remote address of ADDR_ANY.

#define WSAEMSGSIZE	10040 //Message too long.
//A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram was smaller than the datagram itself.

#define WSAEPROTOTYPE	10041 //Protocol wrong type for socket.
//A protocol was specified in the socket function call that does not support the semantics of the socket type requested. For example, the ARPA Internet UDP protocol cannot be specified with a socket type of SOCK_STREAM.

#define WSAENOPROTOOPT	10042 //Bad protocol option.
//An unknown, invalid or unsupported option or level was specified in a getsockopt or setsockopt call.

#define WSAEPROTONOSUPPORT	10043 //Protocol not supported.
//The requested protocol has not been configured into the system, or no implementation for it exists. For example, a socket call requests a SOCK_DGRAM socket, but specifies a stream protocol.

#define WSAESOCKTNOSUPPORT	10044 //Socket type not supported.
//The support for the specified socket type does not exist in this address family. For example, the optional type SOCK_RAW might be selected in a socket call, and the implementation does not support SOCK_RAW sockets at all.

#define WSAEOPNOTSUPP	10045 //Operation not supported.
//The attempted operation is not supported for the type of object referenced. Usually this occurs when a socket descriptor to a socket that cannot support this operation is trying to accept a connection on a datagram socket.

#define WSAEPFNOSUPPORT	10046 //Protocol family not supported.
//The protocol family has not been configured into the system or no implementation for it exists. This message has a slightly different meaning from WSAEAFNOSUPPORT. However, it is interchangeable in most cases, and all Windows Sockets functions that return one of these messages also specify WSAEAFNOSUPPORT.

#define WSAEAFNOSUPPORT	10047 //Address family not supported by protocol family.
//An address incompatible with the requested protocol was used. All sockets are created with an associated address family (that is, AF_INET for Internet Protocols) and a generic protocol type (that is, SOCK_STREAM). This error is returned if an incorrect protocol is explicitly requested in the socket call, or if an address of the wrong family is used for a socket, for example, in sendto.

#define WSAEADDRINUSE	10048 //Address already in use.
//Typically, only one usage of each socket address (protocol/IP address/port) is permitted. This error occurs if an application attempts to bind a socket to an IP address/port that has already been used for an existing socket, or a socket that was not closed properly, or one that is still in the process of closing. For server applications that need to bind multiple sockets to the same port number, consider using setsockopt (SO_REUSEADDR). Client applications usually need not call bind at all—connect chooses an unused port automatically. When bind is called with a wildcard address (involving ADDR_ANY), a WSAEADDRINUSE error could be delayed until the specific address is committed. This could happen with a call to another function later, including connect, listen, WSAConnect, or WSAJoinLeaf.

#define WSAEADDRNOTAVAIL	10049 //Cannot assign requested address.
//The requested address is not valid in its context. This normally results from an attempt to bind to an address that is not valid for the local computer. This can also result from connect, sendto, WSAConnect, WSAJoinLeaf, or WSASendTo when the remote address or port is not valid for a remote computer (for example, address or port 0).

#define WSAENETDOWN	10050 //Network is down.
//A socket operation encountered a dead network. This could indicate a serious failure of the network system (that is, the protocol stack that the Windows Sockets DLL runs over), the network interface, or the local network itself.

#define WSAENETUNREACH	10051 //Network is unreachable.
//A socket operation was attempted to an unreachable network. This usually means the local software knows no route to reach the remote host.

#define WSAENETRESET	10052 //Network dropped connection on reset.
//The connection has been broken due to keep-alive activity detecting a failure while the operation was in progress. It can also be returned by setsockopt if an attempt is made to set SO_KEEPALIVE on a connection that has already failed.

#define WSAECONNABORTED		10053 //Software caused connection abort.
//An established connection was aborted by the software in your host computer, possibly due to a data transmission time-out or protocol error.

#define WSAECONNRESET	10054 //Connection reset by peer.
//An existing connection was forcibly closed by the remote host. This normally results if the peer application on the remote host is suddenly stopped, the host is rebooted, the host or remote network interface is disabled, or the remote host uses a hard close (see setsockopt for more information on the SO_LINGER option on the remote socket). This error may also result if a connection was broken due to keep-alive activity detecting a failure while one or more operations are in progress. Operations that were in progress fail with WSAENETRESET. Subsequent operations fail with WSAECONNRESET.

#define WSAENOBUFS	10055 //No buffer space available.
//An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.

#define WSAEISCONN	10056 //Socket is already connected.
//A connect request was made on an already-connected socket. Some implementations also return this error if sendto is called on a connected SOCK_DGRAM socket (for SOCK_STREAM sockets, the to parameter in sendto is ignored) although other implementations treat this as a legal occurrence.

#define WSAENOTCONN	10057 //Socket is not connected.
//A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using sendto) no address was supplied. Any other type of operation might also return this error—for example, setsockopt setting SO_KEEPALIVE if the connection has been reset.

#define WSAESHUTDOWN	10058 //Cannot send after socket shutdown.
//A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call. By calling shutdown a partial close of a socket is requested, which is a signal that sending or receiving, or both have been discontinued.

#define WSAETOOMANYREFS		10059 //Too many references.
//Too many references to some kernel object.

#define WSAETIMEDOUT	10060  //Connection timed out.
//A connection attempt failed because the connected party did not properly respond after a period of time, or the established connection failed because the connected host has failed to respond.

#define WSAECONNREFUSED		10061 //Connection refused.
//No connection could be made because the target computer actively refused it. This usually results from trying to connect to a service that is inactive on the foreign host—that is, one with no server application running.

#define WSAELOOP		10062 //Cannot translate name.
//Cannot translate a name.

#define WSAENAMETOOLONG	10063 //Name too long.
//A name component or a name was too long.

#define WSAEHOSTDOWN	10064 //Host is down.
//A socket operation failed because the destination host is down. A socket operation encountered a dead host. Networking activity on the local host has not been initiated. These conditions are more likely to be indicated by the error WSAETIMEDOUT.

#define WSAEHOSTUNREACH	10065 //No route to host.
//A socket operation was attempted to an unreachable host. See WSAENETUNREACH.

#define WSAENOTEMPTY	10066 //Directory not empty.
//Cannot remove a directory that is not empty.

#define WSAEPROCLIM	10067 //Too many processes.
//A Windows Sockets implementation may have a limit on the number of applications that can use it simultaneously. WSAStartup may fail with this error if the limit has been reached.

#define WSAEUSERS	10068 //User quota exceeded.
//Ran out of user quota.

#define WSAEDQUOT	10069 //Disk quota exceeded.
//Ran out of disk quota.

#define WSAESTALE	10070 //Stale file handle reference.
//The file handle reference is no longer available.

#define WSAEREMOTE	10071 //Item is remote.
//The item is not available locally.

#define WSASYSNOTREADY	10091 //Network subsystem is unavailable.
//This error is returned by WSAStartup if the Windows Sockets implementation cannot function at this time because the underlying system it uses to provide network services is currently unavailable. Users should check:
//That the appropriate Windows Sockets DLL file is in the current path.//That they are not trying to use more than one Windows Sockets implementation simultaneously. If there is more than one Winsock DLL on your system, be sure the first one in the path is appropriate for the network subsystem currently loaded.//The Windows Sockets implementation documentation to be sure all necessary components are currently installed and configured correctly.

#define WSAVERNOTSUPPORTED	10092 //Winsock.dll version out of range.
//The current Windows Sockets implementation does not support the Windows Sockets specification version requested by the application. Check that no old Windows Sockets DLL files are being accessed.

#define WSANOTINITIALISED		10093 //Successful WSAStartup not yet performed.
//Either the application has not called WSAStartup or WSAStartup failed. The application may be accessing a socket that the current active task does not own (that is, trying to share a socket between tasks), or WSACleanup has been called too many times.

#define WSAEDISCON	10101 //Graceful shutdown in progress.
//Returned by WSARecv and WSARecvFrom to indicate that the remote party has initiated a graceful shutdown sequence.

#define WSAENOMORE	10102 //No more results.
//No more results can be returned by the WSALookupServiceNext function.

#define WSAECANCELLED	10103 //Call has been canceled.
//A call to the WSALookupServiceEnd function was made while this call was still processing. The call has been canceled.

#define WSAEINVALIDPROCTABLE	10104 //Procedure call table is invalid.
//The service provider procedure call table is invalid. A service provider returned a bogus procedure table to Ws2_32.dll. This is usually caused by one or more of the function pointers being NULL.

#define WSAEINVALIDPROVIDER	10105 //Service provider is invalid.
//The requested service provider is invalid. This error is returned by the WSCGetProviderInfo and WSCGetProviderInfo32 functions if the protocol entry specified could not be found. This error is also returned if the service provider returned a version number other than 2.0.

#define WSAEPROVIDERFAILEDINIT	10106 //Service provider failed to initialize.
//The requested service provider could not be loaded or initialized. This error is returned if either a service provider's DLL could not be loaded (LoadLibrary failed) or the provider's WSPStartup or NSPStartup function failed.

#define WSASYSCALLFAILURE	10107 //System call failure.
//A system call that should never fail has failed. This is a generic error code, returned under various conditions.
//Returned when a system call that should never fail does fail. For example, if a call to WaitForMultipleEvents fails or one of the registry functions fails trying to manipulate the protocol/namespace catalogs.
//Returned when a provider does not return SUCCESS and does not provide an extended error code. Can indicate a service provider implementation error.

#define WSASERVICE_NOT_FOUND	10108 //Service not found.
//No such service is known. The service cannot be found in the specified name space.

#define WSATYPE_NOT_FOUND	10109 //Class type not found.
//The specified class was not found.

#define WSA_E_NO_MORE	10110 //No more results.
//No more results can be returned by the WSALookupServiceNext function.

#define WSA_E_CANCELLED	10111 //Call was canceled.
//A call to the WSALookupServiceEnd function was made while this call was still processing. The call has been canceled.

#define WSAEREFUSED	10112 //Database query was refused.
//A database query failed because it was actively refused.

#define WSAHOST_NOT_FOUND	11001 //Host not found.
//No such host is known. The name is not an official host name or alias, or it cannot be found in the database(s) being queried. This error may also be returned for protocol and service queries, and means that the specified name could not be found in the relevant database.

#define WSATRY_AGAIN	11002 //Nonauthoritative host not found.
//This is usually a temporary error during host name resolution and means that the local server did not receive a response from an authoritative server. A retry at some time later may be successful.

#define WSANO_RECOVERY	11003 //This is a nonrecoverable error.
//This indicates that some sort of nonrecoverable error occurred during a database lookup. This may be because the database files (for example, BSD-compatible HOSTS, SERVICES, or PROTOCOLS files) could not be found, or a DNS request was returned by the server with a severe error.

#define WSANO_DATA	11004 //Valid name, no data record of requested type.
//The requested name is valid and was found in the database, but it does not have the correct associated data being resolved for. The usual example for this is a host name-to-address translation attempt (using gethostbyname or WSAAsyncGetHostByName) which uses the DNS (Domain Name Server). An MX record is returned but no A record—indicating the host itself exists, but is not directly reachable.

#define WSA_QOS_RECEIVERS	11005 //QoS receivers.
//At least one QoS reserve has arrived.

#define WSA_QOS_SENDERS	11006 //QoS senders.
//At least one QoS send path has arrived.

#define WSA_QOS_NO_SENDERS	11007 //No QoS senders.
//There are no QoS senders.

#define WSA_QOS_NO_RECEIVERS	11008 //QoS no receivers.
//There are no QoS receivers.

#define WSA_QOS_REQUEST_CONFIRMED	11009 //QoS request confirmed.
//The QoS reserve request has been confirmed.

#define WSA_QOS_ADMISSION_FAILURE	11010 //QoS admission error.
//A QoS error occurred due to lack of resources.

#define WSA_QOS_POLICY_FAILURE	11011 //QoS policy failure.
//The QoS request was rejected because the policy system couldn't allocate the requested resource within the existing policy.

#define WSA_QOS_BAD_STYLE	11012 //QoS bad style.
//An unknown or conflicting QoS style was encountered.

#define WSA_QOS_BAD_OBJECT	11013 //QoS bad object.
//A problem was encountered with some part of the filterspec or the provider-specific buffer in general.

#define WSA_QOS_TRAFFIC_CTRL_ERROR	11014 //QoS traffic control error.
//An error with the underlying traffic control (TC) API as the generic QoS request was converted for local enforcement by the TC API. This could be due to an out of memory error or to an internal QoS provider error.

#define WSA_QOS_GENERIC_ERROR	11015 //QoS generic error.
//A general QoS error.

#define WSA_QOS_ESERVICETYPE	11016 //QoS service type error.
//An invalid or unrecognized service type was found in the QoS flowspec.

#define WSA_QOS_EFLOWSPEC	11017 //QoS flowspec error.
//An invalid or inconsistent flowspec was found in the QOS structure.

#define WSA_QOS_EPROVSPECBUF	11018 //Invalid QoS provider buffer.
//An invalid QoS provider-specific buffer.

#define WSA_QOS_EFILTERSTYLE	11019 //Invalid QoS filter style.
//An invalid QoS filter style was used.

#define WSA_QOS_EFILTERTYPE	11020 //Invalid QoS filter type.
//An invalid QoS filter type was used.

#define WSA_QOS_EFILTERCOUNT	11021 //Incorrect QoS filter count.
//An incorrect number of QoS FILTERSPECs were specified in the FLOWDESCRIPTOR.

#define WSA_QOS_EOBJLENGTH	11022 //Invalid QoS object length.
//An object with an invalid ObjectLength field was specified in the QoS provider-specific buffer.

#define WSA_QOS_EFLOWCOUNT	11023 //Incorrect QoS flow count.
//An incorrect number of flow descriptors was specified in the QoS structure.

#define WSA_QOS_EUNKOWNPSOBJ	11024 //Unrecognized QoS object.
//An unrecognized object was found in the QoS provider-specific buffer.

#define WSA_QOS_EPOLICYOBJ	11025 //Invalid QoS policy object.
//An invalid policy object was found in the QoS provider-specific buffer.

#define WSA_QOS_EFLOWDESC	11026 //Invalid QoS flow descriptor.
//An invalid QoS flow descriptor was found in the flow descriptor list.

#define WSA_QOS_EPSFLOWSPEC	11027 //Invalid QoS provider-specific flowspec.
//An invalid or inconsistent flowspec was found in the QoS provider-specific buffer.

#define WSA_QOS_EPSFILTERSPEC	11028 //Invalid QoS provider-specific filterspec.
//An invalid FILTERSPEC was found in the QoS provider-specific buffer.

#define WSA_QOS_ESDMODEOBJ	11029 //Invalid QoS shape discard mode object.
//An invalid shape discard mode object was found in the QoS provider-specific buffer.

#define WSA_QOS_ESHAPERATEOBJ	11030 //Invalid QoS shaping rate object.
//An invalid shaping rate object was found in the QoS provider-specific buffer.

#define WSA_QOS_RESERVED_PETYPE	11031 //Reserved policy QoS element type.
//A reserved policy element was found in the QoS provider-specific buffer.

//------------------------------------------------------------------	WSAErrorDescript
string WSAErrorDescript(int code)
  {
   string s=string(code);
   switch(code)
     {
      case WSA_INVALID_HANDLE: return("(#"+s+") Specified event object handle is invalid.");
      case WSA_NOT_ENOUGH_MEMORY: return("(#"+s+") Insufficient memory available.");
      case WSA_INVALID_PARAMETER: return("(#"+s+") One or more parameters are invalid.");
      case WSA_OPERATION_ABORTED: return("(#"+s+") Overlapped operation aborted.");
      case WSA_IO_INCOMPLETE: return("(#"+s+") Overlapped I/O event object not in signaled state.");
      case WSA_IO_PENDING: return("(#"+s+") Overlapped operations will complete later.");
      case WSAEINTR: return("(#"+s+") Interrupted function call.");
      case WSAEBADF: return("(#"+s+") File handle is not valid.");
      case WSAEACCES: return("(#"+s+") Permission denied.");
      case WSAEFAULT: return("(#"+s+") Bad address.");
      case WSAEINVAL: return("(#"+s+") Invalid argument.");
      case WSAEMFILE: return("(#"+s+") Too many open files.");
      case WSAEWOULDBLOCK: return("(#"+s+") Resource temporarily unavailable.");
      case WSAEINPROGRESS: return("(#"+s+") Operation now in progress.");
      case WSAEALREADY: return("(#"+s+") Operation already in progress.");
      case WSAENOTSOCK: return("(#"+s+") Socket operation on nonsocket.");
      case WSAEDESTADDRREQ: return("(#"+s+") Destination address required.");
      case WSAEMSGSIZE: return("(#"+s+") Message too long.");
      case WSAEPROTOTYPE: return("(#"+s+") Protocol wrong type for socket.");
      case WSAENOPROTOOPT: return("(#"+s+") Bad protocol option.");
      case WSAEPROTONOSUPPORT: return("(#"+s+") Protocol not supported.");
      case WSAESOCKTNOSUPPORT: return("(#"+s+") Socket type not supported.");
      case WSAEOPNOTSUPP: return("(#"+s+") Operation not supported.");
      case WSAEPFNOSUPPORT: return("(#"+s+") Protocol family not supported.");
      case WSAEAFNOSUPPORT: return("(#"+s+") Address family not supported by protocol family.");
      case WSAEADDRINUSE: return("(#"+s+") Address already in use.");
      case WSAEADDRNOTAVAIL: return("(#"+s+") Cannot assign requested address.");
      case WSAENETDOWN: return("(#"+s+") Network is down.");
      case WSAENETUNREACH: return("(#"+s+") Network is unreachable.");
      case WSAENETRESET: return("(#"+s+") Network dropped connection on reset.");
      case WSAECONNABORTED: return("(#"+s+") Software caused connection abort.");
      case WSAECONNRESET: return("(#"+s+") Connection reset by peer.");
      case WSAENOBUFS: return("(#"+s+") No buffer space available.");
      case WSAEISCONN: return("(#"+s+") Socket is already connected.");
      case WSAENOTCONN: return("(#"+s+") Socket is not connected.");
      case WSAESHUTDOWN: return("(#"+s+") Cannot send after socket shutdown.");
      case WSAETOOMANYREFS: return("(#"+s+") Too many references.");
      case WSAETIMEDOUT: return("(#"+s+") Connection timed out.");
      case WSAECONNREFUSED: return("(#"+s+") Connection refused.");
      case WSAELOOP: return("(#"+s+") Cannot translate name.");
      case WSAENAMETOOLONG: return("(#"+s+") Name too long.");
      case WSAEHOSTDOWN: return("(#"+s+") Host is down.");
      case WSAEHOSTUNREACH: return("(#"+s+") No route to host.");
      case WSAENOTEMPTY: return("(#"+s+") Directory not empty.");
      case WSAEPROCLIM: return("(#"+s+") Too many processes.");
      case WSAEUSERS: return("(#"+s+") User quota exceeded.");
      case WSAEDQUOT: return("(#"+s+") Disk quota exceeded.");
      case WSAESTALE: return("(#"+s+") Stale file handle reference.");
      case WSAEREMOTE: return("(#"+s+") Item is remote.");
      case WSASYSNOTREADY: return("(#"+s+") Network subsystem is unavailable.");
      case WSAVERNOTSUPPORTED: return("(#"+s+") Winsock.dll version out of range.");
      case WSANOTINITIALISED: return("(#"+s+") Successful WSAStartup not yet performed.");
      case WSAEDISCON: return("(#"+s+") Graceful shutdown in progress.");
      case WSAENOMORE: return("(#"+s+") No more results.");
      case WSAECANCELLED: return("(#"+s+") Call has been canceled.");
      case WSAEINVALIDPROCTABLE: return("(#"+s+") Procedure call table is invalid.");
      case WSAEINVALIDPROVIDER: return("(#"+s+") Service provider is invalid.");
      case WSAEPROVIDERFAILEDINIT: return("(#"+s+") Service provider failed to initialize.");
      case WSASYSCALLFAILURE: return("(#"+s+") System call failure.");
      case WSASERVICE_NOT_FOUND: return("(#"+s+") Service not found.");
      case WSATYPE_NOT_FOUND: return("(#"+s+") Class type not found.");
      case WSA_E_NO_MORE: return("(#"+s+") No more results.");
      case WSA_E_CANCELLED: return("(#"+s+") Call was canceled.");
      case WSAEREFUSED: return("(#"+s+") Database query was refused.");
      case WSAHOST_NOT_FOUND: return("(#"+s+") Host not found.");
      case WSATRY_AGAIN: return("(#"+s+") Nonauthoritative host not found.");
      case WSANO_RECOVERY: return("(#"+s+") This is a nonrecoverable error.");
      case WSANO_DATA: return("(#"+s+") Valid name, no data record of requested type.");
      case WSA_QOS_RECEIVERS: return("(#"+s+") QoS receivers.");
      case WSA_QOS_SENDERS: return("(#"+s+") QoS senders.");
      case WSA_QOS_NO_SENDERS: return("(#"+s+") No QoS senders.");
      case WSA_QOS_NO_RECEIVERS: return("(#"+s+") QoS no receivers.");
      case WSA_QOS_REQUEST_CONFIRMED: return("(#"+s+") QoS request confirmed.");
      case WSA_QOS_ADMISSION_FAILURE: return("(#"+s+") QoS admission error.");
      case WSA_QOS_POLICY_FAILURE: return("(#"+s+") QoS policy failure.");
      case WSA_QOS_BAD_STYLE: return("(#"+s+") QoS bad style.");
      case WSA_QOS_BAD_OBJECT: return("(#"+s+") QoS bad object.");
      case WSA_QOS_TRAFFIC_CTRL_ERROR: return("(#"+s+") QoS traffic control error.");
      case WSA_QOS_GENERIC_ERROR: return("(#"+s+") QoS generic error.");
      case WSA_QOS_ESERVICETYPE: return("(#"+s+") QoS service type error.");
      case WSA_QOS_EFLOWSPEC: return("(#"+s+") QoS flowspec error.");
      case WSA_QOS_EPROVSPECBUF: return("(#"+s+") Invalid QoS provider buffer.");
      case WSA_QOS_EFILTERSTYLE: return("(#"+s+") Invalid QoS filter style.");
      case WSA_QOS_EFILTERTYPE: return("(#"+s+") Invalid QoS filter type.");
      case WSA_QOS_EFILTERCOUNT: return("(#"+s+") Incorrect QoS filter count.");
      case WSA_QOS_EOBJLENGTH: return("(#"+s+") Invalid QoS object length.");
      case WSA_QOS_EFLOWCOUNT: return("(#"+s+") Incorrect QoS flow count.");
      case WSA_QOS_EUNKOWNPSOBJ: return("(#"+s+") Unrecognized QoS object.");
      case WSA_QOS_EPOLICYOBJ: return("(#"+s+") Invalid QoS policy object.");
      case WSA_QOS_EFLOWDESC: return("(#"+s+") Invalid QoS flow descriptor.");
      case WSA_QOS_EPSFLOWSPEC: return("(#"+s+") Invalid QoS provider-specific flowspec.");
      case WSA_QOS_EPSFILTERSPEC: return("(#"+s+") Invalid QoS provider-specific filterspec.");
      case WSA_QOS_ESDMODEOBJ: return("(#"+s+") Invalid QoS shape discard mode object.");
      case WSA_QOS_ESHAPERATEOBJ: return("(#"+s+") Invalid QoS shaping rate object.");
      case WSA_QOS_RESERVED_PETYPE: return("(#"+s+") Reserved policy QoS element type.");
     }
   return("(#"+s+") Unknow error");
  }
//+------------------------------------------------------------------+
