require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe SubscriptionsController do
  include_context 'user_setup'
  include_context 'subscription_setup'

  let(:subscription_fake_customers) {
    create_subscriptions
    @fake_subscription = Subscription.last
  }

  let(:create_params) {
      {subscription:
        {
          stripe_plan_id: @fake_subscription.stripe_plan_id,
          cancel_at_period_end: @fake_subscription.cancel_at_period_end,
          quantity: @fake_subscription.quantity,
          sub_start: @fake_subscription.sub_start,
          sub_end: @fake_subscription.sub_end,
          status: @fake_subscription.status,
          canceled_at: @fake_subscription.canceled_at,
          current_period_start: @fake_subscription.current_period_start,
          current_period_end: @fake_subscription.current_period_end,
          trial_start: @fake_subscription.trial_start,
          trial_end: @fake_subscription.trial_end,
          user_id: @fake_subscription.user_id,
        }
      }
    }

  # Credit card and stripe test data
    let(:cardnum) { "4242424242424242" }
    let(:email) { "johnsmith@example.com" }
    let(:name) { "John Smith" }
    let(:cvcvalue) { "313" }
    let(:token) { @token = get_token(name, cardnum, Date.today.month,
     (Date.today.year + 1), cvcvalue) }

  # STRIPE COUPON AND PLAN IDs -------------------------------------------

    let(:coupon_code) { "DISCOUNT" }
    let(:coupon_percent_off) { 25 }
    let(:coupon_duration) { "repeating" }
    let(:coupon_duration_months) { 3 }
    let(:bronze_plan_id) { "BRONZE" }
    let(:silver_plan_id) { "SILVER" }
    let(:compare_plan_id) { "NONE" }
    let(:bronze_plan_amount) { 2500 }
    let(:silver_plan_amount) { 3000 }
    let(:bronze_plan_name) { "Bronze Plan" }
    let(:silver_plan_name) { "Silver Plan" }
    let(:plan_interval) { "month" }
    let(:plan_currency) { "usd" }

    # CREATE STRIPE CUSTOMER FUNCTION ----------------------------------------

    let(:stripe_customer){
      @customer = create_customer(@token, email)
      @user = FactoryGirl.create(:user_with_account)
      @user.account.customer_id = @customer.id
      sign_in @user

      # Setup for the stripe interactions

        @params = {
                    cardholder_name: name,
                    cardholder_email: email,
                    account: {stripe_cc_token: token.id}
        }

      @user.account.save_with_stripe(@params)
    }

     # CREATE STRIPE COUPON ----------------------------------------

   let(:create_stripe_coupon){
     @new_coupon = create_coupon(coupon_code, coupon_percent_off, coupon_duration,coupon_duration_months)
   }

  # DELETE STRIPE COUPON ----------------------------------------

   let(:delete_stripe_coupon){
     @new_coupon = delete_coupon(coupon_code)
   }

  # CREATE STRIPE SUBSCRIPTION PLANS ----------------------------------------

   let(:create_silver_plan){
     @new_plan = create_plan(silver_plan_id, silver_plan_name, silver_plan_amount, plan_interval, plan_currency)
   }
   let(:create_bronze_plan){
     @new_plan = create_plan(bronze_plan_id, bronze_plan_name, bronze_plan_amount, plan_interval, plan_currency)
   }

  # DELETE STRIPE SUBSCRIPTION PLANS ----------------------------------------

   let(:delete_silver_plan){
     @new_plan = delete_plan(silver_plan_id)
   }

   let(:delete_bronze_plan){
     @new_plan = delete_plan(bronze_plan_id)
   }




  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SubscriptionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:each){
   #signin_customer
   stripe_customer
   #create_stripe_coupon
   #create_silver_plan
   #create_bronze_plan

		subject.current_user.should_not be_nil
		subscription_fake_customers

		# Add the subscription to the current signed in user
		@user.subscription = @fake_subscription
  }

	after(:each) {
    #delete_stripe_coupon
    #delete_silver_plan
    #delete_bronze_plan
		delete_users
		Subscription.destroy_all
  }

  describe "GET index", :vcr do
    it "assigns all subscriptions as @subscriptions" do
      get :index
      assigns(:subscriptions).should be_present
    end
  end

  describe "GET show", :vcr do
    let(:show_params) {
      {id: @fake_subscription }
    }

    it "assigns the requested subscription as @subscription" do
      get :show, show_params
      assigns(:subscription).should eq(@fake_subscription)
    end
  end

  describe "GET new", :vcr do
    it "assigns a new subscription as @subscription" do
      get :new
      assigns(:subscription).should be_a_new(Subscription)
    end
  end

  describe "GET edit", :vcr do

    let(:edit_params){
      {
        id: @fake_subscription.id,
      }
    }

    it "assigns the requested subscription as @subscription" do
      get :edit, edit_params
      assigns(:subscription).should eq(@fake_subscription)
    end
  end

  describe "POST create", :vcr do

    describe "with valid params" do
      it "creates a new Subscription" do
        #pending
        expect {
          post :create, create_params
        }.to change(Subscription, :count).by(1)
      end

      it "assigns a newly created subscription as @subscription" do
        pending
        post :create, create_params
        assigns(:subscription).should be_a(Subscription)
        assigns(:subscription).should be_persisted
      end

      it "redirects to the created subscription" do
        pending
        post :create, create_params
        response.should redirect_to subscription_url(assigns(:subscription))
      end
    end

    describe "with invalid params", :vcr do
      it "assigns a newly created but unsaved subscription as @subscription" do
        pending
        # Trigger the behavior that occurs when invalid params are submitted
        Subscription.any_instance.stub(:save).and_return(false)
        post :create, create_params
        assigns(:subscription).should be_a_new(Subscription)
      end

      it "re-renders the 'new' template" do
        pending
        # Trigger the behavior that occurs when invalid params are submitted
        Subscription.any_instance.stub(:save).and_return(false)
        post :create, create_params
        response.should render_template("new")
      end
    end
  end

  describe "PUT update", :vcr do
    let(:new_fake_stripe_plan_id){ "999999999" }


    let(:update_params){
      {
        id: @fake_subscription.id,
        subscription: {
          stripe_plan_id: new_fake_stripe_plan_id,
        }
      }
    }

    describe "with valid params" do
      it "updates the requested subscription" do
        pending
        put :update, update_params
        assigns(:subscription).stripe_plan_id.should eq(new_fake_stripe_plan_id)
      end

      it "assigns the requested subscription as @subscription" do
        pending
        put :update, update_params
        assigns(:subscription).should eq(@fake_subscription)
      end

      it "redirects to the subscription" do
        pending
        put :update, update_params
        response.should redirect_to(@fake_subscription)
      end
    end

    describe "with invalid params" do
      it "assigns the subscription as @subscription" do
        pending
        Subscription.any_instance.stub(:save).and_return(false)
        put :update, update_params
        assigns(:subscription).should eq(@fake_subscription)
      end

      it "re-renders the 'edit' template" do
        pending
        # Trigger the behavior that occurs when invalid params are submitted
        Subscription.any_instance.stub(:save).and_return(false)
        put :update, update_params
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy", :vcr do
    let(:destroy_params){ {id: @fake_subscription.id } }

    it "destroys the requested subscription" do
      pending
      expect {
        delete :destroy, destroy_params
      }.to change(Subscription, :count).by(-1)
    end

    it "redirects to the subscriptions list" do
      pending
      delete :destroy, destroy_params
      response.should redirect_to(subscriptions_url)
    end
  end

end
