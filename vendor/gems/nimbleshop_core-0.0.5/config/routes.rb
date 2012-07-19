Rails.application.routes.draw do


  mount NimbleshopAuthorizedotnet::Engine, at: '/nimbleshop_authorizedotnet'
  mount NimbleshopPaypalwp::Engine,        at: '/nimbleshop_paypalwp'
 
end
