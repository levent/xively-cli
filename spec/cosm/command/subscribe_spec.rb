require "spec_helper"
require "cosm/command/subscribe"

describe Cosm::Command::Subscribe do
  describe "subscribe" do

    it "runs with options" do
      execute "subscribe --tail --num 2 --ps ps.3 --source source.4"
    end

    it "should really be tested"

  end

end
