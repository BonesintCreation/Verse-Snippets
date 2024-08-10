
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }

# Verse Tag for Spawners
spawner := class(tag){}

gun_game_manager := class(creative_device):

    @editable # Item granter for weapons
    ItemGranter : item_granter_device = item_granter{} 

    var FortPlayers : [agent]?fort_player = map{} # Map of players 
 
    @editable # Accolade Device to award player for elimination
    ElimAcc : accolades_device = accolades_device{}

    @editable # Speed Bonus Movement Modulators
    MovementModulators : []movement_modulator_device = array{} 


    OnBegin<override>()<suspends>:void=
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerLeftServer)
        
    InitSpawners():void=
        Spawners := GetCreativeObjectsWithTag(spawner{})
        for (Obj : Spawners):
            if (Spawner := player_spawner_device[Obj]):
                Spawner.SpawnedEvent.Subscribe(OnPlayerSpawned)

    OnPlayerSpawned(Agent : agent):void=
        InitPlayer(Agent)

    InitPlayer(Agent : agent):void=
        if:
            Player := player[Agent]
            FortChar := Agent.GetFortCharacter[]
        then:
            if(Existing := FortPlayers[Agent]):
            else:
                NewFortPlayer := fort_player{Agent := Agent, Player := Player, FortCharacter := FortChar, MovMods:=MovementModulators}
                NewFortPlayer.InitialConfig(ItemGranter, ElimAcc)
                FortChar.EliminatedEvent().Subscribe(OnPlayerEliminated)
                
                AddToFortPlayers(Agent, option{NewFortPlayer})

    AddToFortPlayers(Agent : agent, FortPlayer : ?fort_player):void=
        
            var AuxMap : [agent]?fort_player = map{Agent => FortPlayer}  

            if(set AuxMap[Agent] = FortPlayer, ValueOfIndex := AuxMap[Agent]):
                set FortPlayers = ConcatenateMaps(FortPlayers, AuxMap)


    OnPlayerEliminated(Result : elimination_result):void=

        if:
            Eliminating := Result.EliminatingCharacter?
            ElimAgent := Eliminating.GetAgent[]
            ElimPlayer := player[ElimAgent]

            Eliminated := Result.EliminatedCharacter
            EliminatedAgent := Eliminated.GetAgent[]
            EliminatedPlayer := player[EliminatedAgent]
            
        then:
            if (not (Result.EliminatedCharacter = Result.EliminatingCharacter?)):
                if:
                    EliminatedFortPlayer := GetFortPlayer[EliminatedAgent]
                    EliminatingFortPlayer := GetFortPlayer[ElimAgent]
                then:
                    EliminatedFortPlayer.ResetStreak()
                    EliminatingFortPlayer.UpdateEliminations()

    GetFortPlayer(Agent : agent)<transacts><decides>:fort_player=

        var FortArray : []fort_player = array{} 
        var FortToConvert:?fort_player = false

        for(Ag -> FP : FortPlayers):
            if(Ag = Agent):
                set FortToConvert = FP
        if:
            FortToReturn := fort_player[FortToConvert?]
        then:
            set FortArray = array{FortToReturn}
        return FortArray[0]

    OnPlayerLeftServer(PlayerLeaving : agent):void=

        var NewPlayerMap : [agent]?fort_player = map{}

        for (Key -> Value : FortPlayers, Key <> PlayerLeaving):
            set NewPlayerMap = ConcatenateMaps(NewPlayerMap, map {Key => Value})

        set FortPlayers = NewPlayerMap
