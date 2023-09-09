local pt-br = {
  error = {
    error = 'Erro, por favor, entre em contato com o suporte',
    error_cid = 'Erro, o CID não é reconhecido',
    market_no_money = 'O vendedor não tem dinheiro na banca dele!',
    player_no_money = 'Você está sem dinheiro',
  },

  success = {
    robreward = 'Você recuperou $',
    newname = 'Nome alterado com sucesso',
    transfer_t = 'Transferência',
    transfer = 'Stalker entregue para ',
    buy_t = 'Compra',
    buy = 'Você comprou a banca',
    refill = 'Você depositou ',
    buy_prod = 'Compra de ',
  },

  menu = {
    market = 'Mercado',
    quit = "Sair",
    return_m = "Voltar",
    buy = 'Comprar',
    buy_sub = "Preço de compra",
    open_market = 'Barraca',
    open_market_sub = 'Compra de itens de todos os tipos',
    rob = 'Barraca',
    rob_sub = 'Por sua conta e risco',
    refill = 'Reabastecer a barraca',
    refill_sub = 'Coloque seus itens na barraca',
    refill_in = 'Aqui está a lista de produtos disponíveis para venda!',
    checkmoney = 'Ver o caixa',
    checkmoney_sub = 'Verificar / coletar o saldo',
    manage = 'Gerenciamento da barraca',
    manage_sub = 'Gerenciar o nome, entregar a barraca, recuperar artigos',
    market_sub = 'Aqui está a lista de produtos, o estoque e o preço unitário',
    instock = 'Um log',
    price = 'Preço unitário: $',
    no_item = 'Nenhum produto',
    no_item_sub = 'Você não tem produtos para colocar na barraca!',
    in_inv = 'No inventário',
    checkmoney_in = 'Aqui está o seu caixa',
    currentmoney = 'Saldo do caixa',
    withdraw = 'Retirar dinheiro',
    withdraw_sub = 'O dinheiro será entregue em espécie!',
    confirm_buy = 'Validar a compra',
    confirm_buy_sub = '(Você deve ter dinheiro suficiente para comprar)!',
    manage_in = 'Gerenciamento da sua barraca',
    manage_in_name = 'Mudar o nome',
    manage_in_name_sub = 'Um novo nome para a sua barraca?!',
    manage_in_give_market = 'Entregar a barraca',
    manage_in_give_market_sub = 'Atenção, ação irreversível',
    buy_price = 'Preço',
  },

  input  = {
    validate = 'Validar',
    give_market = 'Por favor, indique o ID permanente do destinatário (/cid)',
    give_market_champ = '(caixa sensível a maiúsculas)',
    name = 'Novo nome da sua barraca',
    name_champ = 'nome da sua barraca',
    withdraw = 'Retirar dinheiro: (máx: $',
    withdraw_champ = 'Quantia',
    refill = 'Venda',
    howmany_buy = 'Quantos você deseja comprar?',
    qt = 'Quantos?',
    refill_price = 'Preço de venda',
  },

  rob = {
    fail = 'O comerciante pega em armas! Fuja!',
    good = 'Roubo em andamento...',
    already = 'A banca já foi virada, volte mais tarde!',
    need_gun = 'Você precisa estar armado para poder assaltar o comerciante!',
  },

  other = {
    blips = 'Vendedor de Mercado',
    prompt = 'Abrir Mercado',
  },
}


----------------------------------------------------------------------------------------

if GetConvar('rsg_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
