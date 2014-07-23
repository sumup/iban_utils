require './spec/spec_helper'

describe IbanGenerator do
  include_context 'connection config'

  subject(:validation) { IbanValidation.new(connection_config) }

  describe '#validate' do
    subject { validation.validate(iban) }

    context 'when iban is valid' do
      let(:iban) { 'CH3908704016075473007' }
      it { should be true }
    end

    context 'when iban is invalid' do
      let(:iban) { 'CHLOL12344444016075473007' }
      it { should be false }
    end
  end

  describe '#response' do
    before(:each) { validation.validate(iban) }
    subject { validation.response }

    context 'when iban is valid' do
      let(:iban) { 'CH3908704016075473007' }

      it { should be_passed }
      it { should be_found }

      it 'has correct swift detail' do
        subject.details[:swift].should == 'AEKTCH22XXX'
      end
    end

    context 'when iban is invalid' do
      let(:iban) { 'CHLOL12344444016075473007' }

      it { should_not be_passed }
      it { should_not be_found }
      its(:details) { should be_empty }
    end
  end
end
