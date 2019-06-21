FactoryBot.define do
  factory :enterprise, class: Enterprise do
    owner { FactoryBot.create :user }
    sequence(:name) { |n| "Enterprise #{n}" }
    sells 'any'
    description 'enterprise'
    long_description '<p>Hello, world!</p><p>This is a paragraph.</p>'
    address { FactoryBot.create(:address) }
  end

  factory :supplier_enterprise, parent: :enterprise do
    is_primary_producer true
    sells "none"
  end

  factory :distributor_enterprise, parent: :enterprise do
    is_primary_producer false
    sells "any"

    transient do
      with_payment_and_shipping false
    end

    after(:create) do |enterprise, proxy|
      if proxy.with_payment_and_shipping
        create(:payment_method,  distributors: [enterprise])
        create(:shipping_method, distributors: [enterprise])
      end
    end
  end

  factory :distributor_enterprise_with_tax, parent: :distributor_enterprise do
    charges_sales_tax { true }
    allow_order_changes { true }
  end
end