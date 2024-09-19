using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

custom_car_audio := class(creative_device):

    @editable
    AudioPlayer : audio_player_device = audio_player_device{}

    @editable
    CarSpawner : vehicle_spawner_sports_car_device = vehicle_spawner_sports_car_device{}

    var IsPlayerInsideCar : logic = true
  
    OnBegin<override>()<suspends>:void=

        CarSpawner.AgentEntersVehicleEvent.Subscribe(EnterVehicle)
        CarSpawner.AgentExitsVehicleEvent.Subscribe(ExitVehicle)

    FollowPlayer(FortCharacter : fort_character):void=  
        spawn:
            FollowLoop(FortCharacter)

    FollowLoop(FortCharacter : fort_character)<suspends>:void=
        loop:
            if(IsPlayerInsideCar = true):
                AudioPlayer.Play()
                if:
                    AudioPlayer.TeleportTo[FortCharacter.GetTransform().Translation, FortCharacter.GetTransform().Rotation]
            else if(IsPlayerInsideCar = false):
                AudioPlayer.Stop()
                break
            Sleep(0.1)

    EnterVehicle(Agent : agent):void=
        set IsPlayerInsideCar = true
        if:
            FortCharacter := Agent.GetFortCharacter[]
        then:
            FollowPlayer(FortCharacter)
        
    ExitVehicle(Agent : agent):void=
        set IsPlayerInsideCar = false
