using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

### MADE BY BONESINT ###

main_device := class(creative_device):
  
  @editable
  Prop : creative_prop = creative_prop{}
  
  @editable
  PropManipulator : prop_manipulator_device = prop_manipulator_device{}
  
  OnBegin<override>()<suspends>:void=
    ConfigPropManipulator()
    
  ConfigPropManipulator():void=
    PropManipulator.DamagedEvent.Subscribe(HitManipulator)
    
  HitManipulator(Agent : agent):void=
    spawn:
      BounceAnimation(Prop)

  BounceAnimation(Prop : creative_prop)<suspends>:void=
        DefaultTransform := Prop.GetTransform()
        NewTransform := transform{Scale:=vector3{(X:=DefaultTransform.Scale.X+0.01),(Y:=DefaultTransform.Scale.Y+0.01),(Z:=DefaultTransform.Scale.Z+0.01)} , Rotation:=Prop.GetTransform().Rotation, Translation:=Prop.GetTransform().Translation}
        NewTransform2 := transform{Scale:=vector3{(X:=DefaultTransform.Scale.X+0.05),(Y:=DefaultTransform.Scale.Y+0.05),(Z:=DefaultTransform.Scale.Z+0.05)}, Rotation:=Prop.GetTransform().Rotation, Translation:=Prop.GetTransform().Translation}
        NewTransform3 := transform{Scale:=vector3{(X:=DefaultTransform.Scale.X+0.02),(Y:=DefaultTransform.Scale.Y+0.02),(Z:=DefaultTransform.Scale.Z+0.02)}, Rotation:=Prop.GetTransform().Rotation, Translation:=Prop.GetTransform().Translation}
        
        loop:
            Prop.MoveTo(NewTransform, 0.1)
            Prop.MoveTo(DefaultTransform, 0.1)
            Prop.MoveTo(NewTransform2, 0.05)
            Prop.MoveTo(DefaultTransform, 0.05)
            Prop.MoveTo(NewTransform3, 0.02)
            Prop.MoveTo(DefaultTransform, 0.02)
            break
  
