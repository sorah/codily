require 'spec_helper'

require 'codily/utils'

describe Codily::Utils do
  describe ".symbolize_keys" do
    context "simple" do
      subject { described_class.symbolize_keys('foo' => 'bar') }
      it { is_expected.to eq(foo: 'bar') }
    end

    context "array" do
      subject { described_class.symbolize_keys('foo' => ['a', 'b' => 'c']) }
      it { is_expected.to eq(foo: ['a', b: 'c']) }
    end

    context "nest1" do
      subject { described_class.symbolize_keys('foo' => ['a', 'b' => {'c' => 'd'}]) }
      it { is_expected.to eq(foo: ['a', b: {c: 'd'}]) }
    end
  end
end
