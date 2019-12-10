require 'rails_helper'

RSpec.describe MedicationsController, type: :controller do
  let(:valid_session) { {} }

  let(:invalid_attributes) {
    {}
  }

  describe "GET #index" do
    fixtures :users
    it "returns a success response" do
      @user = users(:patient_)
      sign_in @user
      Profile.create!(first_name: @user.first_name, last_name: @user.last_name, email: @user.email, whatsapp: '6198089569', user_holder_id: @user.user_holder.id)
      get :index, params: { "user_holder_id" => @user.user_holder.id }, session: valid_session
      expect(response).to be_success
    end
  end
#
  describe "GET #show" do
    fixtures :users
    fixtures :medications
    it "returns a success response" do
      @user = users(:patient_)
      sign_in @user
      @medication = medications(:m11)
      get :show, params: {"user_holder_id" => @user.user_holder.id, id: @medication.id}, session: valid_session
      expect(response).to be_success
    end
  end
#
  describe "GET #new" do
    fixtures :users
    fixtures :medications
    it "returns a success response" do
      @user = users(:patient_)
      sign_in @user
      @medication = medications(:m11)
      get :new, params: {"user_holder_id" => @user.user_holder.id}, session: valid_session
      expect(response).to redirect_to "/user_holders/"+ @user.user_holder.id.to_s + "/medications"
    end

  end
#
  describe "GET #edit" do
    fixtures :users
    fixtures :medications
    it "returns a success response" do
      @user = users(:patient_)
      sign_in @user
      @medication = medications(:m11)
      get :edit, params: {"user_holder_id" => @user.user_holder.id, id: @medication.id}, session: valid_session
      expect(response).to redirect_to "/user_holders/"+ @user.user_holder.id.to_s + "/medications"
    end

  end
#


  describe "POST #create - Patient" do
    fixtures :users
    fixtures :medications
    context "with valid params" do
      it "creates a new Medication" do
        @patient = users(:patient_)
        sign_in @patient
        attributes = { "provider" => "provider1",
            "name" => "name1",
            "directions" => "directions1",
            "days" => "days",
            "description" => "description1",
            "user_holder_id" => @patient.user_holder.id,
          }
        post :create, params: {"user_holder_id" => @patient.user_holder.id, medication: attributes}, session: valid_session
        expect(response).to redirect_to("/user_holders/"+ @patient.user_holder.id.to_s + "/medications")
      end
    end

    context "with invalid params" do
      it "creates a new Medication" do
        @patient = users(:patient_)
        sign_in @patient
        post :create, params: {"user_holder_id" => @patient.user_holder.id, medication: invalid_attributes}, session: valid_session
        expect(response).to redirect_to("/user_holders/"+ @patient.user_holder.id.to_s + "/medications")
      end
    end
  end

  describe "POST #create - Doctor" do
    fixtures :users
    fixtures :medications
    context "with valid params" do
      it "creates a new Medication" do
        @user = users(:doctor_)
        @patient = users(:patient_)
        attributes = { "provider" => "provider1",
            "name" => "name1",
            "directions" => "directions1",
            "days" => "days",
            "description" => "description1",
            "user_holder_id" => @patient.user_holder.id,
          }

        Profile.create!(first_name: @patient.first_name, last_name: @patient.last_name, email: @patient.email, whatsapp: '6198089569', user_holder_id: @patient.user_holder.id)
        sign_in @user
        expect {
          post :create, params: {"user_holder_id" => @patient.user_holder.id, medication: attributes}, session: valid_session
        }.to change(Medication, :count).by(1)
      end
    end

    context "with invalid params" do
      it "creates a new Medication" do
        @user = users(:doctor_)
        @patient = users(:patient_)
        Profile.create!(first_name: @patient.first_name, last_name: @patient.last_name, email: @patient.email, whatsapp: '6198089569', user_holder_id: @patient.user_holder.id)
        sign_in @user
        expect {
          post :create, params: {"user_holder_id" => @patient.user_holder.id, medication: invalid_attributes}, session: valid_session
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end


  describe "PUT #update - Patient" do
    fixtures :users
    fixtures :medications

    context "with valid params" do
      it "updates the requested medication" do
        @patient = users(:patient_)
        sign_in @patient
        attributes = { "provider" => "provider1",
            "name" => "name1",
            "directions" => "directions1",
            "days" => "days",
            "description" => "description1",
            "user_holder_id" => @patient.user_holder.id,
          }
        medication = Medication.create!(attributes)
        attributes2 = { "provider" => "provider2",
            "name" => "name2",
            "directions" => "directions2",
            "days" => "days2",
            "description" => "description2",
            "user_holder_id" => @patient.user_holder.id,
          }
        put :update, params: {"id" => medication.id ,"user_holder_id" => @patient.user_holder.id, medication: attributes2}, session: valid_session
        expect(response).to redirect_to("/user_holders/"+ @patient.user_holder.id.to_s + "/medications")
      end
    end

  end

  describe "PUT #update - Doctor" do
    fixtures :users
    fixtures :medications
    context "with valid params" do
      it "updates the requested medication" do
        @user = users(:doctor_)
        sign_in @user
        @patient = users(:patient_)
        attributes = { "provider" => "provider1",
            "name" => "name1",
            "directions" => "directions1",
            "days" => "days",
            "description" => "description1",
            "user_holder_id" => @patient.user_holder.id,
          }
        Profile.create!(first_name: @patient.first_name, last_name: @patient.last_name, email: @patient.email, whatsapp: '6198089569', user_holder_id: @patient.user_holder.id)
        medication = Medication.create!(attributes)
        attributes2 = { "provider" => "provider2",
            "name" => "name2",
            "directions" => "directions2",
            "days" => "days2",
            "description" => "description2",
            "user_holder_id" => @patient.user_holder.id,
          }
        put :update, params: {"id" => medication.id ,"user_holder_id" => @patient.user_holder.id, medication: attributes2}, session: valid_session
        medication.reload
        expect(medication.name).to eq("name2")
      end
    end
  end

  describe "DELETE #destroy - Patient" do
    fixtures :users
    fixtures :medications

    it "destroys the requested medication" do
      @user = users(:doctor_)
      sign_in @user
      @patient = users(:patient_)
      attributes = { "provider" => "provider1",
          "name" => "name1",
          "directions" => "directions1",
          "days" => "days",
          "description" => "description1",
          "user_holder_id" => @patient.user_holder.id,
        }
      Profile.create!(first_name: @patient.first_name, last_name: @patient.last_name, email: @patient.email, whatsapp: '6198089569', user_holder_id: @patient.user_holder.id)
      medication = Medication.create!(attributes)

      @user = users(:patient_)
      sign_in @user
      delete :destroy, params: {"id" => medication.id ,"user_holder_id" => @user.user_holder.id}, session: valid_session
      expect(response).to redirect_to("/user_holders/"+ @user.user_holder.id.to_s + "/medications")
    end
  end


  describe "DELETE #destroy - Doctor" do
    fixtures :users
    context "with valid params" do
      it "updates the requested medication" do
        @user = users(:doctor_)
        sign_in @user
        @patient = users(:patient_)
        attributes = { "provider" => "provider1",
            "name" => "name1",
            "directions" => "directions1",
            "days" => "days",
            "description" => "description1",
            "user_holder_id" => @patient.user_holder.id,
          }
        Profile.create!(first_name: @patient.first_name, last_name: @patient.last_name, email: @patient.email, whatsapp: '6198089569', user_holder_id: @patient.user_holder.id)
        medication = Medication.create!(attributes)
        expect {
          delete :destroy, params: {"id" => medication.id ,"user_holder_id" => @patient.user_holder.id}, session: valid_session
        }.to change(Medication, :count).by(-1)
      end
    end
  end

end
