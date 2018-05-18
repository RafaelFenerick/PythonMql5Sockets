import socket, sys

def createServer(HOST, PORT):
    ''' Criar servidor '''

    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        print('Socket created')
    except:
        print('Failed to create socket.')
        sys.exit()

    try:
        s.bind((HOST, PORT))
        print('Socket bind complete')
    except:
        print('Bind failed')
        sys.exit()

    return s

def runServer(s):
    ''' Manter servidor recebendo mensagens '''

    while True:

        try:
            d = s.recvfrom(1024)
            data = d[0].decode('utf-8')
            addr = d[1]
        except:
            continue

        print("Dados recebidos: ", data)

        try:
            s.sendto(data.encode('utf-8'), addr)
        except:
            continue

    s.close()

if __name__ == "__main__":

    HOST = ''    # Host
    PORT = 8888  # Porta

    s = createServer(HOST, PORT)
    runServer(s)

