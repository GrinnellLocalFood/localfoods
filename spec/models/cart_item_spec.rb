require 'spec_helper'

describe CartItem do
  it { should validate_presence_of :item_id}
  it { should validate_presence_of :cart_id}
end
