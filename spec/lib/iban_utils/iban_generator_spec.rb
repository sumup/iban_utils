require './spec/spec_helper'

describe IbanGenerator do
  include_context 'connection config'

  let(:valid_bank_details) { ['DE', '0648489890', '50010517'] }
  let(:invalid_bank_details) { ['DE', '0648489890', '66666666'] }

  subject(:generator) { IbanGenerator.new(connection_config) }

  describe '#generate' do
    context 'when bank details are valid' do
      it 'returns valid iban for Germany' do
        generator.generate('DE', '0648489890', '50010517').should == 'DE12500105170648489890'
      end

      it 'is valid for Netherlands' do
        generator.generate('NL', '484869868').should == 'NL18ABNA0484869868'
      end

      it 'is valid for Ireland' do
        generator.generate('IE', '10027952', '900017').should == 'IE92BOFI90001710027952'
      end

      it 'is valid for Austria' do
        generator.generate('AT', '22010010999', '14900').should == 'AT131490022010010999'
      end

      it 'is valid for Belgium' do
        generator.generate('BE', '844-0103700-34').should == 'BE68844010370034'
      end

      it 'is valid for France' do
        generator.generate('FR', '30066100410001057380116').should == 'FR7630066100410001057380116'
      end

      it 'is valid for Italy' do
        generator.generate('IT', '0300203280000400162854').should == 'IT68D0300203280000400162854'
      end

      it 'is valid for Poland' do
        generator.generate('PL', '37109024020000000610000434').should == 'PL37109024020000000610000434'
      end

      it 'is valid for Portugal' do
        generator.generate('PT', '003506830000000784311').should == 'PT50003506830000000784311'
      end

      it 'is valid for Spain' do
        generator.generate('ES', '20903200500041045040').should == 'ES1020903200500041045040'
      end

      it 'is valid for Switzerland' do
        generator.generate('CH', '16075473007', '8704').should == 'CH3908704016075473007'
      end

      it 'is valid for UK' do
        generator.generate('GB', '22859882', '402715').should == 'GB96MIDL40271522859882'
      end
    end

    context 'when bank details are invalid' do
      specify { generator.generate(*invalid_bank_details).should be_nil }
    end
  end

  describe '#response' do
    subject { generator.response }

    context 'when bank details are valid' do
      before(:each) { generator.generate(*valid_bank_details) }

      it { should be_passed }
      it { should be_found }
    end

    context 'when bank details are invalid' do
      before(:each) { generator.generate(*invalid_bank_details) }

      it { should_not be_passed }
      it { should_not be_found }
    end
  end
end
