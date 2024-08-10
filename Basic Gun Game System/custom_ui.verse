
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using{ /Verse.org/Colors}
using{ /Verse.org/Colors/NamedColors}


custom_ui := class():

    var MyElims : int = 0
    var MyStreak : int = 0

    var UIStuffPerAgent : [agent]?tuple(canvas, text_block, text_block) = map{}

    RefreshRate :float = 0.5 

    SetMyElims(Value : int):void=
        set MyElims = Value

    SetMyStreak(Value : int):void=
        set MyStreak = Value

    S2M<localizes>(S:string):message="{S}"
    
    UpdateUI(A:agent):void=
        var SpeedBoost : string = ""
        if(Stuff := UIStuffPerAgent[A]?):
            Stuff(1).SetText(S2M("{MyElims}"))
            
            if(MyStreak > 0 and MyStreak <= 5):
                case(MyStreak):
                    1 =>
                        set SpeedBoost = "(+0.5 Speed)"
                    2 =>
                        set SpeedBoost = "(+1.0 Speed)"
                    3 =>
                        set SpeedBoost = "(+1.5 Speed)"
                    4 =>
                        set SpeedBoost = "(+2.0 Speed)"
                    5 =>
                        set SpeedBoost = "(Max Speed)"
                    _=>
                        set SpeedBoost = ""
            else if(MyStreak > 5):
                set SpeedBoost = "(Max Speed)"
            Stuff(2).SetText(S2M("{MyStreak} {SpeedBoost}"))
     

    PlayerSpawnedCanvas(A:agent):void=
        if(Stuff:=UIStuffPerAgent[A]?):
    
        else:
            AddUI(A)

    RemoveUI(A:agent):void=
        if:
            PlayerUI:=GetPlayerUI[player[A]]
            Stuff:=UIStuffPerAgent[A]?
        then:
            PlayerUI.RemoveWidget(Stuff(0))
            if(set UIStuffPerAgent[A] = false){}

    AddUI(A:agent):void=
        if:
            PlayerUI:=GetPlayerUI[player[A]]
        then:
            Stuff:=MakeCanvas()
            Canvas:=Stuff(0)
            GoldBlock:=Stuff(1)
            FuelBlock:=Stuff(2)

            PlayerUI.AddWidget(Canvas)
            if(set UIStuffPerAgent[A] = option{Stuff}){}
            spawn{LoopUpdate(A)}

    LoopUpdate(A:agent)<suspends>:void=
        loop:
            Sleep(RefreshRate)
            UpdateUI(A)
            if(not UIStuffPerAgent[A]?):
                break
 

    MakeCanvas():tuple(canvas,text_block,text_block)=
        
        MoneyText:=text_block{DefaultText:= S2M("Eliminations:"), DefaultTextColor:=White, DefaultShadowOffset:=option{vector2{X:=2.5,Y:=2.5}}, DefaultShadowColor:=Red}
        GoldTextBlock:=text_block{DefaultTextColor:=White, DefaultShadowOffset:=option{vector2{X:=2.5,Y:=2.5}}, DefaultShadowColor:=Red}
        MoneyText.SetShadowOpacity(1.0)
        GoldTextBlock.SetShadowOpacity(1.0)

        FuelText:=text_block{DefaultText:= S2M("Streak:"), DefaultTextColor:=White, DefaultShadowOffset:=option{vector2{X:=2.5,Y:=2.5}}, DefaultShadowColor:=Blue}
        FuelTextBlock:=text_block{DefaultTextColor:=White, DefaultShadowOffset:=option{vector2{X:=2.5,Y:=2.5}}, DefaultShadowColor:=Blue}
        FuelText.SetShadowOpacity(1.0)
        FuelTextBlock.SetShadowOpacity(1.0)


        MyCanvas:= canvas:
            Slots:=array:
     
                canvas_slot:
         
                    Anchors:=anchors{Minimum:=vector2{X:=0.0, Y:=0.7}, Maximum:=vector2{X:=0.0, Y:=0.7}}
                    Offsets:=margin{}
                    Alignment:=vector2{X:=0.0, Y:=1.0}
                    SizeToContent:=true
                    Widget:=stack_box:
           
                        Orientation:=orientation.Vertical
                        Slots:=array:
           
                            stack_box_slot:
                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Fill
                              
                                Widget:=overlay:
                                    Slots:=array:
                     
                                        overlay_slot:
                                            HorizontalAlignment:=horizontal_alignment.Fill
                                            VerticalAlignment:=vertical_alignment.Fill
                                            Widget:=texture_block:
                                                DefaultImage:=UI.elim_bar
                                                DefaultDesiredSize:=vector2{X:=400.0, Y:= 100.0}

                                        overlay_slot:
                                            HorizontalAlignment:=horizontal_alignment.Left
                                            VerticalAlignment:=vertical_alignment.Center
                                            Padding:=margin{Left:=60.0, Right:=0.0}
                                            Widget:=stack_box:
                                                Orientation:=orientation.Horizontal
                                                Slots:=array: 
   
                                                    stack_box_slot:
                                            
                                                        Widget:=MoneyText
                                                        HorizontalAlignment:=horizontal_alignment.Fill
                                                        VerticalAlignment:=vertical_alignment.Fill
                                                        Padding:=margin{Left:=55.0, Top:=5.0, Right:=5.0, Bottom:=5.0}
                                                    stack_box_slot:
                                                 
                                                        Widget:=GoldTextBlock
                                                        HorizontalAlignment:=horizontal_alignment.Fill
                                                        VerticalAlignment:=vertical_alignment.Fill
                                                        Padding:=margin{Left:=5.0, Top:=5.0, Right:=5.0, Bottom:=5.0}

  
                            stack_box_slot:
                                HorizontalAlignment:=horizontal_alignment.Left
                                VerticalAlignment:=vertical_alignment.Fill
                                Padding:=margin{Top:=30.0, Bottom:=30.0}
                                Widget:=stack_box:
                                    Orientation:=orientation.Vertical
                                    Slots:=array:
                                        stack_box_slot:
                                            HorizontalAlignment:=horizontal_alignment.Left
                                            VerticalAlignment:=vertical_alignment.Fill
                                          
                                            Widget:=overlay:
                                                Slots:=array:
                                                    overlay_slot:
                                                        HorizontalAlignment:=horizontal_alignment.Fill
                                                        VerticalAlignment:=vertical_alignment.Fill
                                                        Widget:=texture_block:
                                                            DefaultImage:=UI.streak_bar
                                                            DefaultDesiredSize:=vector2{X:=400.0, Y:= 100.0}

                                                    overlay_slot:
                                                        HorizontalAlignment:=horizontal_alignment.Left
                                                        VerticalAlignment:=vertical_alignment.Center
                                                        Padding:=margin{Left:=50.0, Right:=0.0}
                                                        Widget:=stack_box:
                                                            Orientation:=orientation.Horizontal
                                                            Slots:=array:
  
                                                                stack_box_slot:
                                                                
                                                                    Widget:=FuelText
                                                                    HorizontalAlignment:=horizontal_alignment.Fill
                                                                    VerticalAlignment:=vertical_alignment.Fill
                                                                    Padding:=margin{Left:=55.0, Top:=5.0, Right:=5.0, Bottom:=5.0}
                                                                stack_box_slot:
                                                                    Widget:=FuelTextBlock
                                                                    HorizontalAlignment:=horizontal_alignment.Fill
                                                                    VerticalAlignment:=vertical_alignment.Fill
                                                                    Padding:=margin{Left:=5.0, Top:=5.0, Right:=5.0, Bottom:=5.0}



        return (MyCanvas, GoldTextBlock, FuelTextBlock)
