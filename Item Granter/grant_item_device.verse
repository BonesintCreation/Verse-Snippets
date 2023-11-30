
using { /Fortnite.com/Devices }
# É necessária a importação do módulo /Fortnite.com/Playspaces para que a função GetPlayspace().GetPlayers() funcione.
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

grant_item_device := class(creative_device):

    # A variável Players é atribuída com uma array, ela irá receber os jogadores da partida
    var Players : []player = array{}

    # A constante ItemGranter será a referência ao Item Granter Device, ela deve possuir o tipo item_granter_device e herdar 
    # a classe item_granter_device{}, é necessário também adicionar o atributo @editable que torna a constante visível no editor
    @editable
    ItemGranter : item_granter_device = item_granter_device{}


    OnBegin<override>()<suspends>:void=
        # Aqui chamamos a função dentro da Main
        GiveItem()

        
    GiveItem():void=
        # Aqui modificamos o valor da variável para conter os jogadores da partida
        set Players = GetPlayspace().GetPlayers()
        # O loop for irá iterar por cada jogador da array (A cada Player em Players, faça algo...)
        for (Player : Players):
            # Aqui chamamos o método GrantItem em noso ItemGranter e passamos o Player como parâmetro, GrantItem é um método da classe item_granter_device{}
            # Basicamente dizemos para o Item Granter Device distribuir os itens ao jogador na iteração.
            ItemGranter.GrantItem(Player)