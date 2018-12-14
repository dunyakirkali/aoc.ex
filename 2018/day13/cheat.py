G = []
for line in open('priv/input.txt'):
    if line:
        G.append([c for c in line])

# up, right, down, left
DR = [-1, 0, 1, 0]
DC = [0,1,0,-1]
def left(d):
    return (d+3)%4
def right(d):
    return (d+1)%4

class Cart(object):
    def __init__(self, r, c, d, inter):
        self.r = r
        self.c = c
        self.d = d
        self.inter = inter
carts = []
for r in range(len(G)):
    for c in range(len(G[r])):
        if G[r][c] == '^':
            G[r][c] = '|'
            carts.append(Cart(r,c,0,0))
        if G[r][c] == '>':
            G[r][c] = '-'
            carts.append(Cart(r,c,1,0))
        elif G[r][c] == 'v':
            G[r][c] = '|'
            carts.append(Cart(r,c,2,0))
        elif G[r][c] == '<':
            G[r][c] = '-'
            carts.append(Cart(r,c,3,0))

def show():
    global G
    global carts
    for r in range(len(G)):
        for c in range(len(G[r])):
            has_cart = False
            for cart in carts:
                if cart.r == r and cart.c == c:
                    print {0: '^', 1:'>', 2:'v', 3:'<'}[cart.d],
                    has_cart = True
            if not has_cart:
                print G[r][c],
        print

while True:
    if len(carts) == 1:
        print '{},{}'.format(carts[0].c, carts[0].r)
        sys.exit(0)
    #show()
    carts = sorted(carts, key=lambda cart:(cart.r, cart.c))
    for cart in carts:
        rr = cart.r+DR[cart.d]
        cc = cart.c+DC[cart.d]
        # up, right, down, left
        if G[rr][cc] == '\\':
            cart.d = {0: 3, 1:2, 2:1, 3:0}[cart.d]
        elif G[rr][cc] == '/':
            cart.d = {0: 1, 1:0, 2:3, 3:2}[cart.d]
        elif G[rr][cc] == '+':
            if cart.inter == 0:
                cart.d = left(cart.d)
            elif cart.inter == 1:
                pass
            elif cart.inter == 2:
                cart.d = right(cart.d)
            cart.inter = (cart.inter + 1)%3
        if (rr,cc) in [(other.r, other.c) for other in carts]:
            carts = [other for other in carts if (other.r, other.c) not in [(cart.r, cart.c),(rr,cc)]]
            print '{},{}'.format(cc,rr)
        cart.r = rr
        cart.c = cc