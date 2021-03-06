require 'spec_helper'

describe Metasploit::Model::Search::Operator::Attribute do
  it { should be_a Metasploit::Model::Search::Operator::Single }

  context 'CONSTANTS' do
    context 'TYPES' do
      subject(:types) do
        described_class::TYPES
      end

      it { should include(:boolean) }
      it { should include(:date) }
      it {
        should include(
                   {
                       set: :integer
                   }
               )
      }
      it {
        should include(
                   {
                       set: :string
                   }
               )
      }
      it { should include(:integer) }
      it { should include(:string) }
    end
  end

  context 'validations' do
    it { should validate_presence_of(:attribute) }
    it { should ensure_inclusion_of(:type).in_array(described_class::TYPES) }
  end

  context '#attribute_enumerable' do
    subject(:attribute_set) do
      attribute_operator.attribute_set
    end

    let(:attribute) do
      :set_attribute
    end

    let(:attribute_operator) do
      described_class.new(
          attribute: attribute,
          klass: klass
      )
    end

    let(:expected_attribute_set) do
      Set.new [:a, :b]
    end

    let(:klass) do
      Class.new.tap { |klass|
        expected_attribute_set = self.expected_attribute_set

        klass.define_singleton_method("#{attribute}_set") do
          expected_attribute_set
        end
      }
    end

    context 'with responds to #attribute_set_method_name' do
      let(:expected_attribute_set) do
        Set.new(
            [
                :a,
                :b,
                :c
            ]
        )
      end

      it 'should be #klass #<attribute>_set' do
        attribute_set.should == expected_attribute_set
      end
    end
  end

  context '#name' do
    subject(:name) do
      attribute_operator.name
    end

    let(:attribute) do
      FactoryGirl.generate :metasploit_model_search_operator_attribute_attribute
    end

    let(:attribute_operator) do
      described_class.new(
          :attribute => attribute
      )
    end

    it 'should be #attribute' do
      name.should == attribute
    end
  end
end