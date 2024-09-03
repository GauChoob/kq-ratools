import projutils.utils as utils

sym = utils.SymFile('python/vars.sym')
with open('kq.gbc', 'rb') as f:
    kq = f.read()
rom = utils.Rom('kq.gbc')

exit = b'\xA6You found\xFFthe exit!'
secret = b'\xA6You found\xFFa SECRET!'


class Position:
    def __init__(self, position):
        self.addr = utils.BankAddress(position)
        curpos = utils.BankAddress(position)
        count = 1
        #print(curpos)
        if curpos == utils.BankAddress(0x16, 0x487A):
            # Skip some unexpected 0x48 bytes (hardcoded)
            count = 2
        while self.addr.getBank() == curpos.getBank():
            if rom.getByte(curpos) == 0x48:
                bank, addr = rom.getBankAddress(curpos + 1)
                count -= 1
                if count == 0:
                    break
            curpos += 1
        self.sym = sym.getSymbol(bank, addr, 'X')[0]
        if self.sym == 'X_18_5F67':
            self.sym = 'Script_StartRoom_SecretComplete'

    def bank_address(self):
        return self.addr.getBank() + self.addr.getAddress()*0x100

    def code_note(self):
        return f'0x{self.bank_address():06X} = bank_address(0x{self.addr.getPos():06X}) = {self.sym}'

    def rascript(self):
        return f'{self.sym} = bank_address(0x{self.addr.getPos():06X})'

positions = []

def find_positions(pattern):
    curpos = 0
    while True:
        addr = kq.find(pattern, curpos)
        if addr == -1:
            break
        positions.append(Position(addr))
        curpos = addr + 1

find_positions(exit)
find_positions(secret)

for position in positions:
    print(position.rascript())

positions.sort(key=lambda x:x.bank_address())
for position in positions:
    print(position.code_note())
