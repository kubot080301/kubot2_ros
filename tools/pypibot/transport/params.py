import dataholder

pibotModel = "apollo"
boardType = "arduino"

pibotParam = dataholder.RobotParameters()
pibotBaud = 921600

if pibotModel == "apollo" and boardType == "arduino":
    pibotParam = dataholder.RobotParameters(65, 175, 1980, 10, \
                                                75, 2500, 0, 10, \
                                                250, 40, 0, 200, 69)
    pibotBaud = 115200
elif pibotModel == "apollo" and boardType == "stm32f1":
    pibotParam = dataholder.RobotParameters(65, 175, 1980, 10, \
                                                250, 2500, 0, 10, \
                                                250, 40, 0, 200, 69)
    pibotBaud = 115200
elif pibotModel == "apollo" and boardType == "stm32f4":
    pibotParam = dataholder.RobotParameters(65, 175, 1980, 10, \
                                                320, 2700, 0, 10, \
                                                250, 40, 0, 200, 69)
    pibotBaud = 921600