# frozen_string_literal: true

require_relative '../helpers/test_const_overrides'

describe ActiveRecord::Mysql::Enum::EnumColumnAdapter do
  include ConstantOverrides::TestConstOverride

  context "adapter not found" do
    before do
      if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter::Column
        unset_test_const("ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::Column")
      end

      if defined? ActiveRecord::ConnectionAdapters::MySQL::Column
        unset_test_const("ActiveRecord::ConnectionAdapters::MySQL::Column")
      end
    end

    after do
      cleanup_constant_overrides
    end

    it "raises" do
      expect { ActiveRecord::Mysql::Enum.mysql_column_adapter }.to raise_error(RuntimeError, "could not find MySQL::Column or equivalent connection adapter")
    end
  end

  let(:test_column) { ActiveRecord::Mysql::Enum::ActiveRecordColumnWithEnums.new("test column", "default", column_type) }

  context "as an Enum column" do
    let(:column_type) { ActiveRecord::Type::Enum.new }

    it "creates a new Column" do
      expect(test_column).to be_a ActiveRecord::Mysql::Enum::ActiveRecordColumnWithEnums
    end
  end

  context "as a String column (calling super)" do
    let(:column_type) { ActiveRecord::Type::String.new }

    it "creates a new Column" do
      expect(test_column).to be_a ActiveRecord::Mysql::Enum::ActiveRecordColumnWithEnums
    end
  end
end
