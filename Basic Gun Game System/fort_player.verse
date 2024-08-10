using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }

fort_player := class():

    Player : player
    Agent : agent
    FortCharacter : fort_character
    MovMods : []movement_modulator_device

    var Streak : int = 0
    var Eliminations : int = 0

    var Canvas : custom_ui = custom_ui{} 
    var WeaponGranter : item_granter_device = item_granter_device{} 
    var Accolades : accolades_device = accolades_device{}

    InitialConfig(NewItemGranter : item_granter_device, Acc : accolades_device):void=
        set WeaponGranter = NewItemGranter
        set Accolades = Acc
        GiveWeapon()  
        
        CreateUI()

            
    UpdateEliminations():void=
        set Streak += 1
        Accolades.Award(Agent)
        set Eliminations += 1
        UpdateStreakUI()
        GiveWeapon()

    GiveWeapon():void=
        WeaponGranter.SetNextItem(Eliminations)
        WeaponGranter.GrantItem(Agent)
        UpdateUI()

    CreateUI():void=
        Canvas.PlayerSpawnedCanvas(Agent)
        Canvas.SetMyElims(Eliminations)
        ResetStreak()

    UpdateUI():void=
        Canvas.SetMyElims(Eliminations)

    UpdateStreakUI():void=
        if(Streak > 0 and Streak < 6):
            ActivateModulator(Streak)
            if(HaveStreakMissionActive = true):
                IncrementTracker()
        Canvas.SetMyStreak(Streak)

    ResetStreak():void=
        set Streak = 0
        Canvas.SetMyStreak(Streak)
        if(HaveStreakMissionActive = true):
            StreakQuestTracker.SetValue(Agent, 0)

    ActivateModulator(Index : int):void=
        if:
            Modulator := MovMods[Index]
        then:
            Modulator.Activate(Agent)

