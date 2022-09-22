function createM1911()
    return createGun(
        7, -- magazine size
        1, -- shot delay
        4, -- reload time
        0.1, -- acuracy mod,
        0.7, -- velocity mod,
        0, -- min range
        1000, -- max range
        1, -- weight
        create45acp() -- ammo
    )
end