# frozen_string_literal: true

require "spec_helper"

module Decidim
  module AccessRequests
    module Verification
      describe AuthorizationPresenter do
        describe ".for_collection" do
          let(:authorizations) do
            create_list(
              :authorization,
              3,
              :pending,
              name: "ar_verification"
            )
          end

          it "returns an array of presenters" do
            presenters = described_class.for_collection(authorizations)
            expect(presenters.length).to eq(3)
            expect(presenters).to all(be_a(described_class))
          end
        end
      end
    end
  end
end
