# Secure payments setup

Y-Chat no longer accepts a typed transaction ID or credits balance from a browser request. The app creates Stripe Checkout Sessions on the server, then only credits a wallet or enables a badge after Stripe confirms the paid Session. Session fulfillment is idempotent by Stripe Checkout Session ID.

## Required server environment

- STRIPE_SECRET_KEY: secret key from the Stripe account. Keep it server-side; never put it in JSP/JavaScript or commit it.
- STRIPE_WEBHOOK_SECRET: signing secret for the webhook endpoint.
- APP_BASE_URL: public app origin plus context path, for example https://your-domain.example/ychatApp. Local development defaults to http://localhost:8080/ychatApp.

The app creates a USD $4.99 Blue Badge Checkout Session and USD $5-$500 wallet top-up Sessions. bKash/Nagad direct checkout is disabled until those providers' merchant APIs are separately integrated. Creator tips can currently be paid from wallet only.

## Webhook

Register POST https://your-domain.example/ychatApp/StripeWebhookServlet in Stripe and enable checkout.session.completed and checkout.session.async_payment_succeeded. Set the endpoint's whsec value as STRIPE_WEBHOOK_SECRET. The signed webhook is verified before settlement. Stripe recommends fulfilling Checkout Sessions from webhooks because a customer may not return to the success URL ([Stripe Checkout fulfillment](https://docs.stripe.com/payments/existing-customers?platform=web&ui=stripe-hosted)).

For localhost testing, run Stripe CLI webhook forwarding to the endpoint and use the signing secret printed by the CLI. Stripe API keys are server credentials and must remain secret ([Stripe API authentication](https://docs.stripe.com/api/authentication)).

Set APP_BASE_URL to the HTTPS host used by the browser before live mode. A Stripe account must be activated in a Stripe-supported business country. USD card checkout is used for the badge and wallet top-ups ([Stripe global availability](https://stripe.com/global), [supported currencies](https://docs.stripe.com/currencies)).
