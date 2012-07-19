NimbleshopPaypalwp::Engine.routes.draw do
  resource :paypalwp do
    collection do
      post :notify
    end
  end
  resource :payment
end
