import random

min_mana = 100000000

def fight():

    mana_used = 0

    boss_hp = 58
    boss_dmg = 9

    player_hp = 50
    player_mp = 500
    player_armor = 0

    spells = [['Magic Missile', 53],['Drain', 73],['Shield', 113],['Poison', 173],['Recharge', 229]]

    turn = 'player'

    shield_active = False
    shield_count = 0

    poison_active = False
    poison_count = 0

    recharge_active = False
    recharge_count = 0

    while True:

        if shield_active:
            player_armor = 7
            shield_count += 1
            if shield_count == 6:
                shield_active = False
        else:
            player_armor = 0

        if poison_active:
            boss_hp -= 3
            if boss_hp <= 0:
                return ['player wins', mana_used]
            poison_count += 1
            if poison_count == 6:
                poison_active = False

        if recharge_active:
            player_mp += 101
            recharge_count += 1
            if recharge_count == 5:
                recharge_active = False

        if turn == 'player':

            # uncomment this section for part 2
            player_hp -= 1
            if player_hp <= 0:
                return ['boss wins', mana_used]

            spell = None

            random.shuffle(spells)

            for s in spells:
                if player_mp >= s[1]:
                    if s[0] == 'Shield':
                        if shield_active:
                            continue
                    if s[0] == 'Poison':
                        if poison_active:
                            continue
                    if s[0] == 'Recharge':
                        if recharge_active:
                            continue
                    spell = s 
                    break

            if spell == None:
                return ['boss wins', mana_used]

            player_mp -= spell[1]
            if player_mp < 0:
                player_mp = 0

            mana_used += spell[1]

            if spell[0] == 'Magic Missile':
                boss_hp -= 4
                if boss_hp <= 0:
                    return ['player wins', mana_used]

            if spell[0] == 'Drain':
                boss_hp -= 2
                if boss_hp <= 0:
                    return ['player wins', mana_used]
                player_hp += 2

            if spell[0] == 'Shield':
                player_armor = 7
                shield_active = True
                shield_count = 0

            if spell[0] == 'Poison':
                poison_active = True
                poison_count = 0

            if spell[0] == 'Recharge':
                recharge_active = True
                recharge_count = 0

            turn = 'boss'

        else:

            dmg = boss_dmg - player_armor

            if dmg < 1:
                dmg = 1

            player_hp -= dmg

            if player_hp <= 0:
                return ['boss wins', mana_used]

            turn = 'player'


result = fight()

while True:
    result = fight()
    if result[0] == 'player wins':
        if result[1] < min_mana:
            min_mana = result[1]
            print result