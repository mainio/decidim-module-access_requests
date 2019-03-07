# frozen_string_literal: true

require "spec_helper"

module Decidim::AccessRequests::Verification::Admin
  describe GrantedAuthorizationsController, type: :controller do
    controller described_class do
      # Since we cannot customize the route path for automatic detection of
      # the verification method handle, we are using a customized controller to
      # bypass the problem
      def verification_manifest_handle
        return "dummy" unless valid_manifest?

        "ar_verification"
      end

      def valid_manifest?
        true
      end
    end

    routes { Decidim::AccessRequests::Verification::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:organization) do
      create(:organization, available_authorizations: [verification_type])
    end
    let(:verification_type) { "ar_verification" }

    before do
      request.env["decidim.current_organization"] = user.organization
      sign_in user, scope: :user
    end

    describe "GET index" do
      before do
        create_list(
          :authorization,
          4,
          :granted,
          name: "ar_verification",
          organization: organization
        )
        create_list(
          :authorization,
          6,
          :pending,
          name: "ar_verification",
          organization: organization
        )
      end

      it "renders a list of granted authorizations" do
        get :index
        expect(assigns[:granted_authorizations].length).to eq(4)
        expect(subject).to render_template("decidim/access_requests/verification/admin/granted_authorizations/index")
      end

      context "when there are more than 15 granted results" do
        before do
          create_list(
            :authorization,
            20,
            :granted,
            name: "ar_verification",
            organization: organization
          )
        end

        it "paginates the results" do
          get :index
          expect(assigns[:granted_authorizations].length).to eq(15)
        end
      end
    end

    describe "GET new" do
      context "when the handler is valid" do
        it "renders the new template" do
          get :new
          expect(response).to have_http_status(:ok)
          expect(subject).to render_template("decidim/access_requests/verification/admin/granted_authorizations/new")
        end
      end

      context "when the handler is invalid" do
        it "redirects the user" do
          allow(subject).to receive(:valid_manifest?).and_return(false)

          get :new
          expect(response).to redirect_to("/admin/users")
        end
      end
    end

    describe "POST create" do
      let(:users) do
        create_list(
          :user,
          10,
          organization: organization
        )
      end

      context "when the params are valid" do
        it "redirects with notice message" do
          post :create, params: { user_id: users.sample.id }
          expect(flash[:notice]).not_to be_empty
          expect(subject).to redirect_to("/granted_authorizations")
        end
      end

      context "when the user already has a granted authorization" do
        let(:authorized_user) { users.sample }

        before do
          create(
            :authorization,
            :granted,
            name: "ar_verification",
            user: authorized_user
          )
        end

        it "redirects with alert message" do
          post :create, params: { user_id: authorized_user.id }
          expect(flash[:alert]).not_to be_empty
          expect(subject).to redirect_to("/granted_authorizations")
        end
      end
    end

    describe "DELETE destroy" do
      let(:authorized_user) { create(:user, organization: organization) }
      let(:authorization) do
        create(
          :authorization,
          :granted,
          name: "ar_verification",
          user: authorized_user
        )
      end

      context "when the params are valid" do
        it "redirects with notice message" do
          authorization_id = authorization.id
          expect do
            post :destroy, params: { id: authorization_id }
            expect(flash[:notice]).not_to be_empty
            expect(subject).to redirect_to("/granted_authorizations")
          end.to change(Decidim::Authorization, :count).by(-1)
        end
      end

      context "when the invalid authorization is provided" do
        it "redirects with alert" do
          authorization_id = authorization.id
          expect do
            post :destroy, params: { id: authorization_id + 10 }
            expect(flash[:alert]).not_to be_empty
            expect(subject).to redirect_to("/granted_authorizations")
          end.not_to change(Decidim::Authorization, :count)
        end
      end
    end
  end
end
