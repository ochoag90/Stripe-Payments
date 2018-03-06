require 'sinatra'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key


get '/' do
	erb:index
end

post '/charge' do
	#Amount in cents
	@amount = 500

	customer = Stripe::Customer.create(
		:email => 'cusomer@example.com',
		:source => params[:stripeToken]
		)

	charge = Stripe::Charge.create(
		:amount 	 => @amount,
		:description => 'Sinatra Charge',
		:currency	 => 'usd',
		:customer 	 => customer.id
		)

	erb :charge
end 

error Stripe::CardError do
	env['sinatra.error'].message
end 

__END__

@@ layout

	<!DOCTYPE html>
	<html>
	<head></head>
	<body>
		<%=yield%>
	</body>
	</html>

@@index
	<form action="/charge" method="post" class="payment">
		<article>
			<label class="amount">
				<span>Amount:$5.00</span>
			</label>
		</article>

		<script src="https://checkout.stripe.com/checkout.js" class="stripe-button"
				data-key="<%= settings.publishable_key %>"
				data-description="A Month's subscription"
				data-amount="500"
				data-locale="auto">
		</script>
	</form>

@@charge
	<h2>Thanks, you paid <strong>$5.00</strong>!</h2>