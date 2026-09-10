
--These buildings can't get prosperity so we substract them from CityNumber in GUI_Goods.ProsperityUpdate()
GUI_Goods.ExceptionBuildingTypes = {
        Entities.B_Barracks,
        Entities.B_BarracksArchers,
        Entities.B_SiegeEngineWorkshop,
        Entities.B_Barracks_RedPrince,
        Entities.B_BarracksArchers_Redprince,
        Entities.B_Barracks_Khana,
        Entities.B_BarracksArchers_Khana,
        Entities.B_BarracksSpearmen,
        Entities.B_BarracksCavalry
}

-----------------------------------------------------------------------------------------
-- Overwrites for Goods
-----------------------------------------------------------------------------------------

function InitOverwriteGoodsEx2()

    do
        function GUI_Goods.ProsperityUpdate()
            local PlayerID = GUI.GetPlayerID()
            local CityNumber = Logic.GetNumberOfPlayerEntitiesInCategory(PlayerID, EntityCategories.CityBuilding)

            --These buildings cant get prosperity so we substract them from CityNumber
            local exceptions = 0
            for i = 1, #GUI_Goods.ExceptionBuildingTypes do
                local numberOfEntities = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, GUI_Goods.ExceptionBuildingTypes[i])
        
                CityNumber = CityNumber - numberOfEntities
            end

            local RichNumber = Logic.GetNumberOfProsperBuildings(PlayerID, 1)
            local PoorNumber = CityNumber - RichNumber

            local MotherContainerPath = XGUIEng.GetWidgetPathByID(XGUIEng.GetWidgetsMotherID(XGUIEng.GetCurrentWidgetID()))
            XGUIEng.SetText(MotherContainerPath .. "/CityBuildings/CityBuildingsNumber", "{center}" .. CityNumber)

            XGUIEng.SetText(MotherContainerPath .. "/RichAmount", "{center}" .. RichNumber)
            XGUIEng.SetText(MotherContainerPath .. "/PoorAmount", "{center}" .. PoorNumber)
        end
    end

end