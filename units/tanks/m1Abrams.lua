function createM1Abrams(x, y, isPlayer)
    return createTank(x, y, isPlayer, createM1AbramsTurret(), M1_ABRAMS_BODY_IMAGE, M1_ABRAMS_TURRET_IMAGE)
end